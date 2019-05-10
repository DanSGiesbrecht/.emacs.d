;; INIT.EL - EMACS INITIALIZATION FILE

;;--------------------------------------------------------------------------------

;; add package archives
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "http://http://orgmode.org/elpa/") t)
(package-initialize)

;; bootstrap <use-package>

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

;;--------------------------------------------------------------------------------

;; GENERAL PREFERENCES

;; don't show startup prompt
(setq inhibit-startup-screen t)

;; don't show toolbar/scrollbar
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; don't ring the annoying error bell
(setq ring-bell-function 'ignore)

;; make 'yes/no' prompts shorter
(defalias 'yes-or-no-p 'y-or-n-p)

;; set font and size
(set-frame-font "DejaVu Sans Mono-12")

;; local backup files
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
    backup-by-copying t    ; Don't delink hardlinks
    version-control t      ; Use version numbers on backups
    delete-old-versions t  ; Automatically delete excess backups
    kept-new-versions 20   ; how many of the newest versions to keep
    kept-old-versions 5    ; and how many of the old
    )

;; add line numbers globally
(global-linum-mode t)

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;--------------------------------------------------------------------------------

;; MODES

;; vim keymaps/functionality
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; org mode
(use-package org
  :ensure t
  :defer t
  :mode (("\\.org$" . org-mode))
  :config
  (setq org-log-done 'time))

;; powerline
(use-package powerline
  :ensure t
  :config
  (powerline-center-evil-theme))
(add-hook 'after-init-hook 'powerline-reset)

;;--------------------------------------------------------------------------------

;; THEMES AND SYNTAX HIGHLIGHTING

;; bind modes to filetypes
(add-to-list 'auto-mode-alist '("\\.dcm$" . text-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; themes
(use-package monokai-alt-theme
  :ensure t
  :load-path "themes"
  :config
  (load-theme 'monokai-alt t))

;; org mode mods
(setq org-hide-emphasis-markers t)

(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
