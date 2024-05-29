;;; orgness.el --- org uber alles  -*- lexical-binding: t -*-

;;; Commentary:

;; org and close friends. i'm not really using org much, but it's
;; around if i need it.

;; org is built in but it should be refreshed from gnu elpa.

;;; Code:


(use-package org
  :pin gnu
  :defer t
  :hook
  (org-mode . org-indent-mode)
  (org-mode . visual-line-mode)
  (org-mode . variable-pitch-mode)
  :config
  (setopt org-agenda-files '("~/Dropbox/org/"))
  (setopt org-log-done 'time)
  (setopt org-return-follows-link t)
  ;;(setopt org-hide-emphasis-markers t)
  ;; some sample keybinds and a template to use for use-package
  ;; :bind (:map
  ;;        corfu-map
  ;;        ("SPC" . corfu-insert-separator)
  ;;        ("C-n" . corfu-next)
  ;;        ("C-p" . corfu-previous))
  ;; ;; Remap the change priority keys to use the UP or DOWN key
  ;; (define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
  ;; (define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)
  ;; ;; Shortcuts for storing links, viewing the agenda, and starting a capture
  ;; (define-key global-map "\C-cl" 'org-store-link)
  ;; (define-key global-map "\C-ca" 'org-agenda)
  ;; (define-key global-map "\C-cc" 'org-capture)
  ;; ;; When you want to change the level of an org item, use SMR
  ;; (define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)
  )


(use-package org-modern
  :pin gnu
  :after org
  :hook
  (org-mode . org-modern-mode)
   (org-agenda-finalize . org-modern-agend))


;; Easy insertion of weblinks
(use-package org-web-tools
  :after org
  :bind
  (("C-c w w" . org-web-tools-insert-link-for-url)))


(provide 'orgness)
;;; orgness.el ends here
