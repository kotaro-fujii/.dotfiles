; basic settings
;; remaps
(global-set-key (kbd "C-t") 'switch-to-buffer)
; (global-set-key (kbd "C-h") 'delete-backward-chark

;; representations
;; header
(tool-bar-mode 0)
(menu-bar-mode -1)

;; body
(setq tab-width 4)

(electric-pair-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
; (setq custom-theme-directory "~/.emacs.d/themes")
; (load-theme 'solarized-emacs/ t)
; (load-theme 'iceberg-theme t)

(setq explicit-shell-file-name "/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '())

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq scroll-margin 0)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
