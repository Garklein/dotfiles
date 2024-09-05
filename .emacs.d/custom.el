(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval progn
	   (require 'dash)
	   (set-command
	    (when
		(not
		 (eq major-mode 'text-mode))
	      (-some->
		  (get-buffer "server")
		(kill-buffer))
	      (-some->
		  (get-buffer "server")
		(kill-buffer))
	      (async-shell-command "cd ${PWD%/InfiniteLoopers*}/InfiniteLoopers && make server" "server")
	      (async-shell-command "cd ${PWD%/InfiniteLoopers*}/InfiniteLoopers && make client" "client"))))
     (nil
      (eval progn
	    (require 'dash)
	    (set-command
	     (when
		 (not
		  (eq major-mode 'text-mode))
	       (-some->
		   (get-buffer "server")
		 (kill-buffer))
	       (-some->
		   (get-buffer "server")
		 (kill-buffer))
	       (async-shell-command "cd ${PWD%/InfiniteLoopers*}/InfiniteLoopers && make server" "server")
	       (async-shell-command "cd ${PWD%/InfiniteLoopers*}/InfiniteLoopers && make client" "client")))))
     (eval progn
	   (require 'dash)
	   (set-command
	    (progn
	      (-some->
		  (get-buffer "server")
		(kill-buffer))
	      (-some->
		  (get-buffer "server")
		(kill-buffer))
	      (async-shell-command "cd ${PWD%/InfiniteLoopers*}/InfiniteLoopers && make server" "server")
	      (async-shell-command "cd ${PWD%/InfiniteLoopers*}/InfiniteLoopers && make client" "client")))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
