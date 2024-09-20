(defvar bar-buffer nil
  "The buffer for the bar.")

(defvar bar-timer nil
  "The timer for the bar.")

(defvar left-modules nil
  "The left-aligned modules.")
(defvar centre-modules nil
  "The centered modules.")
(defvar right-modules nil
  "The right-aligned modules.")
(defvar bar-separator "  "
  "The separator for multiple modules in the same place (left/centre/right)")

(defun bar/bar-p (&optional window)
  (window-parameter (window-normalize-window window) 'bar/bar))
(defun bar/get-bar-window (&optional frame)
  (->> frame window-normalize-frame window-list (seq-filter #'bar/bar-p) car))
(defun bar/get-all-bar-windows ()
  (->> (frame-list) (mapcar #'window-list) flatten-list (seq-filter #'bar/bar-p)))

(defun bar/remove-window (&optional window)
  (let ((window (window-normalize-window window))
	(frame (window-frame window)))
    (when (window-parameter window 'bar/bar)
      (error "Attempt to delete bar"))
    (when (and (length= (window-list frame) 2)
	       (bar/get-bar-window frame))
      (error "Attempt to delete sole ordinary window"))))

(defun bar/frame-add-bar (frame)
  (unless (bar/get-bar-window frame)
    (let ((inhibit-message t)
	  (window (split-window (frame-root-window frame) nil 'above)))
      (set-window-parameter window 'bar/bar         t)
      (set-window-parameter window 'no-other-window t) ; can't select with keybinds

      ;; sometimes, `delete-other-windows' calls `delete-other-windows-internal',
      ;; bypassing the normal `delete-window' advice that prevents bars from being deleted.
      (set-window-parameter window 'no-delete-other-windows t) ; `delete-other-windows' can't close it

      (with-selected-window window
	(setq bar-buffer (switch-to-buffer " *bar*"))
	(setq mode-line-format nil)
	(face-remap-add-relative 'default :height 150)
	(setq window-size-fixed nil)
	(fit-window-to-buffer window nil 2)
      	(setq window-size-fixed t))

      ;; don't open other buffers in the window
      (set-window-dedicated-p window t))))

(defun bar/remove-line-numbers-from-bar ()
  (when bar-buffer
    (with-current-buffer bar-buffer
      (when display-line-numbers
	(display-line-numbers-mode -1)))))
(add-hook 'display-line-numbers-mode-hook        #'bar/remove-line-numbers-from-bar)
(add-hook 'global-display-line-numbers-mode-hook #'bar/remove-line-numbers-from-bar)

(defun bar/bar-all-workspaces ()
  (mapcar #'bar/frame-add-bar exwm-workspace--list))
(defun bar ()
  (interactive)
  (advice-add #'delete-window :before #'bar/remove-window)
  (bar/bar-all-workspaces)
  (bar/remove-line-numbers-from-bar)
  (add-hook 'exwm-workspace-list-change-hook #'bar/bar-all-workspaces)
  (when (timerp bar-timer) (cancel-timer bar-timer))
  (setq bar-timer (run-with-timer 0 1 #'update-bar)))
(defun unbar ()
  (interactive)
  (advice-remove #'delete-window #'bar/remove-window)
  (mapcar #'delete-window (bar/get-all-bar-windows))
  (remove-hook 'exwm-workspace-list-change-hook #'bar/bar-all-workspaces)
  (when (timerp bar-timer) (cancel-timer bar-timer)))

(defun bar/string-pixel-width (s)
  (with-selected-window (bar/get-bar-window)
    (let ((old (buffer-substring-no-properties (point-min) (point-max))))
      (erase-buffer)
      (insert s)
      (prog1
	  (car (window-text-pixel-size))
	(erase-buffer)
	(insert old)))))
(defun compute-module (module)
  (string-join (remove nil (mapcar #'funcall module)) bar-separator))
(defun update-bar ()
  (when (bar/get-bar-window)
    (with-selected-window (bar/get-bar-window)
      ;; as far as i can figure out, the width of the right margin which displays the / on too-long lines
      ;; is the width of one character.
      ;; however, we can't display there, so we also need to add a space to the right side,
      ;; to balance it.
      (let* ((w (- (window-body-width nil t) (* 2 (car (window-text-pixel-size nil 1 2)))))
	     (left   (compute-module left-modules))
	     (centre (compute-module centre-modules))
	     (right  (compute-module right-modules))
	     (left-spacing
	      (- (floor (/ w 2.0))
		 (bar/string-pixel-width left)
		 (floor (/ (bar/string-pixel-width centre) 2.0))))
	     (right-spacing
	      (- (ceiling (/ w 2.0))
		 (bar/string-pixel-width right)
		 (ceiling (/ (bar/string-pixel-width centre) 2.0))))
	     (line (concat " " left " " centre " " right))
	     (left-space  (length (concat " " left " ")))
	     (right-space (length (concat " " left " " centre " "))))
	(erase-buffer)
	(insert line)
	(add-display-text-property left-space (1+ left-space) 'display `(space . (:width (,left-spacing))))
	(add-display-text-property right-space (1+ right-space) 'display `(space . (:width (,right-spacing))))
	(setq cursor-type nil)))))


(defun file-to-string (file)
  (with-temp-buffer
    (insert-file-contents file)
    (string-trim (buffer-string))))

(defun battery ()
  (let* ((plug-status (file-to-string "/sys/class/power_supply/AC0/online"))
	 (battery-plugged-in (if (equal plug-status "1") "plugged in" "not plugged in"))
	 (battery-percent (file-to-string "/sys/class/power_supply/BAT0/capacity")))
    (concat battery-plugged-in " " battery-percent "%")))
(setq left-modules `(,#'battery))

(defun time-and-date ()
  (-> "%B %-d %Y %-I:%M:%S %p" format-time-string downcase))
(setq centre-modules `(,#'time-and-date))

(defun vol ()
  (pcase-let ((`(,level ,onoff)
	       (-> (shell-command-to-string "amixer get Master | grep Left:")
		    (split-string)
		    (seq-drop 4))))
    (if (equal onoff "[off]")
	"muted"
      (concat "vol " (substring level 1 -1)))))
(defun light ()
  (let ((level
	 (->> (shell-command-to-string "brightnessctl | grep %")
	      (split-string)
	      (last)
	      (car))))
    (concat "light " (substring level 1 -1))))
(defun internet ()
  (unless (equal "up" (file-to-string "/sys/class/net/wlo1/operstate"))
    "not connected"))

(setq right-modules `(,#'internet ,#'vol ,#'light))

(provide 'bar)
