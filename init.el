(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))


;; modes
;; vim keymaps/functionality
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; powerline
(use-package powerline
  :ensure t
  :config
  (powerline-center-evil-theme))
(add-hook 'after-init-hook 'powerline-reset)

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
