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
(global-set-key (kbd "\C-hc") 'describe-char)

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

;; =============================================================================
;; c
;; =============================================================================
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
	     '(("\\<\\(fixme\\|FIXME\\|todo\\|TODO\\|checkme\\|caution\\)" 1
		font-lock-warning-face t)))
	    ))

;; =============================================================================
;; hide-ifdef
;; =============================================================================
(setq hide-ifdef-initially t)
(setq hide-ifdef-shadow t)
(add-hook 'c-mode-common-hook '(lambda ()
				 (hide-ifdef-mode 1)
				 ))
;; hideif configuration
(require 'hideif-conf nil t)

;; =============================================================================
;; perl-mode
;; =============================================================================
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook 
	  '(lambda ()
	     ;; evaluation perl script
	     (local-set-key (kbd "M-p") 
			    '(lambda () (interactive)
			       (let ((shell-param)
				     (buffer-name "*perl evaluation*"))
				 (setq shell-param (format "perl %s" (concat (file-name-nondirectory (buffer-file-name)))))
				 (shell-command shell-param (get-buffer-create buffer-name))
				 )))
	     ))

;; =============================================================================
;; graphviz mode
;; =============================================================================
(require 'graphviz-dot nil t)
(defun graphviz-dot-preview2 ()
  "preview dot files"
  (interactive)
  (let ((preview-buffer-name)
	(shell-param)
	(current-filename))

    (setq preview-buffer-name (concat "*graphviz preview*"))
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

(add-hook 'graphviz-dot-mode-hook
	  '(lambda ()
	     (setq graphviz-dot-indent-width 4)
	     (setq graphviz-dot-auto-indent-on-semi nil)
	     (local-set-key (kbd "M-p") 'graphviz-dot-preview2)
	     )
	  )

;; =============================================================================
;; org mode
;; =============================================================================
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-todo-keywords
      '((sequence "TODO" "DOING" "FIXME" "|" "CHECK" "DONE")
	)
      )
(add-hook 'org-mode-hook 'turn-on-font-lock)
(add-hook 'org-mode-hook '(lambda () 
			    (progn 
			      (setq tab-width 4))))

;; =============================================================================
;; gtags mode
;; =============================================================================
(autoload 'gtags-mode "gtags" "" t)
;; (require 'gtags)
(setq gtags-suggested-key-mapping t)
(add-hook 'c-mode-hook '(lambda () (gtags-mode 1)))
(add-hook 'c++-mode-hook '(lambda () (gtags-mode 1)))
(add-hook 'after-save-hook
	  (lambda ()
	    (and (boundp 'gtags-mode) gtags-mode
		 (let (root-dir current-dir shell-param)
		   (setq root-dir (gtags-get-rootpath))
		   ;; valid if gtags exist
		   (if root-dir
		       (progn
		   	 (setq current-dir (file-name-directory buffer-file-name))
		   	 (setq shell-param (concat "gtags --single-update " buffer-file-name))
		   	 (cd root-dir)
		   	 (shell-command shell-param)
		   	 ;; (start-process "gtags-update" nil "gtags" "--single-update" buffer-file-name)
		   	 (cd current-dir)
		   	 )
		     )
		   )
	      )
	    )
	  )

(setq gtags-mode-hook
     '(lambda ()
	(setq gtags-path-style 'relative)
	(setq gtags-pop-delete t)
	;; (setq gtags-suggested-key-mapping t)
	;; (setq gtags-auto-update t)
	))

(defun gtags-select-next-line-other-window ()
  "Select tags to other windows"
  (interactive)
  (forward-line 1)
  (gtags-select-tag-other-window)
  (previous-multiframe-window)
  )
(defun gtags-select-previous-line-other-window ()
  "Select tags to other windows"
  (interactive)
  (forward-line -1)
  (gtags-select-tag-other-window)
  (previous-multiframe-window)
  )
(defun gtags-select-pop-stack ()
  "pop stack"
  (interactive)
  (gtags-pop-stack)
  )
(setq gtags-select-mode-hook
      '(lambda ()
	 ;; (local-set-key (kbd "M-*") 'gtags-pop-stack)
	 (local-set-key (kbd "C-t") 'gtags-select-pop-stack)
	 ;; (local-set-key (kbd "n") 'next-line)
	 ;; (local-set-key (kbd "p") 'previous-line)
	 (local-set-key (kbd "n") 'gtags-select-next-line-other-window)
	 (local-set-key (kbd "p") 'gtags-select-previous-line-other-window)
	 (local-set-key (kbd "ESC") 'gtags-select-pop-stack)
	 ;; first tags is selected to other window
	 ;; (split-window-below)
	 ;; (gtags-select-tag-other-window)
	 ;; (previous-multiframe-window)
	 ))

;; =============================================================================
;; glistup mode
;; =============================================================================
(require 'glistup)

;; =============================================================================
;; gnuplot mode
;; =============================================================================
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode))
			      auto-mode-alist))
(add-hook 'gnuplot-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "M-p") 'gnuplot-etc-preview)
	     )
	  )
(require 'gnuplot)
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

      (insert "set term png size 1400,400" ";")
      (insert "set style data linespoints" ";")
      ;; (insert "set key box linestyle -1" ";")
      (insert "set grid ytics lt 0 lw 1 lc rgb \\\"#bbbbbb\\\"" ";")
      (insert "set grid xtics lt 0 lw 1 lc rgb \\\"#bbbbbb\\\"" ";")
      (insert "set ylabel \\\"Voltage(V)\\\"" ";")
      (insert "set ytics 3,0.1,4.3" ";")
      (insert "set yrange [3.000:4.300]" ";")
      (insert "set y2label \\\"Temperature(\\260C)\\\"" ";")
      (insert "set y2tics -20,5,80" ";")
      (insert "set y2range [-20:80]" ";") ;

      (insert "set xtics 60*30 rotate by -45" ";")
      (insert "set xlabel \\\"Time(Seconds)\\\"" ";")
      (insert (format "stats \\\"%s\\\" using 2 name \\\"A\\\" nooutput" filepath) ";")
      (insert "set label 1 at A_index_min, graph 0.1 sprintf(\\\"min=%.3f\\\",A_min) center offset 0,-1" ";")
      (insert "set label 2 at A_index_max, graph 0.9 sprintf(\\\"max=%.3f\\\",A_max) center offset 0,1" ";")
      (insert "plot")
      (insert (format " \\\"%s\\\" using 1:2 axis x1y1 title 'Voltage'" filepath))
      (insert ",")
      (insert (format " \\\"%s\\\" using 1:3 axis x1y2 title 'Temperature'" filepath))

      (insert "\"")
      (shell-command (buffer-string) (get-buffer-create buffer-name))
      )

    (switch-to-buffer-other-window buffer-name)
    (image-mode)
    (previous-multiframe-window)
    )
  )

;; =============================================================================
;; etc function
;; =============================================================================
(defun select-word (&optional string)
  "return string pointed by word

"
  (save-excursion
    ;; (let ((begin)
    ;; 	  (end)
    ;; 	  (select-word)
    ;; 	  (exclude-chars "^=*>&[]!(){}\"'`.,/;:\n\t\s")
    ;; 	  )
    ;;   (skip-chars-backward exclude-chars)
    ;;   (setq begin (point))
    ;;   (skip-chars-forward exclude-chars)
    ;;   (setq end (point))
    ;;   (if (not (= begin end))
    ;; 	  (setq select-word (buffer-substring-no-properties begin end))
    ;; 	)
    ;;   select-word)

    ;; syntax based
    (let ((begin)
	  (end)
	  (select-word)
	  )
      (skip-syntax-forward "w_")
      (setq begin (point))
      (skip-syntax-backward "w_")
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
	       (highlight-regexp select-word (intern (nth (random (length hi-lock-face-defaults)) hi-lock-face-defaults)))
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
