;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "kien.q"
      user-mail-address "kien.q@autonomous.nyc")
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; ;; Monaco

(when (display-graphic-p)
  (use-package all-the-icons))

;; (set-face-attribute 'region nil :background "#c9c7c7")

;; (use-package dracula-theme)
;; (setq doom-theme 'monokai)
;; (setq doom-theme 'doom-dracula)
(setq doom-theme 'doom-bluloco-dark)

;; choose your fonts!
(setq
 ;; doom-font (font-spec :family "Bespoke Iosevka Mon" :size 12 :weight 'semibold)
 ;; doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 14 :weight 'medium)
 ;; doom-symbol-font (font-spec :family "Noto Color Emoji" :weight 'regular)
 ;; doom-serif-font (font-spec :family "BlexMono Nerd Font" :weight 'light)
 )

;;;; Fira Code
(setq doom-font (font-spec :family "Monaco" :size 14 :slant 'normal :weight 'normal))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'absolute)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Core settings
;; UTF-8 please
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)   ; pretty
(set-terminal-coding-system  'utf-8)   ; pretty
(set-keyboard-coding-system  'utf-8)   ; pretty
(set-selection-coding-system 'utf-8)   ; please
(prefer-coding-system        'utf-8)   ; with sugar on top
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

(setq-default tab-width 2)
(defconst private-dir  (expand-file-name "private" user-emacs-directory))
(defconst temp-dir (format "%s/cache" private-dir)
  "Hostname-based elisp temp directories.")
;; SHOW FILE PATH IN FRAME TITLE
(setq-default frame-title-format "%b - %f")
;; Emacs customizations
(setq confirm-kill-emacs                  'y-or-n-p
      confirm-nonexistent-file-or-buffer  t
      save-interprogram-paste-before-kill t
      mouse-yank-at-point                 t
      require-final-newline               t
      visible-bell                        nil
      ring-bell-function                  'ignore
      custom-file                         "~/.emacs.d/.custom.el"
      ;; http://ergoemacs.org/emacs/emacs_stop_cursor_enter_prompt.html
      minibuffer-prompt-properties
      '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)

      ;; Disable non selected window highlight
      cursor-in-non-selected-windows     nil
      highlight-nonselected-windows      nil
      ;; PATH
      exec-path                          (append exec-path '("/usr/local/bin/"))
      indent-tabs-mode                   t
      inhibit-startup-message            t
      fringes-outside-margins            t
      select-enable-clipboard            t
      )

(call-interactively #'+fold/toggle)

;; Backups enabled, use nil to disable
(setq
 history-length                     1000
 backup-inhibited                   nil
 make-backup-files                  t
 auto-save-default                  t
 auto-save-list-file-name           (concat temp-dir "/autosave")
 make-backup-files                  t
 create-lockfiles                   nil
 backup-directory-alist            `((".*" . ,(concat temp-dir "/backup/")))
 auto-save-file-name-transforms    `((".*" ,(concat temp-dir "/auto-save-list/") t))
 ;; treemacs-display-current-project-exclusively t
 ;; treemacs-project-follow-mode t
 )

(unless (file-exists-p (concat temp-dir "/auto-save-list"))
  (make-directory (concat temp-dir "/auto-save-list") :parents))

(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)

;; Disable toolbar & menubar
;; (menu-bar-mode -1)
(scroll-bar-mode -1)
(toggle-scroll-bar -1)
(tooltip-mode    -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Delete trailing whitespace before save
(show-paren-mode)
(electric-pair-mode)
(global-hl-line-mode +1)
(delete-selection-mode +1)

(custom-set-variables
 '(truncate-lines nil))

(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight "#aa2ee8")

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))
(setq ns-function-modifier 'control)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;;

(map!
 "C-S-i" #'windmove-up
 "C-S-k" #'windmove-down
 "C-S-j" #'windmove-left
 "C-S-l" #'windmove-right

 "M-." #'xref-find-definitions
 "M-\"" #'xref-find-references
 "M-g i" #'lsp-find-implementation

 "C-S-c C-S-c" #'mc/edit-lines
 "C->" #'mc/mark-next-like-this
 "C-<" #'mc/mark-previous-like-this
 "C-c C->" #'mc/mark-all-like-this

 [(control f3)] #'highlight-symbol
 [f3] #'highlight-symbol-next
 [(shift f3)] #'highlight-symbol-prev

 "C-S-a" #'lsp-execute-code-action

 [f8] #'neotree-toggle
 "M-i" #'imenu-list-smart-toggle

 ;; "M-g o" #'dumb-jump-go-other-window
 ;; "M-g j" #'dumb-jump-go
 "M-g j" #'godef-jump
 "M-g o" #'godef-jump-other-window

 "M-*" #'pop-tag-mark
 ;; [f9] #'treemacs
 "C-s" #'isearch-forward

 "C-c h" #'hs-hide-block
 "C-c d" #'hs-show-block
 "C-c g" #'hs-toggle-hiding

 "C-S-s" #'consult-line
 "M-g f" #'go-goto-function-name

 "M-s l" #'open-local-shell
 "M-s s" #'open-server-shell

 "M-s c" #'copy-full-path-to-kill-ring

 ;; (global-set-key (kbd "C-x g s") 'magit-status)
 ;; (global-set-key (kbd "C-x g u") 'magit-pull)
 )

;;
;;
(after! lsp-mode
  (setq
   lsp-use-plists 1
   lsp-headerline-breadcrumb-enable 1
   lsp-go-use-gofumpt t
   lsp-auto-guess-root t ; Detect project root
   lsp-keep-workspace-alive nil ; Auto-kill LSP server
   ;; lsp-prefer-capf t
   lsp-file-watch-threshold 10000
   lsp-enable-on-type-formatting nil
   lsp-ui-sideline-enable nil
   lsp-ui-sideline-show-code-actions nil
   lsp-log-io nil
   lsp-enable-links nil
   lsp-ui-doc-enable nil
   lsp-enable-folding nil
   lsp-diagnostics-provider nil
   lsp-enable-snippet t
   lsp-ui-doc-show-with-cursor nil
   lsp-ui-doc-show-with-mouse nil
   lsp-restart 'auto-restart
   lsp-lens-enable nil
   lsp-idle-delay 0.500
   lsp-headerline-breadcrumb-segments '(project file symbols)
   lsp-client-packages '(lsp-go)
   lsp-go-analyses '((fieldalignment . t)
                     (nilness . t)
                     (shadow . t)
                     (unusedparams . t)
                     (unusedwrite . t)
                     (useany . t)
                     (unusedvariable . t))
   ))

(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(after! exec-path-from-shell
  ;; Add GOPATH to shell
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(after! projectile
  (setq projectile-ignored-directories '("/Users/macbook_autonomous/go")
	projectile-ignored-project-function
	(lambda (dir)
          (string-prefix-p (expand-file-name "~/go") dir))
	)
  )

;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(use-package! yafolding
  )

(use-package! avy
  :bind
  ("M-g g" . avy-goto-line)
  ;; ("c-s-o" . avy-goto-word-opr-subword-1)
  ("M-g s" . avy-goto-char-timer)
  :config
  (avy-setup-default) ;; can use c-' after trigger isearch
  )

(after! magit
  (setq  magit-refresh-status-buffer nil
         magit-diff-refine-hunk t)
  )

(use-package! dotenv-mode
  :mode
  (("\\.env\\'" . dotenv-mode))
  (("\\.env.test\\'" . dotenv-mode))
  (("\\.env.development\\'" . dotenv-mode)))

;; (after! helm
;;   (setq helm-split-window-inside-p t
;;         helm-split-window-default-side 'above
;;         ))

;; better defaults
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t                               ; Stretch cursor to the glyph width
 uniquify-buffer-name-style 'forward)

;; Start LSP Mode and YASnippet mode
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\~/go\\'")
  ;; or
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'"))

;; (setq gofmt-command "goimports")

(setq company-show-numbers t)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(setq imenu-auto-rescan 1)

(setq
 neo-smart-open t
 neo-window-fixed-size nil
 neo-theme (if (display-graphic-p) 'icons 'arrow))

(when (modulep! 'shell)
  (set-environment-variable "SHELL" (executable-find "zsh"))
  (setq shell-file-name (executable-find "zsh"))
  (setq shell-command-switch "-ic"))

(setq shell-default-height 30
      shell-default-shell 'shell
      shell-default-term-shell "/bin/zsh"
      shell-default-position 'bottom)

(with-eval-after-load 'go-mode
  ;; (setq go-tag-args (list "-transform" "camelcase"))
  (setq go-tag-args (list "-transform" "snakecase")
	)
  (define-key go-mode-map (kbd "C-c t") #'go-tag-add)
  (define-key go-mode-map (kbd "C-c T") #'go-tag-remove)
  (setq dumb-jump-go-search "gopls")
  )

(setq doom-modeline-icon (display-graphic-p))
(setq doom-modeline-major-mode-icon t)

(add-hook 'after-init-hook
          #'(lambda ()
              (setq gc-cons-threshold (* 100 1000 1000))))
;; (add-hook 'after-focus-change-function 'garbage-collect)
;; (run-with-idle-timer 5 t 'garbage-collect)

(setq default-frame-alist
      '((cursor-color . "dark orange")))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Enabling only some features
;; (setq dap-auto-configure-features '(locals controls tooltip))
;; (dap-mode 1)
;; (dap-print-io t)
;; The modes below are optional
;; (dap-ui-mode nil)
;; enables mouse hover support
;; (dap-tooltip-mode 1)
;; use tooltips for mouse hover
;; if it is not enabled `dap-mode' will use the minibuffer.
;; (tooltip-mode 1)
;; displays floating panel with debug buttons
;; requies emacs 26+
;; (dap-ui-controls-mode 1)

(setq org-todo-keywords
      '((sequence "TODO" "START WORKING" "HOLD" "DONE")))
(setq org-tag-alist '(("@autonomous" . ?s) ("@personal" . ?p)))
(setq org-priority-faces '((?A . (:foreground "Red" :weight bold))
                           (?B . (:foreground "Yellow"))
                           (?C . (:foreground "LightSteelBlue"))))

(defun eshell-clear-buffer ()
  "Clear terminal"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))
(add-hook 'eshell-mode-hook
          (lambda()
            (local-set-key (kbd "C-l") 'eshell-clear-buffer)))


(defun file-notify-rm-all-watches ()
  "Remove all existing file notification watches from Emacs."
  (interactive)
  (maphash
   (lambda (key _value)
     (file-notify-rm-watch key))
   file-notify-descriptors))

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH env var to match that
   used by the user's shell.
 This is particularly useful under Mac OSX,
   where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(setenv "LSP_USE_PLISTS" "true")
;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; -------
;; (add-hook 'go-mode-hook 'eglot-ensure)
;; ;; Optional: install eglot-format-buffer as a save hook.
;; ;; The depth of -10 places this before eglot's willSave notification,
;; ;; so that that notification reports the actual contents that will be saved.
;; (defun eglot-format-buffer-before-save ()
;;   (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
;; (add-hook 'go-mode-hook #'eglot-format-buffer-before-save)
;; (setq-default eglot-workspace-configuration
;;               '((:gopls .
;;                  ((staticcheck . t)
;;                   (matcher . "CaseSensitive")))))
;; -------

;; Show current file-path in minibuffer and copy it to kill ring (clip-board)
(defun copy-full-path-to-kill-ring ()
  "Copy buffer's full path to kill ring."
  (interactive)
  (let ((buffer-path dired-directory))
    (when buffer-file-name
      (setq buffer-path buffer-file-name))
    (when buffer-path
      (message (concat "Copied full-path to clipboard: " buffer-path))
      (kill-new (file-truename buffer-path)))))

(defun toggle-camelcase-snakecase ()
  "Toggles the symbol at point between snake_case and CamelCase."
  (interactive)
  (let* ((bounds (bounds-of-thing-at-point 'symbol))
         (str (buffer-substring-no-properties (car bounds) (cdr bounds)))
         (case-fn
          (if (string-match-p "_" str)
              #'camelize-string
            #'snake-case))
         (new-str (funcall case-fn str)))
    (delete-region (car bounds) (cdr bounds))
    (insert new-str)))

(defun camelize-string (str)
  "Converts snake_case string STR to CamelCase."
  (mapconcat 'capitalize (split-string str "_") ""))

(defun snake-case (str)
  "Converts CamelCase string STR to snake_case."
  (let ((case-fold-search nil))
    (downcase
     (replace-regexp-in-string
      "\\([A-Z]+\\)" "_\\1"
      (replace-regexp-in-string
       "\\([A-Z][a-z]\\)" "\\1" str)))))

(defun create-or-switch-to-shell(name)
  ;; (with-eval-after-load 'shell
  ;;   (native-complete-setup-bash))
  (if (get-buffer name)
      (switch-to-buffer name)
    (eshell)
    ;; (vterm name)
    (rename-buffer name)
    )
  )

(defun open-local-shell ()
  "Open a shell with name `local-shell`"
  (interactive)
  (create-or-switch-to-shell "local-shell")
  )

(defun open-server-shell ()
  "Open a shell with name `server-shell`"
  (interactive)
  (create-or-switch-to-shell "server-shell")
  )
