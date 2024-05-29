;;; undone.el --- un and do sitting in a tree  -*- lexical-binding: t -*-

;;; Commentary:

;; the stories of this being unreliable are just that, stories. research
;; shows undo-tree works fine when needed. i turn off the auto save of
;; history across sessions.

;;; Code:


(use-package undo-tree
  :diminish
  :init (global-undo-tree-mode)
  :custom (undo-tree-auto-save-history nil))


(provide 'undone)
;;; undone.el ends here
