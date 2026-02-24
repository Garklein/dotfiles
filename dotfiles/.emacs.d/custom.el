;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a69d87417dec379803ec515d79a24e447c70472dfec909ebe19a637ef2bf63d2"
     "13caab97e2e8288850ee91d66930be97b8a008eb53fe181964007971615c7cdc"
     "1cdd9baecc9619169eea790d53b36dc0e017f8465d46d1218c2b7cfeae701ae1"
     "57d1894a7433ae4dfcb8c5469202aa1342477b6cfbc8f88ce86b61a415cf8d77"
     default))
 '(ignored-local-variable-values
   '((eval run-term-command "cd ~/repos/mlatu" "make" "./repl")))
 '(safe-local-variable-values
   '((eval set-command
	   (compile
	    "nix-shell --run 'cd ~/shark && make run' ~/shark/shell.nix"))
     (eval set-command
	   (compile
	    "nix-shell --run 'cd ../.. && make run' ../../shell.nix"))
     (eval set-command
	   (compile "nix-shell --run 'make run' ../../shell.nix"))
     (eval set-command (compile "nix-shell --run 'make run'"))
     (eval set-command
	   (lambda (interactive) (message "test")
	     (compile "nix-shell --run 'make run'")))
     (eval set-command
	   (lambda (interactive)
	     (compile "nix-shell --run 'make run'")))
     (eval set-command
	   (lambda (interactive)
	     (async-shell-command "nix-shell --run 'make run'")))
     (eval set-command
	   (with-file-name "iog"
			   (let ((num (file-name-base file-name)))
			     (concat
			      "ruby ~/dormant/iogii/src/main.rb -hs -pp "
			      file-name
			      " > /tmp/a.hs && runhaskell -w /tmp/a.hs < i/"
			      num ".in"))))
     (eval set-command
	   (with-file-name "iog"
			   (let
			       ((num
				 (file-name-sans-extension file-name)))
			     (concat
			      "ruby ~/dormant/iogii/src/main.rb -hs -pp "
			      file-name
			      " > /tmp/a.hs && runhaskell -w /tmp/a.hs < i/"
			      num ".in"))))
     (eval set-command
	   (with-file-name "iog"
			   (let
			       ((num
				 (file-name-sans-extension file-name)))
			     (concat
			      "ruby ~/dormant/iogii/src/main.rb -hs -pp "
			      file-name
			      " > /tmp/a.hs && runhaskell -w /tmp/a.hs < i/"
			      (number-to-string num) ".in"))))
     (eval set-command (compile "cd ~/manzikert && ./build"))
     (eval unless (equal (buffer-name) "COMMIT_EDITMSG")
	   (set-command (compile "cd ~/manzikert && ./build")))
     (eval progn (electric-indent-local-mode 0)
	   (setq indent-line-function
		 (lambda nil (interactive) (insert "  ")))
	   (set-command (with-file-name "py" "uv run main.py")))
     (eval progn (electric-indent-local-mode 0)
	   (setq indent-line-function
		 (lambda nil (interactive) (insert "  ")))
	   (set-command "uv run main.py"))
     (eval progn (electric-indent-local-mode 0)
	   (setq indent-line-function
		 (lambda nil (interactive) (insert "  "))))
     (eval unless (equal (buffer-name) "COMMIT_EDITMSG")
	   (set-command (compile "cd ~/garklein.github.io && ./build")))))
 '(warning-suppress-log-types '((lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
