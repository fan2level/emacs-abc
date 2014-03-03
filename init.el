;; 
(setq make-backup-files nil)

;; 
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(set-cursor-color "red")
(show-paren-mode t)
(setq initial-frame-alist
      '((top . 1)
	(left . 1)))
(setq dired-listing-switches "-lh")

;; 
(require 'cc-mode)
(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (hide-ifdef-mode)
	     (gtags-mode 1)
	     ))
(autoload 'hide-ifdef-mode "hideif" nil t)
(add-hook 'hide-ifdef-mode-hook
	  (lambda ()
	    (setq hide-ifdef-shadow t)
	    (hide-ifdefs "")
	    ))
(autoload 'gtags-mode "gtags" nil t)
(setq gtags-suggested-key-mapping t)
