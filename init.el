(global-set-key (kbd "<f1>") (lambda () (interactive)
			       (call-process "explorer.exe" nil nil nil ".")))
(global-set-key (kbd "<f2>") 'undefined)
(global-set-key (kbd "<f3>") 'undefined)
(global-set-key (kbd "<f4>") 'undefined)
(global-set-key (kbd "<f5>") (lambda () (interactive)
			       (revert-buffer :ignore-auto :noconfirm)))
(global-set-key (kbd "<f6>") 'undefined)
(global-set-key (kbd "<f7>") 'highlight-select-word)
(global-set-key (kbd "<f8>") 'shrink-window)
(global-set-key (kbd "<f9>") 'enlarge-window)
(global-set-key (kbd "<f10>") 'undefined)
(global-set-key (kbd "<f11>") 'undefined)
(global-set-key (kbd "<f12>") 'undefined)
(global-set-key (kbd "\C-hc") 'describe-char)
(global-set-key (kbd "C-<left>") 'previous-buffer)
(global-set-key (kbd "C-<right>") 'next-buffer)

(when (eq system-type 'windows-nt)
  (setenv "PATH"
	  (concat
	   "c:/iam/bin" ";"
	   (getenv "PATH")
	   ))
  (setq default-directory "c:/iam")
  (set-frame-font "DejaVu Sans Mono-16" nil t)
  )

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(setq make-backup-files nil)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(set-cursor-color "red")
(set-background-color "honeydew")
(show-paren-mode t)
(transient-mark-mode t)

(use-package package
  :ensure t
  :config
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (setq package-check-signature nil))
(use-package dired
  :defer t
  :init
  (setq ls-lisp-dirs-first t)
  :config
  (setq dired-listing-switches "-lh"))
(use-package markdown-mode
  :ensure t
  :defer t)
(use-package python-mode
  :ensure t
  :defer t
  :mode ("\\.py\\'" "\\.SConstruct\\'")
  :bind (("M-p" . (lambda (&optional file)
		    (interactive)
		    (let ((filename (or file (concat (file-name-nondirectory (buffer-file-name)))))
			  (buffer-name "*python evaluation*"))
		      (setq shell-param (format "python %s" (concat (file-name-nondirectory (buffer-file-name)))))
		      (shell-command
		       (format "python %s" filename) (get-buffer-create buffer-name)))))
	 ("<f1>" . (lambda (&optional symbol)
		     (interactive)
		     (let ((help (or symbol (select-word)))
			   (buffer-name "*python document*")
			   )
		       (shell-command
			(format "python c:/Python37-32/Lib/pydoc.py %s" help) (get-buffer-create buffer-name))
		       ))))
  )
(use-package cperl-mode
  :ensure t
  :defer t
  :bind (("M-p" . (lambda ()
		    (interactive)
		    (let ((shell-param)
			  (buffer-name "*perl evaluation*"))
		      (setq shell-param (format "perl %s" (concat (file-name-nondirectory (buffer-file-name)))))
		      (shell-command shell-param (get-buffer-create buffer-name))
		      )))))
(use-package bitbake
  :ensure t
  :defer t
  :mode ("\\.bb\\'" "\\.bbappend\\'" "\\.bbclass\\'"))
(use-package yasnippet
  :ensure t
  :defer t
  :config
  (setq yas-global-mode 1)
  (yas-reload-all))
(use-package plantuml-mode
  :defer t
  :config
  (when (eq system-type 'windows-nt)
    (setq plantuml-jar-path "c:/iam/plantuml/plantuml-1.2023.5.jar")
    (setq plantuml-default-exec-mode 'jar))
  :mode ("\\.puml\\'"))
(use-package cc-mode
  :defer t
  :config
  (setq indent-tabs-mode nil)
  ;; (setq-default tab-width 4)
  :bind (("M-q" . 'ff-find-other-file)
         ))

;; (require 'cc-mode)
;; (add-hook 'c-mode-common-hook
;; 	  (lambda ()
;; 	    (gtags-mode 1)
;; 	    (hide-ifdef-mode)
;; 	    (font-lock-add-keywords nil
;; 				    '(("\\<\\(fixme\\|FIXME\\|todo\\|TODO\\|checkme\\|caution\\)" 1
;; 				       font-lock-warning-face t)))
;; 	    (local-set-key (kbd "M-e") 'glistup-mode)
;; 	    (local-set-key (kbd "<f2>") (lambda() (interactive)
;; 					  (c-end-of-defun)
;; 					  (c-end-of-defun)
;; 					  (c-beginning-of-defun)))
;; 	    (local-set-key (kbd "C-<f2>") 'c-beginning-of-defun)
;; 	    (setq indent-tabs-mode nil)
;; 	    (setq-default tab-with 4)
;; 	    ))
;; (define-key c-mode-map (kbd "M-q") 'ff-find-other-file)

;; ;; c++-mode
;; (add-hook 'c++-mode-hook
;; 	  (lambda ()
;; 	    (gtags-mode 1)
;; 	    (yas-minor-mode 1)
;; 	    (setq-default tab-with 4)
;; 	    (local-set-key (kbd "M-q" 'ff-find-other-file))
;; 	    ))
;; (define-key c++-mode-map (kbd "M-q") 'ff-find-other-file)
;; (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; --------------------------------------------------
;; mode
;; --------------------------------------------------
;; nxml-mode
(require 'sgml-mode)
(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))

(add-hook 'nxml-mode-hook
	  (lambda ()
	    (hs-minor-mode)
	    (local-set-key (kbd "M-p") (lambda () (interactive)
					 (browse-url (file-name-nondirectory (buffer-file-name)))
					 ))
	    ;; (local-set-key (kbd "TAB") (lambda () (interactive)
	    ;; 			       (hs-toggle-hiding)
	    ;; 			       ))
	    ))
(add-hook 'html-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-p") (lambda () (interactive)
					 (browse-url (file-name-nondirectory (buffer-file-name)))
					 ))
	    ))
(setq auto-mode-alist (append '(("\\.xsd$" . xml-mode)
				)
			      auto-mode-alist))

;; org-mode
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)

(setq org-todo-keywords
      '(
	;; (sequence "TODO" "|" "DONE")
	(sequence "TODO" "DOING" "FIXME" "CHECK" "|" "DONE")
	;; (type "bsp" "model" "|" "DONE")
	))
(setq org-todo-keyword-faces
      '(("TODO" . org-warning) 
	("FIXME" . org-warning)
	("CHECK" . (:foreground "blue" :background "yellow" :weight bold))
	("DOING" . (:foreground "blue" :background "yellow" :weight bold))
	))
(add-hook 'org-mode-hook (lambda () 
			   (progn 
			     (turn-on-font-lock)
			     (setq tab-width 4)
			     )))

;; visual basic mode
;; (load-file "c:/iam/emacs/site-lisp/visual-basic-mode.el")
;; (setq auto-mode-alist (append '(("\\.bas$" . visual-basic-mode)
;; 				("\\.cls$" . visual-basic-mode)
;; 				("\\.frm$" . visual-basic-mode)
;; 				)
;; 			      auto-mode-alist))

;; graphviz-mode
(require 'graphviz-dot nil t)
(defun graphviz-dot-preview2 ()
  "preview dot files"
  (interactive)
  (let ((preview-buffer-name)
	(shell-param)
	(current-filename))

    (setq preview-buffer-name (concat "*graphviz preview*" " " buffer-file-name))
    (if (get-buffer preview-buffer-name)
	(kill-buffer preview-buffer-name)
      )
    (setq current-filename (concat (file-name-nondirectory (buffer-file-name))))
    (setq shell-param (format "dot -Tpng %s" current-filename))
    (shell-command shell-param (get-buffer-create preview-buffer-name))
    (switch-to-buffer-other-window preview-buffer-name)
    (image-mode)
    (setq buffer-read-only t)
    (previous-multiframe-window)
    )
  )
(add-to-list 'file-coding-system-alist '(("\\.dot\\'" . utf-8-with-signature)))
(add-hook 'graphviz-dot-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq graphviz-dot-indent-width 4)
	    (setq graphviz-dot-auto-indent-on-semi nil)
	    (local-set-key (kbd "M-p") 'graphviz-dot-preview2)
	    )
	  )

;; ;; gtags-mode
;; (autoload 'gtags-mode "gtags" "" t)
;; ;; (require 'gtags)
;; (setq gtags-suggested-key-mapping t)
;; (add-hook 'c-mode-hook (lambda () (gtags-mode 1)))
;; (add-hook 'c++-mode-hook (lambda () (gtags-mode 1)))
;; (add-hook 'after-save-hook
;; 	  (lambda ()
;; 	    (and (boundp 'gtags-mode) gtags-mode
;; 		 (let (root-dir current-dir shell-param)
;; 		   (setq root-dir (gtags-get-rootpath))
;; 		   ;; valid if gtags exist
;; 		   (if root-dir
;; 		       (progn
;; 		   	 (setq current-dir (file-name-directory buffer-file-name))
;; 		   	 (setq shell-param (concat "gtags --single-update " buffer-file-name))
;; 		   	 (cd root-dir)
;; 		   	 (shell-command shell-param)
;; 		   	 (cd current-dir)
;; 		   	 )
;; 		     )
;; 		   )
;; 		 )
;; 	    )
;; 	  )

;; (setq gtags-mode-hook
;;       (lambda ()
;; 	(setq gtags-path-style 'relative)
;; 	(setq gtags-pop-delete t)
;; 	;; (setq gtags-suggested-key-mapping t)
;; 	;; (setq gtags-auto-update t)
;; 	))

;; (defun gtags-select-next-line-other-window ()
;;   "Select tags to other windows"
;;   (interactive)
;;   (forward-line 1)
;;   (gtags-select-tag-other-window)
;;   (previous-multiframe-window)
;;   )
;; (defun gtags-select-previous-line-other-window ()
;;   "Select tags to other windows"
;;   (interactive)
;;   (forward-line -1)
;;   (gtags-select-tag-other-window)
;;   (previous-multiframe-window)
;;   )
;; (defun gtags-select-pop-stack ()
;;   "pop stack"
;;   (interactive)
;;   (gtags-pop-stack)
;;   )
;; (setq gtags-select-mode-hook
;;       (lambda ()
;; 	;; (local-set-key (kbd "M-*") 'gtags-pop-stack)
;; 	(local-set-key (kbd "C-t") 'gtags-select-pop-stack)
;; 	;; (local-set-key (kbd "n") 'next-line)
;; 	;; (local-set-key (kbd "p") 'previous-line)
;; 	(local-set-key (kbd "n") 'gtags-select-next-line-other-window)
;; 	(local-set-key (kbd "p") 'gtags-select-previous-line-other-window)
;; 	(local-set-key (kbd "ESC") 'gtags-select-pop-stack)
;; 	;; first tags is selected to other window
;; 	;; (split-window-below)
;; 	;; (gtags-select-tag-other-window)
;; 	;; (previous-multiframe-window)
;; 	))

;; gnuplot
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode))
			      auto-mode-alist))
(add-hook 'gnuplot-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-p") 'gnuplot-etc-preview)
	    )
	  )
;; (require 'gnuplot)
;; (setq gnuplot-program (executable-find "gnuplot"))

(defun gnuplot-etc-preview (&optional file)
  "gnuplot using emacs"
  (interactive)
  (let ((filepath)
	(buffer-name "*gnuplot*")
	)
    (if (get-buffer buffer-name)
	(kill-buffer buffer-name))
    (if file
	(setq filepath file)
      (setq filepath (buffer-file-name))
      )
    
    (with-temp-buffer
      (insert "gnuplot -e \"")

      (insert "set term jpeg size 1400,400" ";")
      (insert "set style data linespoints" ";")
      ;; (insert "set key box linestyle -1" ";")
      ;; (insert "set grid ytics lt 0 lw 1 lc rgb \\\"#bbbbbb\\\"" ";")
      ;; (insert "set grid xtics lt 0 lw 1 lc rgb \\\"#bbbbbb\\\"" ";")
      ;; (insert "set ylabel \\\"Voltage(V)\\\"" ";")
      ;; (insert "set ytics 2.5,0.1,4.3" ";")
      ;; (insert "set yrange [2.500:4.300]" ";")
      ;; (insert "set y2label \\\"Temperature(\\260C)\\\"" ";")
      ;; (insert "set y2tics -20,5,80" ";")
      ;; (insert "set y2range [-20:80]" ";") ;

      ;; (insert "set xtics 60*30 rotate by -45" ";")
      ;; (insert "set xlabel \\\"Time(Seconds)\\\"" ";")
      ;; (insert (format "stats \\\"%s\\\" using 2 name \\\"A\\\" nooutput" filepath) ";")
      ;; (insert "set label 1 at A_index_min, graph 0.1 sprintf(\\\"min=%.3f\\\",A_min) center offset 0,-1" ";")
      ;; (insert "set label 2 at A_index_max, graph 0.9 sprintf(\\\"max=%.3f\\\",A_max) center offset 0,1" ";")
      (insert "plot")
      ;; (insert (format " \\\"%s\\\" using 1:2 axis x1y1 title 'Voltage'" filepath))
      (insert (format " \\\"%s\\\" using 1:2" filepath))
      ;; (insert ",")
      ;; (insert (format " \\\"%s\\\" using 1:3 axis x1y2 title 'Temperature'" filepath))

      (insert "\"")
      (shell-command (buffer-string) (get-buffer-create buffer-name))
      )

    (switch-to-buffer-other-window buffer-name)
    (image-mode)
    (previous-multiframe-window)
    )
  )

;;
;;
;;
(defun lcd-timing-do (hpw hbp width hfp vs vbp height vfp &optional refresh)
  "calculate lcd vsync hsync pixel-clock, frequency"
  (interactive)
  (let ((pixel-clock)
	(frequency)
	(refresh (or refresh 1))
	)
    (setq pixel-clock (* (+ hpw hbp width hfp) (+ vs vbp height vfp) refresh))
    (setq frequency (/ 1.0 pixel-clock))
    (message "pixel-clock : %d\nfrequency : %g" pixel-clock frequency)
    ))

(defun select-word (&optional string)
  "return string pointed by word

"
  (save-excursion
    (let ((begin)
	  (end)
	  (select-word)
	  (exclude-chars "^=*>&[]!(){}\"'`.,/;:\n\t\s")
	  )
      (skip-chars-backward exclude-chars)
      (setq begin (point))
      (skip-chars-forward exclude-chars)
      (setq end (point))
      (if (not (= begin end))
	  (setq select-word (buffer-substring-no-properties begin end))
	)
      select-word)
    )
  )

(defun highlight-select-word (&optional string)
  "highlight word"
  (interactive)
  (require 'hi-lock)
  (let ((select-word)
	(word (select-word string))
	)

    (cond ((null word) (error "you can't select exclude characters"))
	  ((= (length word) 1) (error "you should select more a characters"))
	  (t 
	   ;; (setq select-word (concat "\\<" word "\\>"))
	   (setq select-word (concat "" word ""))
	   (if (null (assoc select-word hi-lock-interactive-patterns))
	       (highlight-regexp select-word)
	     (unhighlight-regexp select-word))
	   ))
    )
  )

(defun highlight-word (&optional string)
  "highlight word"
  (interactive)
  (require 'hi-lock)
  (let ((select-word)
	(word (select-word string))
	)

    (cond ((null word) (error "you can't select exclude characters"))
	  ((= (length word) 1) (error "you should select more a characters"))
	  (t 
	   (setq select-word (concat "\\<" word "\\>"))
	   (if (null (assoc select-word hi-lock-interactive-patterns))
	       (highlight-regexp select-word)
	     (unhighlight-regexp select-word))
	   ))
    )
  )

(defun display-ascii-table (&optional code)
  "display ascii table
if CODE is non-`nil', return string for code"
  (interactive)
  (let ((result)
	(ascii-buffer "*ascii table*")
	(table-code-max 256)
	(table-code-row 32)
	(table-code-column)
	(table-header " DEC HEX Code DEC HEX Code DEC HEX Code DEC HEX Code DEC HEX Code DEC HEX Code DEC HEX Code DEC HEX Code")
	)
    (cond (code (message "%s" (char-to-string code)))
	  ((null (get-buffer ascii-buffer)) 
	   (get-buffer-create ascii-buffer)
	   (switch-to-buffer ascii-buffer)
	   (setq header-line-format table-header)
	   
	   (setq table-code-column (/ table-code-max table-code-row))
	   (save-excursion
	     (dotimes (r table-code-row)
	       (dotimes (c table-code-column)
	     	 (insert (format "%03d %03x %s   "
				 (+ (* c table-code-row) r)
				 (+ (* c table-code-row) r)
				 (char-to-string (+ (* c table-code-row) r))))
	     	 )
	       (insert "\n")
	       )
	     )
	   
	   (read-only-mode t))
	  (t (switch-to-buffer ascii-buffer))
	  )
    ))

;; 
;; transparency
;;
(defun ttp ()
  "toggle frame transparency"
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha))
	)
    (set-frame-parameter nil 'alpha
			 (if (eql (cond ((numberp alpha) alpha)
					((numberp (cdr alpha)) (cdr alpha))
					((numberp (cadr alpha)) (cadr alpha)))
				  100)
			     '(50 . 50) '(100 . 100)))))




(defun ci (ratio years fund &optional capital)
  "복리계산(compound-interest)
2020년을 투자 원년으로 한다
`ratio' 연이자율(%) : 2 ( 2%)
`years' 투자기간(년): 10(10년)
`(expt 여이율 투자기간)' = 투자수익율
`(log 투자수익율 연이율)' = 투자기간
"
  (interactive "n이율: \nn투자기간: \nn월납입액: ")
  (with-help-window "*복리계산*"
    (let ((year 1)
	  (ratio (/ ratio 100.0))
          (capital (or capital 0))
	  (total (or capital 0))
	  )
      (princ "=================================\n")
      ;; 횟수 원금 평가금 이율
      (while (<= year years)
	(setq capital (+ capital fund))
	(setq total (* (+ total fund) (+ 1 ratio)))

	(princ (format "%3d %10d %10d %3.2f\n" year capital total (/ total capital)))
	
	(setq year (+ year 1))
	)
      (princ "=================================\n")
      (princ (format "투자기간: %10d(년)\n" years))
      (princ (format "원금    : %10d(원)\n" capital))
      (princ (concat (format "연이율  : %10.2f" (* ratio 100)) "(%)\n"))
      (princ "---------------------------------\n")
      (princ (format "평가금  : %10d(원)\n" total))
      (princ (concat (format "수익율  : %10.2f" (* (- (/ total capital) 1) 100)) "(%)\n"))
      (princ (format "수익금  : %10d(원)\n" (- total capital)))
      (princ "=================================\n")
      (- total capital)
      )
    )
  )

(defun tax (earning type &optional exemption)
  "`type' : 세율
  0 : 보통세율 : 소득세(14%) + 농특세(1.4%) = 15.4%
  1 : 저과세 : 소득세(0%) + 농특세(1.4%) = 1.4% (농협,수협,신협등 한도 3000만원)
  2 : 세금우대 : 소득세( 9%) + 농특세(0.5%) =  9.5%
`exemption' : 비과세한도
  "
  (with-help-window "*세금*"
    (let ((비과세한도 (or exemption 0))
	  (세율)
	  (earning1))
      (cond ((eq type 0) (progn
			   (setq 세율 15.4)
			   (setq tax (* (- earning 비과세한도) (/ 세율 100)))))
	    ((eq type 1) (progn
			   (setq 세율 1.4)
			   (setq tax (* (- earning 비과세한도) (/ 세율 100)))))
	    ((eq type 2) (progn
			   (setq 세율 9.5)
			   (setq tax (* (- earning 비과세한도) (/ 세율 100)))))
	    )
      (princ "=================================\n")
      (princ (format "수익금 : %10d(원)\n" earning))
      (princ (concat (format "세율   : %10.2f" 세율) "(%)\n"))
      (princ (format "비과세한도 : %10d(원)\n" 비과세한도))
      (princ (format "세금   : %10d(원)\n" tax))
      (princ "=================================\n")
      )
    )
  )

;; external-el
;; (load-file "c:/iam/emacs/site-lisp/coding.el")
;; (load-file "c:/iam/gnuglobal/current/share/gtags/gtags.el")

(setq initial-scratch-message
      (concat initial-scratch-message
	      ";; "
	      (emacs-init-time)))
