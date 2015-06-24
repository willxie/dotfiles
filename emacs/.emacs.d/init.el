;;;; Will's .emacs file
; William G. Xie
; September 10, 2013

; Each section in this file is introduced by a
; line beginning with four semicolons; and each
; entry is introduced by a line beginning with
; three semicolons.
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/elisp/")

;; Stop that noob stuff at startup
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)

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

;; Railscast theme
(require 'color-theme)
(color-theme-initialize)
(load-file "~/.emacs.d/elisp/color-theme-railscasts.el")
(color-theme-railscasts)

;; "y" and "n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Centralize backup files
(setq backup-directory-alist
          `((".*" . "~/.emacs.d/backup/")))
    (setq auto-save-file-name-transforms
          `((".*" "~/.emacs.d/backup." t)))

;; Delete trailing whitespace
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))

;; Window manipulation
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-[") 'shrink-window-horizontally)
(global-set-key (kbd "M-]") 'enlarge-window-horizontally)
(global-set-key (kbd "M--") 'shrink-window)
(global-set-key (kbd "M-=") 'enlarge-window)

;; Block cursor
(setq-default cursor-type 'box)

;; Stop the cursor from blinking
(blink-cursor-mode -1)

;; Revert buffer
(global-set-key [(control c) (control r)] 'revert-buffer)

;; Auto revert buffer
(global-auto-revert-mode 1)

;; Floobits plugin
;;(load "~/.emacs.d/floobits/floobits.el")

;; Scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse    
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Highlight variables
;(require 'highlight-symbol)
;(global-set-key [(control \\)] 'highlight-symbol-at-point)
;(global-set-key [f3] 'highlight-symbol-next)
;(global-set-key [(shift f3)] 'highlight-symbol-prev)
;(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

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

;; ===========================================================================
;;                               CMAKE MODE
;; ===========================================================================
 
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))
 
;(autoload 'cmake-mode cmake-mode-dir t)

;; Hippie expand
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list '(try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-line try-complete-lisp-symbol-partially try-complete-lisp-symbol))

;; Highlight and pair parentheses
(require 'highlight-parentheses)
(electric-pair-mode 1)

;; ---------------------------------------------------------------------------
;; Flx-ido
;; ---------------------------------------------------------------------------
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; IBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; Redo+
;; ---------------------------------------------------------------------------
(require 'redo+)
(global-set-key (kbd "M-_") 'redo)

;; Open .h files in C++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))