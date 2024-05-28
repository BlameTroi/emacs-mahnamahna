;;; init.el --- troy brumley's init.el -*- lexical-binding: t -*-


;;; Commentary:


;; just an init file. if you are running with flycheck/flymake, it
;; will report several false positives. this init turns on flymake
;; globally, so you see the warnings. flycheck and flymake aren't
;; meant for init style elisp, but i leave it on to get in the habit
;; of checking lint warnings.
;;
;; * review this literate config, it's pretty clean and clear:
;;   https://whhone.com/emacs-config/
;;
;; i am aware of the formatting preference of no dangling close
;; parens, but i sometimes leave the closing paren in use-package blocks
;; on its own line for the sake of error avoidance when working on the
;; settings and for clarity in diff output. when i'm done tweaking i
;; may undangle them if i see them.


;;; Code:


;;;;;;;;;;;;;;;;;;;;;;
;; it's 2024 people!
;;;;;;;;;;;;;;;;;;;;;;

(when (< emacs-major-version 29)
  (error "This configuration requires Emacs 29 or newer!"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for where it's needed:
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setopt user-full-name "Troy Brumley")
(setopt user-mail-address "BlameTroi@gmail.com")
(setopt auth-sources '("~/.authinfo.gpg"))
(setopt auth-source-cache-expiry nil)
(setopt initial-scratch-message "
;;; so let it be written,
;;; so let it be done.

")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; the customization interface:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; i'm not a fan of splitting things between customization and the
;; declarative files such as init.el. i really hate the default
;; behavior of the customization interface tacking stuff on the tail
;; end of init.el. setting a specific custom file name will have any
;; customizations logged into that file but i never load it. the file
;; should be in .gitignore but can be mined for changes to pull into
;; init.el.
;;
;; remember that if you ever want to load custom.el, that should be
;; the last thing you do in the init process.

(setopt custom-file (concat user-emacs-directory "custom.el"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; package managment and loading:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; use-package is now part of standard emacs. it can be updated from
;; gnu elpa, as can several other built in packages. while built in,
;; you have to require it.

(eval-when-compile
  (require 'use-package))

(setopt load-prefer-newer t)
(setopt package-native-compile t)
(setopt use-package-always-ensure t)

;; you can evaluate this to see if native compilation is available. it
;; isn't in my current emacs build.
;;
;; (message (if (and (fboundp 'native-compile-available-p)
;;                  (native-compile-available-p))
;;             "native compilation available"
;;           "native compilation not available"))


(use-package diminish
  :demand t)
(use-package bind-key
  :demand t)

;; gnu and nongnu elpa repositories are available by default. add
;; melpa-stable but prioritize it below gnu and nongnu.

(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (setq package-archive-priorities
        '(("gnu" . 10)
          ("nongnu" . 9)
          ("melpa-stable" . 8)
          ("melpa" . 5))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; local unpackaged elisp:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (concat user-emacs-directory "troi-lisp"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mac or other os specific changes:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; shell path isn't always included on mac os x.

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :demand t)
  (setopt exec-path-from-shell-arguments nil)
  (exec-path-from-shell-initialize))

;; use gls if it's around. this could be gated to only
;; be used on the mac. the mac supplied ls doesn't
;; suppport all the options dired wants.

(when (executable-find "gls")
  (setopt insert-directory-program "gls"))

;; one last chance to un-delete a file.

(setopt delete-by-moving-to-trash t)

;; remap modifier keys. i change caps lock to control in the
;; macos keyboard settings.

(setopt ns-alternate-modifier 'alt)
(setopt ns-command-modifier 'meta)
(setopt ns-function-modifier 'hyper)
(setopt ns-right-alternate-modifier 'super)

;; save some screen space.

(setopt ns-auto-hide-menu-bar t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mouse and trackpad, somewhat mac specific:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; a rather heavy handed (but working) way to stop the mac touchpad
;; from moving things on me. i tried to find way to do this as a doom
;; after! but the double and triple variants kept being active. yes, i
;; searched the source. no, i couldn't find where that was done. the
;; customize interface isn't showing me these options in any way that
;; i understand. the goal here is to prevent my ham handed taps and
;; brushes of the touchpad from moving stuff around. i have mixed
;; feelings about drag-the-scrollbar mouse scrolling, but i don't like
;; the mouse wheel in text editing.

(add-to-list
 'emacs-startup-hook
 (lambda ()
   (global-set-key [wheel-up] 'ignore)
   (global-set-key [double-wheel-up] 'ignore)
   (global-set-key [triple-wheel-up] 'ignore)
   (global-set-key [wheel-down] 'ignore)
   (global-set-key [double-wheel-down] 'ignore)
   (global-set-key [triple-wheel-down] 'ignore)
   (global-set-key [wheel-left] 'ignore)
   (global-set-key [double-wheel-left] 'ignore)
   (global-set-key [triple-wheel-left] 'ignore)
   (global-set-key [wheel-right] 'ignore)
   (global-set-key [double-wheel-right] 'ignore)
   (global-set-key [triple-wheel-right] 'ignore)
   (mouse-wheel-mode -1)
   (message "trackpad stuff set to ignore")))

(mouse-avoidance-mode 'banish)


;;;;;;;;;;;;;;;;;;;;;;;
;; backup management:
;;;;;;;;;;;;;;;;;;;;;;;

(defun troi/backup-file-name (fpath)
  "Return a new file path of FPATH, creating directories if needed."
  (let* ((backupRootDir "~/.tmp/emacs-backup/")
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir fpath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'troi/backup-file-name)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; themes, colors, fonts, and bling:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; these are some themes i've tried and found at least usable enough
;; to be worthy of a longer trial. ef-melissa-dark and wheatgrass are
;; my favorites so far. orangey-bits-theme is ok, as is standard-dark.
;; vegetative and other greens work well.

;; (use-package ef-themes
;;   :demand t
;;   :config
;;   (load-theme 'ef-melissa-dark t))

(use-package acme-theme
  :config
  (load-theme 'acme t)
  (setopt acme-theme-black-fg nil))

;; icons and nerdish fonts.

(when (display-graphic-p)
  (global-prettify-symbols-mode t)
  (use-package all-the-icons)
  (use-package all-the-icons-dired
    :after all-the-icons
    :hook
    (dired-mode . all-the-icons-dired-mode))
  (use-package all-the-icons-ibuffer
    :after all-the-icons
    :init (all-the-icons-ibuffer-mode 1))
  (use-package diredfl
    :diminish
    :init (diredfl-global-mode 1)))

;; TODO currently using the custom-set-face functions, but this needs
;; to be changed.

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "IOSEVKA NF" :foundry "nil" :slant normal :weight regular :height 220 :width normal))))
 '(font-lock-comment-face ((t (:foreground "#005500" :slant oblique))))
 '(hl-line ((t (:inherit highlight :extend t :background "LightGoldenrod2" :foreground "black"))))
 '(variable-pitch ((t (:weight regular :height 250 :width normal :family "IOSEVKA NF")))))

;; TODO: the above is the only way i can get acme-theme to show the highlight
;; line distinctly. changes in the theme file itself aren't taking. i opted to
;; make comments oblique as well.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; visuals and elements not related to color themes:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; line numbers for programming modes.

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 4)

;; text modes wrap.

(add-hook 'text-mode-hook 'visual-line-mode)

;; highlight the current line.

;; TODO see gnu elpa package lin if i can't fix the face for acme mode
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; other options:

(setopt x-underline-at-descent-line nil)
(setopt blink-cursor-mode nil)
(setopt blink-matching-delay 0.1)
(setopt column-number-mode t)
(setopt mode-line-position-column-line-format '(" (%l,%C)"))
(setopt split-height-threshold nil)
(setopt tab-bar-mode t)
(setopt tab-bar-show 1)
(setopt display-time-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tabs, spaces, indents, and trailing spaces:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; in an ideal world everything would pull from editorconfig. alas, we
;; don't live in an ideal world. in particular, the treesitter and lsp
;; formatters don't seem to check there. text formatting tweaks of all
;; kinds here.

(setopt indent-tabs-mode nil)
(setopt mode-require-final-newline t)
(setopt sentence-end-double-space nil)
(setopt c-ts-mode-indent-offset 3)
(setopt c-ts-mode-indent-style 'k&r)

(use-package editorconfig
  :demand t
  :diminish
  :config (editorconfig-mode 1))

(use-package ws-butler
  :diminish
  :hook (prog-mode . ws-butler-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; movement and navigation:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; scrolling.

(setopt scroll-preserve-screen-position t)
(setopt scroll-margin 0)
(setopt scroll-setp 1)
(setopt scroll-conservatively 10000)       ;; this in particular works a bit like vim

;; return to where i left.

(save-place-mode 1)

;; i prefer switching to new windows when i open them, for help this
;; lets us close quickly via 'q'.

(setopt help-window-select t)
(setopt switch-to-buffer-obey-display-actions t)

(recentf-mode)

;; TODO group programming specific stuff elsewhere
(setopt compilation-auto-jump-to-first-error 'first-known)

(setopt confirm-kill-emacs 'yes-or-no-p)

(setopt ibuffer-jump-offer-only-visible-buffers t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key binding packages and bindings:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; where possible keep bindings in use-package blocks, but some
;; bindings leak out here.

(global-set-key "\M-z" 'zap-up-to-char)      ;; this is the way
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(use-package which-key
  :diminish
  :init (which-key-mode))

(use-package free-keys
  :diminish)

;; (use-package guru-mode
;;   :init (guru-global-mode +1))


;;;;;;;;;;;;;;;;;;;;;
;; narrow-to-focus:
;;;;;;;;;;;;;;;;;;;;;

;; from https://speechcode.com/blog/narrow-to-focus/
;; by arthur a. gleckler

(defun troi/narrow-to-focus (start end)
  "If the region is active, narrow to region, and mark it.
If the mark is not active, narrow to the region that was
the most recent focus. START and END define the active
region."
  (interactive "r")
  (cond ((use-region-p)
         (remove-overlays (point-min) (point-max) 'focus t)
         (let ((overlay (make-overlay start end)))
           (overlay-put overlay 'focus t)
           (narrow-to-region start end)))
        (t (let ((focus
                  (seq-find (lambda (o) (overlay-get o 'focus))
                            (overlays-in (point-min) (point-max)))))
             (when focus
               (narrow-to-region (overlay-start focus)
                                 (overlay-end focus)))))))
(define-key global-map "\C-xnf" 'troi/narrow-to-focus)

;;;;;;;;;;;;;;;
;; undo-tree:
;;;;;;;;;;;;;;;

;; i don't like the file archive of history between sessions.

(use-package undo-tree
  :diminish
  :init (global-undo-tree-mode)
  :custom (undo-tree-auto-save-history nil))

(savehist-mode)

(global-auto-revert-mode)                ;; refresh if changed

(setopt enable-recursive-minibuffers t)
(setopt completion-cycle-threshold 1)
(setopt completions-detailed t)
(setopt tab-always-indent 'complete)
(setopt completion-styles '(basic initials substring))
(setopt completion-auto-help 'always)
(setopt completions-max-height 10)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)
(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)


;;;;;;;;;;;;;;;;
;; completion:
;;;;;;;;;;;;;;;;

(use-package vertico
  :init (vertico-mode))

(use-package marginalia
  :init (marginalia-mode))

(use-package corfu
  :init (global-corfu-mode)
  :bind (:map corfu-map
              ("SPC" . corfu-insert-separator)
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous))
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package consult
  :bind
  (
   ;; replace some commands
   ("C-x b" . consult-buffer)     ; was switch-to-buffer
   ("M-y"   . consult-yank-pop)   ; was yank-pop
   ;; new searches
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)       ; Alternative: rebind C-s to use
   ("M-s s" . consult-line)       ; consult-line instead of isearch, bind
   ("M-s L" . consult-line-multi) ; isearch to M-s s
   ("M-s o" . consult-outline)
   ;; isearch integration
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)   ; was isearch-edit-string
   ("M-s e" . consult-isearch-history) ; was isearch-edit-string
   ("M-s l" . consult-line)            ; needed by consult-line to detect isearch
   ("M-s L" . consult-line-multi)      ; needed by consult-line to detect isearch
   )
  :config
  (setq consult-narrow-key "<"))   ;; Narrowing lets you restrict results to certain groups of candidates

(use-package embark-consult
  :after consult)

(use-package embark
  :demand t
  :after (avy consult)
  :bind
  (("C-c a" . embark-act))        ; bind this to an easy key to hit
  :init
  ;; Add the option to run embark when using avy
  (defun troi/avy-action-embark (pt)
    (unwind-protect
	(save-excursion
	  (goto-char pt)
	  (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)
  ;; After invoking avy-goto-char-timer, hit "." to run embark at the
  ;; next candidate you select
  (setf (alist-get ?. avy-dispatch-alist) 'troi/avy-action-embark))

(use-package avy
  :bind
  (("C-'" . avy-goto-char-timer)
   ("C-:" . avy-goto-char)))


(use-package ace-window
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))
;; setq aw-background nil) ;; to turn off grey out of window on prompt


;; programming related packages, hooks, and such here.

;; eglot is to winning me over as it's easier to manage for the places
;; i use it. it's not as polished as lsp-mode, but it's smaller. i
;; think treesitter actually handles some of what lsp-mode gets used
;; for better anyway.


;; TODO keys for folding? right now just M-x

(use-package vimish-fold)

;; TODO this is really C specific, 3 is confusing, 1 and 2 are unhelpful.

(setopt treesit-font-lock-level 4)


(use-package eglot
  :pin gnu
  :hook (prog-mode . eglot-ensure)
  :bind (:map eglot-mode-map
              ("C-c c a" . eglot-code-actions)
              ("C-c c o" . eglot-code-actions-organize-imports)
              ("C-c c r" . eglot-rename))
  :custom
  (eglot-autoshutdown t)
  (eglot-ignored-server-capabilities '(:documentFormattingProvider
                                       :documentRangeFormattingProvider
                                       :documentOnTypeFormattingProvider)))

;; flycheck might handle fortran better, but i can live with flymake.

(use-package flymake
  :pin gnu
  :hook (prog-mode . flymake-mode)
  :bind (:map flymake-mode-map
              ("C-c ! n" . flymake-goto-next-error)
              ("C-c ! p" . flymake-goto-prev-error)
              ("C-c ! l" . flymake-show-buffer-diagnostics)
              ("C-c ! L" . flymake-show-project-diagnostics)))

;; so far i haven't used magit enough to want to tweak it but it's
;; loaded.

(use-package magit
  :pin melpa-stable)

;; my use is simple enough that i don't need full blown projectile. i
;; do set some non vc project roots. fpm adds a .git repo by default
;; but i tend to remove that and put .git higher up as i use fpm for
;; sub projects.

(use-package project
  :pin gnu
  :custom
  (project-vc-extra-root-markers '(".projectile" ".project.el" "fpm.toml")))

;; use treesitter for c and c++. make sure the grammars are built.

(setopt major-mode-remap-alist
        '((c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)))

;; standard ml can be fun.

(use-package sml-mode
  :mode "\\.sml\\'"
  :interpreter "sml")

(use-package sml-basis
  :after sml-mode)

;; cobol will never die!

(use-package cobol-mode
  :mode ("\\.cob\\'" "\\.cbl\\'"))

;; so many schemes, so little time.

(use-package geiser-guile)

(use-package flymake-guile
  :pin gnu
  :after geiser-guile)

;; for c/c++
(with-eval-after-load 'eglot
  (setopt completion-category-defaults nil)
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode c-ts-mode c++-ts-mode)
                 . ("clangd"
                    "-j=4"
                    "--log=error"
                    "--background-index"
                    "--clang-tidy"
                    "--completion-style=detailed"
                    "--pch-storage=memory"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0"))))

;;;;;;;;;;;
;; blogs maybe?
;;;;;;;;;;;

;; these configurations come from emacs writing studio,
;; https://lucidmanager.org/productivity/read-rss-feeds-with-emacs-and-elfeed/

;; Configure Elfeed
(use-package elfeed
  :defer t
  :custom
  (elfeed-db-directory
   (expand-file-name "elfeed" user-emacs-directory))
  (elfeed-show-entry-switch 'display-buffer)
  :bind
  ("C-c w e" . elfeed))

;; Configure Elfeed with org mode
;; it seems that rmh-elfeed-org is the prefix for the elfeed-org package variables

(use-package elfeed-org
  :defer t
  :config
  (elfeed-org)
  :custom
  (rmh-elfeed-org-files (list "~/Dropbox/org/elfeed.org")))

(use-package elfeed-goodies
  :defer t)

;; Easy insertion of weblinks
(use-package org-web-tools
  :defer t
  :bind
  (("C-c w w" . org-web-tools-insert-link-for-url)))

;; emacs screen shot
(use-package emacsshot
  :defer t
  ;; need to do key maps, see https://gitlab.com/marcowahl/emacsshot/
  )

;;;;;;;;;;
;; json:
;;;;;;;;;;

(use-package json-mode)
(use-package json-reformat)

;;;;;;;;;;;
;; rebox2:
;;;;;;;;;;;

;; rebox is a bit touchy and i'm not enjoying it at the moment so off
;; it goes.

;; (use-package rebox2
;;   :defer t
;;   :diminish
;;   :hook
;;   (emacs-lisp-mode . (lambda ()
;;                        (set (make-local-variable 'rebox-style-loop) '(27 17 21))
;;                        (set (make-local-variable 'rebox-min-fill-column) 40)
;;                        (rebox-mode 1)))
;;   (c-ts-mode . (lambda ()
;;                  (setq comment-start "/* "
;;                        comment-end " */")
;;                  (set (make-local-variable 'rebox-style-loop) '(11 15 35 21 41))
;;                  (set (make-local-variable 'rebox-min-fill-column) 60)
;;                  (rebox-mode 1)))
;;   )


;;;;;;;;;;;;;;;;;;;;;
;; formatting code:
;;;;;;;;;;;;;;;;;;;;;

;; indenting is not sufficient, and the current state of treesitter
;; configuration for the c-ts modes is sadly lacking. as i got used
;; to always formatting on save when working with go, let's try to
;; use reformatter to drive astyle for c, and add other languages if
;; i ever feel a need.
;;
;; the astyle reformat package uses customization.

(use-package reformatter)

(use-package astyle
  :after reformatter
  :when (executable-find "astyle")
  :diminish
  :hook
  (c-ts-mode . astyle-on-save-mode)
  (c++-ts-mode . astyle-on-save-mode)
  :custom
  (astyle-style "attach")              ;; --style=attach
  (astyle-indent 3)                    ;; -s3
  (astyle-custom-args '(
                        "-xn"          ;; --attach-namespaces
                        "-xc"          ;; --attach-classes
                        "-xk"          ;; --attach-extern-c
                        "-xV"          ;; --attach-closing-while     } while ();
                        "-H"           ;; --pad-header               if ()
                        "-U"           ;; --unpad-paren
                        "-j"           ;; --add-braces
                        "-xB"          ;; --break-return-type
                        "-xD"          ;; --break-return-type-decl
                        "-xg"          ;; --pad-comma
                        ;;"-p"           ;; --pad-oper  (implies -xg --pad-comma)
                        )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; interactive documentation:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; one document api to show them all. eldoc-box is pretty handy since
;; i don't like the mini-buffer fluttering up and down. however, the
;; use of C-g to close the doc frame doesn't seem to work. the author
;; notes that any point movement will accomplish the clear so C-f gets
;; the job done for now.

;; i think eglot is reloading eldoc and so that blows out my diminish.
;; first, try to load after eglot. if that doesn't work, there's always
;; adding (diminish eldoc-mode) somewhere.
(use-package eldoc
  :pin gnu
  :after eglot
  :diminish
  :init (global-eldoc-mode))

(use-package eldoc-box
  :pin melpa-stable
  :diminish
  :bind (:map prog-mode-map
              ("C-h D" . eldoc-box-help-at-point))
  :init (setopt eldoc-box-clear-with-C-g t)
  :config
  (setopt eldoc-echo-area-prefer-doc-buffer t)
  (setopt eldoc-echo-area-use-multiline-p nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; miscellaneous file modes:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :mode "\\.md\\'"
  :magic "\\.md\\'")


;;;;;;;;;;;;;;;;;;;;;
;; editing helpers:
;;;;;;;;;;;;;;;;;;;;;

;; ;; highlight matching braces.

;; (use-package electric
;;   :config (electric-pair-mode 1))

;; todo: define colors for TODO keywords and get the keywords
;; squared away to my preferences.

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :bind (:map hl-todo-mode-map
              ("C-c tp" . hl-todo-previous)
              ("C-c tn" . hl-todo-next)
              ("C-c to" . hl-todo-occur)
              ("C-c ti" . hl-todo-insert)))


;;;;;;;;;;;;;;
;; org mode:
;;;;;;;;;;;;;;

;; org and close friends. i'm not really using org much, but it's
;; around if i need it.
;;
;; org is built in but it should be refreshed from gnu elpa.

(use-package gnuplot)

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

;; (use-package org-modern
;;   :pin gnu
;;   :after org
;;   :hook
;;   (org-mode . org-modern-mode)
;;   (org-agenda-finalize . org-modern-agend))



(provide 'init)
;;; init.el ends here
