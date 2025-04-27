;; start emacs with option '-q' to prevent loading default init file
;;             with option '-u' to specify a different user's init file
;;             and there are more initial options https://www.gnu.org/software/emacs/manual/html_node/emacs/Initial-Options.html

;; XDG-compatible location for init.el is a fallback choice, after ~/.emacs.el , ~/.emacs and ~/.emacs.d/
(setq inhibit-startup-message t)
(setq visible-bell nil)

;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Customizations.html
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

;; (load-theme 'modus-operandi-tritanopia t)



(recentf-mode 1)
(savehist-mode 1)

(save-place-mode 1)

;; Revert buffers when underlying file has changed, and there are no unsaved changes
(global-auto-revert-mode 1)



(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; (use-package zenburn-theme
;;   :config
;;   (load-theme 'zenburn t))

(use-package color-theme-sanityinc-tomorrow
   :ensure t
   :config
   (load-theme 'sanityinc-tomorrow-night))
		       
	     
(use-package org-roam
   :ensure t
   :init
   (setq org-roam-v2-ack t)
   :custom
   (org-roam-directory "~/RoamNotes")
   (org-roam-completion-everywhere t)
   :bind (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   :map org-mode-map
   ("C-M-i"   . completion-at-point))
   :config
   (org-roam-setup))
