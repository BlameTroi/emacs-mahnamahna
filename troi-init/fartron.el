;;; fartron.el ---  fortran support -*- lexical-binding: t -*-

;;; Commentary:

;; actually nothing here as yet since eglot will just use fortls
;; without any real configuration. fortls is still limited in features
;; but i know they are working on it at fortran-lang.

;; all you seem to need is a .fortlsrc file in a project root.

;; flymake will need configuration but i haven't started working on
;; that yet. i might just use purcell's flymake-flycheck wrapper but
;; i'm not sure i want to drag flycheck along for the ride given my
;; limited use of fortran at the moment.

;; finally, i created an f90format using purcell's reformatter
;; infrastructure and it works but i haven't plugged it in to this
;; configuration yet. like my use of astyle for c, format on save is
;; good enough for me.

;;; Code:



(provide 'fartron)
;;; fartron.el ends here
