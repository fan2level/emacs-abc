;; package
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; key mapping
(global-set-key (kbd "<f1>") 'undefined)
(global-set-key (kbd "<f2>") 'undefined)
(global-set-key (kbd "<f3>") 'undefined)
(global-set-key (kbd "<f4>") 'undefined)
(global-set-key (kbd "<f5>") 'undefined)
(global-set-key (kbd "<f6>") 'undefined)
(global-set-key (kbd "<f7>") 'undefined)
(global-set-key (kbd "<f8>") 'undefined)
(global-set-key (kbd "<f9>") 'undefined)
(global-set-key (kbd "<f10>") 'undefined)
(global-set-key (kbd "<f11>") 'undefined)
(global-set-key (kbd "<f12>") 'undefined)

;; settings ui
(setq make-backup-files nil)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(set-cursor-color "red")
(set-background-color "honeydew")
(show-paren-mode t)
(transient-mark-mode t)
(setq initial-frame-alist
      '((top . 1)
	(left . 1)))

(setq large-file-warning-threshold 90000000)
(require 'dired)
(setq dired-listing-switches "-lh")

;; c
(require 'cc-mode)
(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (hide-ifdef-mode)
	     (gtags-mode 1)
	     ))
(define-key c-mode-map (kbd "M-q") 'ff-find-other-file)
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (font-lock-add-keywords nil
				    '(("\\<\\(fixme\\|FIXME\\|todo\\|TODO\\|checkme\\|caution\\)" 1 font-lock-warning-face t)))
	    ))

;; hide-ifdef
(setq hide-ifdef-initially t)
(setq hide-ifdef-shadow t)
(add-hook 'c-mode-common-hook '(lambda ()
				 (hide-ifdef-mode 1)
				 ))

;; perl-mode
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook '(lambda ()
			      ;; evaluation perl script
			      (local-set-key (kbd "M-p") '(lambda () (interactive)
							    (let ((shell-param)
								  (buffer-name "*perl evaluation*"))
							      (setq shell-param (format "perl %s" (concat (file-name-nondirectory (buffer-file-name)))))
							      (shell-command shell-param (get-buffer-create buffer-name))
							      ;; (switch-to-buffer-other-window buffer-name)
							      )))
			      (local-set-key (kbd "C-h f") '(lambda () (interactive)
							      (let ((buffer-name "*perdoc*"))
								(if (not (equal (shell-command (format "perldoc -m %s" (select-word)) (get-buffer-create buffer-name)) 0))
								    (shell-command (format "perldoc -f %s" (select-word)) (get-buffer-create buffer-name)))
								)))
			      ))

;; graphviz mode
;; todo

;; org mode
;; todo

;; gnu global
;; todo

;; glistup mode
;; todo

;; hideif-configuration
;; todo
