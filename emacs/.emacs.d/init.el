;;;; Will's .emacs file
; William G. Xie
; September 10, 2013

; Each section in this file is introduced by a
; line beginning with four semicolons; and each
; entry is introduced by a line beginning with
; three semicolons.

; MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; (when (< emacs-major-version 24)
;;   ;; For important compatibility libraries like cl-lib
;;   (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(straight-use-package 'use-package)

;; Setup for emacs-mac-port
(when (equal system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'hyper))

;;===================================================================
;; Stop that noob stuff at startup
(if window-system
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1))

;; ELECTRIC PAIIR
(electric-pair-mode 1)

;; Keybonds
(global-set-key [(hyper q)] 'save-buffers-kill-terminal)
(global-set-key [(hyper a)] 'mark-whole-buffer)
(global-set-key [(hyper v)] 'yank)
(global-set-key [(hyper c)] 'kill-ring-save)
(global-set-key [(hyper s)] 'save-buffer)
(global-set-key [(hyper l)] 'goto-line)
(global-set-key [(hyper w)]
                (lambda () (interactive) (delete-window)))
(global-set-key [(hyper z)] 'undo)

;; mac switch meta key
;; (defun mac-switch-meta nil
;;   "switch meta between Option and Command"
;;   (interactive)
;;   (if (eq mac-option-modifier nil)
;;       (progn
;;         (setq mac-option-modifier nil)
;;         (setq mac-command-modifier 'meta)
;;         )
;;     (progn
;;       (setq mac-option-modifier 'meta)
;;       (setq mac-command-modifier 'hyper)
;;       )
;;     )
;;     )


;; Tab = 4 spaces
(setq-default c-default-style "k&r"
	      c-basic-offset 4
	      tab-width 4
	      indent-tabs-mode nil)

;; Syntax highlighting
(global-font-lock-mode 1)

;; Line number
(global-linum-mode 1)

;; Display column and line numbers
(line-number-mode 1)
(column-number-mode 1)

;; "Y" and "n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Centralize backuisownp files
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backup"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; Delete trailing whitespace
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))

;; Window manipulation
;; (global-set-key (kbd "M-3") 'split-window-horizontally)
;; (global-set-key (kbd "M-2") 'split-window-vertically)
;; (global-set-key (kbd "M-1") 'delete-other-windows)
;; (global-set-key (kbd "M-0") 'delete-window)
;; (global-set-key (kbd "M-o") 'other-window)
;; (global-set-key (kbd "M-[") 'shrink-window-horizontally)
;; (global-set-key (kbd "M-]") 'enlarge-window-horizontally)
;; (global-set-key (kbd "M--") 'shrink-window)
;; (global-set-key (kbd "M-=") 'enlarge-window)

;; Block cursor
(setq-default cursor-type 'box)

;; Stop the cursor from blinking
(blink-cursor-mode -1)

;; Revert buffer
(global-set-key [(control c) (control r)] 'revert-buffer)

;; Auto revert buffer
(global-auto-revert-mode 1)

;; Scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Require a newline at EOF
(setq require-final-newline t)

;; Prompt before closing emacs
(defun ask-before-closing()
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Exit cancelled")))
(global-set-key (kbd "C-x C-c") 'ask-before-closing)

;; CMAKE mode
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

;; Hippie expand
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list '(try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-line try-complete-lisp-symbol-partially try-complete-lisp-symbol))

;; IBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; Open .h files in C++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.launch\\'" . nxml-mode))

;; Make paragraph navigation predictable
(defun xah-forward-block (&optional φn)
;;   "Move cursor forward to the beginning of next text block.
;; A text block is separated by blank lines.
;; In most major modes, this is similar to `forward-paragraph', but this command's behavior is the same regardless of syntax table."
  (interactive "p")
  (let ((φn (if (null φn) 1 φn)))
    (search-forward-regexp "\n[\t\n ]*\n+" nil "NOERROR" φn)))

;;   "Move cursor backward to previous text block.
;; See: `xah-forward-block'"
;; (defun xah-backward-block (&optional φn)
;;   (interactive "p")
;;   (let ((φn (if (null φn) 1 φn))
;;         (ξi 1))
;;     (while (<= ξi φn)
;;       (if (search-backward-regexp "\n[\t\n ]*\n+" nil "NOERROR")
;;           (progn (skip-chars-backward "\n\t "))
;;         (progn (goto-char (point-min))
;;                (setq ξi φn)))
;;       (setq ξi (1+ ξi)))))
;; (global-set-key (kbd "<C-up>") 'xah-backward-block)
;; (global-set-key (kbd "<C-down>") 'xah-forward-block)

;; Fix CTRL + arrow keys inside screen/tmux
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])

;; Make tab always indent first
(setq tab-always-indent 'complete)

;; Comment and copy to replace regular comment
(defun comment-and-copy-region (beg end &optional arg)
  "Duplicate the region and comment-out the copied text.
See `comment-region' for behavior of a prefix arg."
  (interactive "r\nP")
  (copy-region-as-kill beg end)
  (goto-char end)
  (comment-region beg end arg))
;; (global-set-key (kbd "M-;") 'comment-and-copy-region)

;; Save session
(desktop-save-mode 1)

;; Markdown config
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-command "/usr/local/bin/pandoc")
 '(package-selected-packages
   (quote
    (yaml-mode highlight-indent-guides highlight-indentation-guides highlight-indentation cython-mode jedi py-autopep8 protobuf-mode cmake-mode clang-format clang-format-buffer smartparens flx-ido redo+ highlight-parentheses railscasts-theme use-package))))
(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Typeover highlighted words
(delete-selection-mode 1)

;; Roslaunch highlighting
(add-to-list 'auto-mode-alist '("\\.launch$" . xml-mode))

;; Bazel BUILD syntax highlighting
(add-to-list 'auto-mode-alist '("\\BUILD$" . python-mode))

;; Show function name
(which-function-mode 1)

;; Set font
;; (set-default-font "DejaVu Sans Mono-11")

;; Caffe prototxt
(setq caffe-mode-highlights
      '((".*\s{" . font-lock-function-name-face)
        ("^\s*.+:" . font-lock-keyword-face)
        ("#+.*" . font-lock-comment-face)
        ("'.*'" . font-lock-string-face)
        ("[A-z]" . font-lock-constant-face)
        ("false\\|true" . font-lock-constant-face)
        ("[0-9.e]+" . font-lock-constant-face)
        ))
(define-derived-mode caffe-mode fundamental-mode
  (setq font-lock-defaults '(caffe-mode-highlights))
  (setq mode-name "Caffe"))
(add-to-list 'auto-mode-alist '("\\.prototxt\\'" . caffe-mode))


;; Kill other buffers
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; Easier navigation
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)

;;===================================================================
;; Packages
;;====================================================================

;; Railscast theme
;; (use-package color-theme
;;   :ensure t)
(use-package railscasts-theme
  :ensure t
  :init
  (load-theme 'railscasts t nil))

;; Highlight and pair parentheses
(use-package highlight-parentheses
  :ensure t)

;; Redo+
(use-package redo+
  :ensure t
  :config
  (global-set-key (kbd "M-_") 'redo))

;; Fuzzy match
(use-package flx-ido
  :ensure t
  :init
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil)
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1)
)

;; Auto C++ clang format on save
(use-package clang-format
  :ensure t
  :config
  (global-set-key (kbd "C-c i") 'clang-format-region)
  (global-set-key (kbd "C-c u") 'clang-format-buffer)
  (defun clang-format-before-save ()
    (add-hook 'before-save-hook 'clang-format-before-save)
    (interactive)
    (when (eq major-mode 'c++-mode) (clang-format-buffer)))
  ;; Install hook to use clang-format on save
  (add-hook 'before-save-hook 'clang-format-before-save)
)

;; Auto Python pep8 on save
(use-package py-autopep8
  :ensure t
  :config
  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
  )

;; Protobuf mode
(use-package protobuf-mode
  :ensure t)

;; Python auto-complete
(use-package jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  )

;; Cython
(use-package cython-mode
  :ensure t)

;; Indentation highlight
(use-package highlight-indent-guides
  :ensure t
  :config
  (setq highlight-indent-guides-method 'character)
  (add-hook 'python-mode-hook 'highlight-indent-guides-mode)
 )

;; Yaml
(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
)
