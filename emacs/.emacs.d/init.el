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
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(add-to-list 'load-path "~/.emacs.d/elisp/")

;; Setup for emacs-mac-port
(when (equal system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'hyper))

;; ELECTRIC PAAAAAAIIR
(electric-pair-mode 1)

;; Font
;; (set-frame-font "Monaco 12")

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

;; Start the emacsserver that listens to emacsclient
;; (server-start)

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

;; "Y" and "n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Centralize backup files
(setq backup-directory-alist
          `((".*" . "~/.emacs.d/backup/")))
    (setq auto-save-file-name-transforms
          `((".*" "~/.emacs.d/backup." t)))

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
;; (electric-pair-mode 1)

;; Flx-ido
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
(require 'redo+)
(global-set-key (kbd "M-_") 'redo)

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

(defun xah-backward-block (&optional φn)
;;   "Move cursor backward to previous text block.
;; See: `xah-forward-block'"
  (interactive "p")
  (let ((φn (if (null φn) 1 φn))
        (ξi 1))
    (while (<= ξi φn)
      (if (search-backward-regexp "\n[\t\n ]*\n+" nil "NOERROR")
          (progn (skip-chars-backward "\n\t "))
        (progn (goto-char (point-min))
               (setq ξi φn)))
      (setq ξi (1+ ξi)))))

;; (global-set-key (kbd "<C-up>") 'xah-backward-block)
;; (global-set-key (kbd "<C-down>") 'xah-forward-block)

;; Read Google protobuf file type
(require 'protobuf-mode)

(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])

;; Make tab always indent first
(setq tab-always-indent 'complete)

;; Comment and copy
(defun comment-and-copy-region (beg end &optional arg)
  "Duplicate the region and comment-out the copied text.
See `comment-region' for behavior of a prefix arg."
  (interactive "r\nP")
  (copy-region-as-kill beg end)
  (goto-char end)
  (yank)
  (comment-region beg end arg))
