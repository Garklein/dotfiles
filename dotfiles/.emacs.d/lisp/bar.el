;; todo: make it not stop the timer if something goes wrong with a module, refactor

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
	(setq-local evil-normal-state-cursor '(bar . 0))
	(setq mode-line-format
	      '((:eval (propertize "" 'display '(raise 1)))))
	(face-remap-add-relative 'default :height 150)
	(setq window-size-fixed nil)
	(fit-window-to-buffer window nil 3)
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

;; string-pixel-width doesn't work for some reason
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
      ;; need to disable read only up here since bar/string-pixel-width modifies the buffer
      (read-only-mode -1)

      ;; window-body-width includes the column reserved for the continuation glyph
      ;; this means we need to subtract 2 characters from the width,
      ;; and we will also need to add a space to the left side to balance it.
      (let* ((w (- (window-body-width nil t) (* 2 (car (window-text-pixel-size nil 1 2)))))
	     (left   (compute-module left-modules))
	     (centre (compute-module centre-modules))
	     (right  (compute-module right-modules))
	     (left-spacing
	      (- (/ w 2)
		 (bar/string-pixel-width left)
		 (/ (bar/string-pixel-width centre) 2)))
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
	(read-only-mode)))))


(defun file-to-string (file)
  (with-temp-buffer
    (insert-file-contents file)
    (string-trim (buffer-string))))
(defun file-to-float (file)
  (-> file file-to-string string-to-number float))

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
  (let* ((max-brightness (float (string-to-number (file-to-string "/sys/class/backlight/intel_backlight/max_brightness"))))
	 (actual-brightness (float (string-to-number (file-to-string "/sys/class/backlight/intel_backlight/actual_brightness"))))
	 (level (round (* 100 (/ actual-brightness max-brightness)))))
    (concat "light " (number-to-string level) "%")))
(defun internet ()
  (unless (equal "up" (file-to-string "/sys/class/net/wlo1/operstate"))
    "not connected"))

(setq right-modules `(,#'internet ,#'vol ,#'light))

(provide 'bar)
