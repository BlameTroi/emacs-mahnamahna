;;; feedme.el --- rss and atom using elfeed   -*- lexical-binding: t -*-

;;; Commentary:

;; these configurations come from emacs writing studio, they need testing.

;; https://lucidmanager.org/productivity/read-rss-feeds-with-emacs-and-elfeed/

;;; Code:


(use-package elfeed
  :defer t
  :custom
  (elfeed-db-directory
   (expand-file-name "elfeed" user-emacs-directory))
  (elfeed-show-entry-switch 'display-buffer)
  :bind
  ("C-c w e" . elfeed))


(use-package elfeed-org
  :after elfeed org
  :config
  (elfeed-org)
  :custom
  ;; rmh-elfeed-org is the prefix for the elfeed-org package variables
  (rmh-elfeed-org-files (list "~/Dropbox/org/elfeed.org")))


(use-package elfeed-goodies
  :after elfeed)


(provide 'feedme)
;;; feedme.el ends here
