;;; feedme.el --- rss and atom using elfeed  -*- lexical-binding: t -*-

;;; Commentary:

;; these configurations come from emacs writing studio, they need testing.

;; https://lucidmanager.org/productivity/read-rss-feeds-with-emacs-and-elfeed/

;; i'm finding elfeed maybe too minimal, but i don't have enough blogs i follow
;; to work it out at this time. this is a low priority effort.

;;; Code:


;; (use-package elfeed
;;   :defer t
;;   :custom
;;   (elfeed-db-directory
;;    (expand-file-name "elfeed" user-emacs-directory))
;;   (elfeed-feeds
;;    '(
;;      "https://batsov.com/atom.xml"
;;      "https://blog.alicegoldfuss.com/feed.xml"
;;      "https://craftofcoding.wordpress.com/feed/"
;;      "https://emacstil.com/feed.xml"
;;      "https://feeds.feedburner.com/WalkingRandomly"
;;      "https://johnnyfiveisalive.com/rss.xml"
;;      "https://junjizhi.com/feed.xml"
;;      "https://lambdaland.org/index.xml"
;;      "https://lucidmanager.org/index.xml"
;;      "https://michal.sapka.me/emacs/rss.xml"
;;      "https://olddeuteronomy.github.io/index.xml"
;;      "https://protesilaos.com/codeblog.xml"
;;      "https://shape-of-code.com/feed/"
;;      "https://susam.net/tag/emacs.xml"
;;      ))
;;   (elfeed-show-entry-switch 'display-buffer)
;;   :bind
;;   ("C-c w e" . elfeed))


;; (use-package elfeed-org
;;   :after elfeed org
;;   :config
;;   (elfeed-org)
;;   :custom
;;   ;; rmh-elfeed-org is the prefix for the elfeed-org package variables
;;   (rmh-elfeed-org-files (list "~/Dropbox/org/elfeed.org")))


;; (use-package elfeed-goodies
;;   :after elfeed)


(provide 'feedme)
;;; feedme.el ends here
