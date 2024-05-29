;;; keybinding.el --- key bindings that aren't in specific use-packages  -*- lexical-binding: t -*-

;;; Commentary:

;; where possible i try to keep bindings with specific packages, but
;; those that aren't are here.

;;; Code:


(global-set-key "\M-z" 'zap-up-to-char)      ;; this is the way
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)


;; probably the best package for emacs newbies and those of us with
;; memory issues.

(use-package which-key
  :diminish
  :init (which-key-mode))


;; for discovery of unbound keys.

(use-package free-keys
  :diminish)


(provide 'keybinding)
;;; keybinding.el ends here
