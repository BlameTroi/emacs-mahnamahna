;;; lostatc.el --- the bits of c setup that leak out of other areas  -*- lexical-binding: t -*-

;;; Commentary:

;; c is ubiquitous so this is more about turning a few hidden knobs
;; in various places. while treesitter suppport is built in, it is dependent
;; upon compiled grammars. the folks developing the treesitter binary (not
;; part of emacs) dont see eye to eye on binary compatability. my treesitter
;; binary is pinnned to an old release in homebrew until such time as emacs
;; builds against the new one.

;; which probably won't happen until i've forgotten the snafu.

;;; Code:


;; why they can't use editorconfig for the indent offset is beyond me. the
;; indent style is set here in preference to whatever clang-format would
;; do if i used it. i prefer k&r and do my real formatting from astyle.

(setopt c-ts-mode-indent-offset 3)
(setopt c-ts-mode-indent-style 'k&r)


;; this is really C specific, 3 is confusing, 1 and 2 are unhelpful.

(setopt treesit-font-lock-level 4)


;; use treesitter for c and c++. make sure the grammars are built.

(setopt major-mode-remap-alist
        '((c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)))


(provide 'lostatc)
;;; lostatc.el ends here
