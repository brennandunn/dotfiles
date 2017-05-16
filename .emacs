(require 'package)
(defvar gnu '("gnu" . "https://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "https://melpa.org/packages/"))
(defvar melpa-stable '("melpa-stable" . "https://stable.melpa.org/packages/"))
(defvar org-elpa '("org" . "http://orgmode.org/elpa/"))

;; Add marmalade to package repos
(setq package-archives nil)
(add-to-list 'package-archives melpa-stable t)
(add-to-list 'package-archives melpa t)
(add-to-list 'package-archives gnu t)
(add-to-list 'package-archives org-elpa t)

(package-initialize)


(require 'org)

(use-package evil)
(evil-mode 1)

; For noobs like me
(use-package which-key
	     :ensure t
	     :diminish which-key-mode
	     :config
	     (which-key-mode))

; Config
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq mac-command-modifier 'meta)

(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "C-u") 'scroll-down-command)

; Powerline
(use-package powerline
  :config
  (powerline-default-theme))

(use-package counsel
  :ensure t
  :bind
  (("M-x" . counsel-M-x)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))

(use-package swiper
  :diminish ivy-mode
  :ensure t
  :bind*
  (("C-s" . swiper)
   ("C-c C-r" . ivy-resume)
   ("C-x C-f" . counsel-projectile)
   ("C-x C-o" . find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)))

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-on))

(use-package neotree
  :ensure t)
(global-set-key (kbd "C-x t") 'neotree-toggle)

; Git
(use-package magit
  :config
  (global-set-key (kbd "C-c m") 'magit-status))

; Theme
(use-package arjen-grey-theme
  :ensure t
  :config
  (load-theme 'arjen-grey t))

; Modes
(add-hook 'prog-mode-hook 'linum-mode)

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

  (defun my-web-mode-hook ()
    "Hooks for web-mode"
    (setq web-mode-enable-auto-closing t)
    (setq web-mode-markup-indent-offset 2))

  (add-hook 'web-mode-hook 'my-web-mode-hook))
