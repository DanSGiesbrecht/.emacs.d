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

;; navigate windows easily
(windmove-default-keybindings)

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
  :mode ("\\.org$" . org-mode)
  :init
  ;; resolve windmove conflicts with org-mode: shift+arrows
  (setq org-replace-disputed-keys t)
  :config
  (setq org-log-done 'time)
  (setq org-hide-emphasis-markers t)
  (font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

;; js2-mode
(use-package js2-mode
  :ensure t
  :defer t
  :mode "\\.js\\'"
  :init
  (add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2))))

;; powerline
(use-package powerline
  :ensure t
  :config
  (powerline-center-evil-theme)
  (add-hook 'after-init-hook 'powerline-reset))

;;--------------------------------------------------------------------------------

;; DIRECTORY VIEW

;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs (if (executable-find "python3") 3 0)
	  treemacs-deferred-git-apply-delay      0.5
	  treemacs-display-in-side-window        t
	  treemacs-eldoc-display                 t
	  treemacs-file-event-delay              5000
	  treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

;;--------------------------------------------------------------------------------

;; THEMES AND SYNTAX HIGHLIGHTING

;; bind modes to filetypes
(add-to-list 'auto-mode-alist '("\\.dcm$" . text-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; themes
;;(use-package monokai-alt-theme
;;  :ensure t
;;  :load-path "themes"
;;  :config
;;  (load-theme 'monokai-alt t))

(use-package soothe-theme
  :ensure t
  :load-path "themes"
  :config
  (load-theme 'soothe t))

;; org-mode beautification
(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
