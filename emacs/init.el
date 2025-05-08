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
   (load-theme 'sanityinc-tomorrow-day))

(use-package pixel-scroll
  :bind
  ([remap scroll-up-command]   . pixel-scroll-interpolate-down)
  ([remap scroll-down-command] . pixel-scroll-interpolate-up)
  
  :custom
  (pixel-scroll-precision-interpolate-page t)
  :init
  (pixel-scroll-precision-mode 1))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)           ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt) ;; Always preselect the prompt

  ;; Use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  


  :config
  ;; "RET" key default will complete completion, free the "RET" key
  (keymap-unset corfu-map "RET")
  ;; 确保 TAB 用来触发补全，而不是只确认
  ;;  (global-set-key (kbd "TAB") #'completion-at-point)
  ;;  (global-set-key (kbd "<tab>") #'completion-at-point)
  
  :init
  (global-corfu-mode))

(use-package vertico
  :init
  (vertico-mode))

(use-package org-roam
   :ensure t
   :init
   (setq org-roam-v2-ack t)
   :custom
   (org-roam-directory "~/RoamNotes/data")
   (org-roam-completion-everywhere t)
   :bind (("C-c n l" . org-roam-buffer-toggle)
          ("C-c n f" . org-roam-node-find)
          ("C-c n i" . org-roam-node-insert)
          :map org-mode-map
          ("C-M-i"   . completion-at-point)
          :map org-roam-dailies-map
          ("Y" . org-roam-dailes-capture-yesterday)
          ("T" . org-roam-dailes-capture-tomorrow))
   :bind-keymap
   ("C-c n d" . org-roam-dailies-map)
   :config
   (add-hook 'org-mode-hook 'visual-line-mode)
   (require 'org-roam-dailies)
   (setq org-roam-dailies-directory "journal/")
   (org-roam-db-autosync-mode))
   

(use-package emacs
  :custom
  (tab-always-indent 'complete))

;; 设置默认字体和大小
(set-face-attribute 'default nil
                    :family "JetBrainsMonoNL Nerd Font"
                    :height 110)  ;; 注意，这里 height 是字号*10，比如 11号字就是 110
(setq org-hide-emphasis-markers t)

  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(setq auto-save-file-name-transforms
          `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
;; set tab to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
