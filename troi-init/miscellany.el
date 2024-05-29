;;; mescellany.el --- brick and brack   -*- lexical-binding: t -*-

;;; Commentary:

;; small modes with no real configuration and other bits and pieces
;; that don't warrant being further split out. if anything starts to
;; accrete more configuration move it to its own file.

;;; Code:


(use-package sml-mode
  :defer t
  :mode "\\.sml\\'"
  :interpreter "sml")
(use-package sml-basis
  :after sml-mode)


(use-package cobol-mode
  :defer t
  :mode ("\\.cob\\'" "\\.cbl\\'"))


(use-package geiser-guile
  :defer t)
(use-package flymake-guile
  :after geiser-guile)


;; TODO emacs screen shot
(use-package emacsshot
  :defer t
  ;; need to do key maps, see https://gitlab.com/marcowahl/emacsshot/
  )


(use-package json-mode
  :defer t)


(use-package markdown-mode
  :defer t
  :mode "\\.md\\'"
  :magic "\\.md\\'")


(use-package gnuplot
  :defer t)


(provide 'mescellany)
;;; mescellany.el ends here
