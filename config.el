;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Nguyễn Quốc Kiện (Sr. Software Engineer II)"
      user-mail-address "kien.nguyen2@cake.vn")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font
      (font-spec
       :family "JetBrains Mono"
       :size 14 :slant 'normal :weight 'normal))
(custom-set-faces!
  '(region :background "#9aa0c2" :extend t)
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))


(custom-set-faces!
  '(hl-line :background "#3e4446")
  ;; '(highlight :foreground "#aa2ee8")

  ;; Workspace tabs — highlight tab đang active
  '(+workspace-tab-selected-face :background "#fd971f" :foreground "#272822" :weight bold)
  '(+workspace-tab-face          :background "#3e3d31" :foreground "#75715e" :weight normal))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

(use-package! all-the-icons)


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

(setq doom-theme 'monokai)
;; (setq doom-theme 'doom-ayu-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)
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
;; (setq persp-emacsclient-init-frame-behaviour-override t)
(require 'lsp-mode)
(require 'projectile)
(require 'consult)


(setq-default tab-width 2)
(setq go-packages-function 'go-packages-go-list)
(defconst private-dir (expand-file-name "private" doom-user-dir))
(defconst temp-dir (expand-file-name "cache" private-dir)
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
      custom-file                         (expand-file-name "custom.el" doom-user-dir)
      ;; http://ergoemacs.org/emacs/emacs_stop_cursor_enter_prompt.html
      minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt)

      ;; Disable non selected window highlight
      cursor-in-non-selected-windows     'hollow
      highlight-nonselected-windows      nil
      ;; PATH
      ;; exec-path                          (append exec-path '("/usr/local/bin/"))
      inhibit-startup-message            t
      fringes-outside-margins            t
      select-enable-clipboard            t
      ;; savehist-minibuffer-history-variables nil
      tramp-mode t
      inhibit-compacting-font-caches t
      )

(setq markdown-command
      "pandoc --from markdown --to html --standalone --syntax-highlighting=pygments")

(setq-default cursor-type 'bar)
(blink-cursor-mode 1)

;; Backups enabled, use nil to disable
(setq
 history-length                     100
 backup-inhibited                   nil
 auto-save-default                  t
 make-backup-files                  t
 backup-directory-alist            `((".*" . ,(concat temp-dir "/backup/")))
 auto-save-file-name-transforms    `((".*" ,(concat temp-dir "/auto-save-list/") t))
 ;; treemacs-display-current-project-exclusively t
 ;; treemacs-project-follow-mode t
 enable-recursive-minibuffers t ; Allow commands in minibuffers
 savehist-additional-variables '(mark-ring
                                 global-mark-ring
                                 search-ring
                                 regexp-search-ring
                                 extended-command-history
                                 kill-ring)
 savehist-autosave-interval 30
 )

(put 'minibuffer-history 'history-length 50)
(put 'evil-ex-history 'history-length 50)
(put 'kill-ring 'history-length 25)

(unless (file-exists-p (concat temp-dir "/auto-save-list"))
  (make-directory (concat temp-dir "/auto-save-list") :parents))

(setq use-short-answers t)
(global-auto-revert-mode t)

;; Disable toolbar & menubar
;; (menu-bar-mode -1)
(tooltip-mode    -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Delete trailing whitespace before save
(show-paren-mode)
(electric-pair-mode)
(global-hl-line-mode +1)
(delete-selection-mode +1)

(setq-default truncate-lines nil)

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))
(setq ns-function-modifier 'control)

(setq load-prefer-newer t)
(setq native-comp-async-report-warnings-errors nil)

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

(use-package! blamer
  :bind (("s-i" . blamer-show-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 1.0)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                   :background nil
                   :height 140
                   :italic t)))
  :config
  (global-blamer-mode 1))

(after! treemacs
  (add-hook 'treemacs-mode-hook
            (lambda ()
              (setq-local truncate-lines t)
              (setq-local word-wrap nil)))
  (setq treemacs-width 30)
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1))

;; (after! persp-mode
;;   (setq persp-autokill-buffer-on-remove 'kill-weak))

(after! consult
  (setq consult-buffer-sources
        '(consult--source-hidden-buffer
          consult--source-modified-buffer
          consult--source-buffer
          consult--source-recent-file)))

(map! :leader
      :desc "Toggle Treemacs"
      "t t" #'treemacs
      "t s" #'treemacs-select-window
      )

(map!
 "C-<tab>" #'+workspace/switch-right
 "C-x p r" #'projectile-ripgrep
 "C-S-i" #'windmove-up
 "C-S-k" #'windmove-down
 "C-S-j" #'windmove-left
 "C-S-l" #'windmove-right

 "C-." #'xref-find-definitions
 "C-\"" #'xref-find-references
 "M-g i" #'lsp-find-implementation

 "C-S-c C-S-c" #'mc/edit-lines
 "C->" #'mc/mark-next-like-this
 "C-<" #'mc/mark-previous-like-this
 "C-c C->" #'mc/mark-all-like-this

 [(control f3)] #'highlight-symbol
 [f3] #'highlight-symbol-next
 [(shift f3)] #'highlight-symbol-prev

 "C-S-a" #'lsp-execute-code-action

 "M-i" #'imenu-list-smart-toggle

 "M-," #'better-jumper-jump-backward
 "M-." #'better-jumper-jump-forward

 "M-*" #'pop-tag-mark

 "C-c h" #'hs-hide-block
 "C-c d" #'hs-show-block
 "C-c g" #'hs-toggle-hiding

 "C-S-s" #'consult-line
 "M-g f" #'go-goto-function-name

 "M-s l" #'open-local-shell
 "M-s s" #'open-server-shell
 "M-s e" #'open-claude-code-shell
 )


;;; COMPLETION STACK
(after! vertico
  (setq vertico-cycle t
        vertico-sort-function #'vertico-sort-history-alpha))

(after! orderless
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion))
          (lsp-capf (styles orderless flex))))

  (setq orderless-matching-styles
        '(orderless-literal
          orderless-prefixes
	  orderless-initialism
          orderless-flex)))

(after! corfu
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (setq corfu-sort-function #'corfu-sort-length-then-alpha)
  (setq corfu-auto t
        corfu-cycle t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-preview-current nil
        corfu-quit-at-boundary nil
	corfu-preselect 'prompt
        corfu-quit-no-match t
        corfu-scroll-margin 5))

(after! cape
  ;; global
  (add-to-list 'completion-at-point-functions #'cape-file)

  ;; Go
  (add-hook 'go-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions
                           (cape-capf-super
                            #'lsp-completion-at-point
                            #'cape-file))

              (add-to-list 'completion-at-point-functions #'cape-keyword))))

(after! consult
  (setq consult-narrow-key "<"))

(after! imenu-list
  (add-hook 'imenu-list-major-mode-hook
            (lambda ()
              (setq-local truncate-lines t)
              (setq-local word-wrap nil))))

(after! vterm
  (setq vterm-shell (getenv "SHELL"))
  (setq vterm-max-scrollback 10000)
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-copy-exclude-prompt t)
  (setq vterm-timer-delay 0.05))


(after! consult-lsp
  (map! "M-g d" #'consult-lsp-diagnostics
        "M-g s" #'consult-lsp-file-symbols
        "M-g S" #'consult-lsp-symbols))

(map!
 ;; "C-s" #'consult-line
 "C-S-f" #'consult-ripgrep
 "C-c s b" #'consult-buffer
 "C-c s i" #'consult-imenu)

;; ─── Protobuf + buf ──────────────────────────────────────────────────────────
(after! protobuf-mode
  (add-hook 'protobuf-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil
                    tab-width 2)
              )))


;; (add-hook 'go-mode-hook (lambda () (require 'lsp-mode)))
;; (add-hook 'go-mode-hook #'lsp-deferred)

(after! lsp-mode
  (add-to-list 'lsp-client-packages 'lsp-golangci-lint)
  (setq
   lsp-semantic-tokens-enable nil
   ;; ─── File Watchers ───────────────────────────────────────────────
   lsp-enable-file-watchers        nil

   ;; ─── Performance ─────────────────────────────────────────────────
   lsp-use-plists                  t
   lsp-idle-delay                  0.5
   lsp-log-io                      nil
   read-process-output-max         (* 1024 1024 10)

   ;; ─── Symbol Highlighting ─────────────────────────────────────────
   lsp-enable-symbol-highlighting  t

   ;; ─── UI — tắt hết để nhẹ ─────────────────────────────────────────
   lsp-ui-doc-enable               nil
   lsp-ui-doc-show-with-cursor     nil
   lsp-ui-doc-show-with-mouse      nil
   lsp-ui-sideline-enable          nil
   lsp-ui-sideline-show-code-actions nil
   lsp-modeline-code-actions-enable t
   lsp-modeline-diagnostics-enable  t
   lsp-enable-links                nil
   lsp-lens-enable                 nil
   lsp-signature-auto-activate     nil
   lsp-signature-render-documentation nil

   ;; ─── Completion ──────────────────────────────────────────────────
   lsp-completion-provider                    :none
   lsp-completion-show-detail                 t
   lsp-completion-show-kind                   t
   lsp-completion-enable-additional-text-edit nil
   lsp-completion-filter-on-incomplete        nil
   lsp-completion-no-cache                    nil
   lsp-completion-sort-completion             t
   lsp-enable-snippet                         t

   ;; ─── Behavior ────────────────────────────────────────────────────
   lsp-diagnostics-provider       :auto
   lsp-enable-on-type-formatting  nil
   lsp-enable-folding             t
   lsp-auto-guess-root            nil
   lsp-keep-workspace-alive       nil
   lsp-restart                    'auto-restart
   lsp-headerline-breadcrumb-enable   t
   lsp-headerline-breadcrumb-segments '(project file symbols)

   ;; ─── Go / gopls ──────────────────────────────────────────────────
   lsp-go-use-gofumpt             t
   lsp-gopls-use-placeholders     nil
   lsp-go-hover-kind              "FullDocumentation"
   ;; lsp-go-env                     '((GOFLAGS . "-mod=mod"))

   ;; ─── Session Blacklist ────────────────────────────────────────────
   lsp-session-file-blacklist
   (list (expand-file-name "~/go")
         "/opt/homebrew"
         "/usr/local"
         "/usr/lib"))

  ;; ─── gopls Custom Settings ─────────────────────────────────────────
  (lsp-register-custom-settings
   '(;; Analyses
     ("gopls.analyses.nilness"         t   t)
     ("gopls.analyses.shadow"          t   t)
     ("gopls.analyses.unusedparams"    t   t)
     ("gopls.analyses.unusedwrite"     t   t)
     ("gopls.analyses.unusedvariable"  t   t)
     ("gopls.analyses.simplifycompositelit" :json-false t)
     ;; Completion
     ("gopls.completionBudget"     "100ms")
     ("gopls.matcher"              "Fuzzy")
     ("gopls.completeUnimported"   t t)
     ("gopls.deepCompletion"       :json-false t)
     ("gopls.memoryMode"           "DegradeClosed")))

  ;; ─── buf LSP (protobuf) ──────────────────────────────────────────────
  (when (executable-find "buf")
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection '("buf" "beta" "lsp"))
      :activation-fn (lsp-activate-on "protobuf")
      :major-modes '(protobuf-mode)
      :server-id 'buf-lsp
      :priority 1)))

  ;; ─── File Watch Ignore Patterns ──────────────────────────────────────
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\~/go\\'")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.yaml\\'"))

(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(use-package! exec-path-from-shell
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

(after! projectile
  ;; Doom tự handle workspace switching qua hook khi behavior = t
  ;; KHÔNG gọi +workspaces-switch-to-project-h thủ công — sẽ chạy sai context
  (setq +workspaces-on-switch-project-behavior t)

  ;; Doom hook chạy trước, sau đó mới mở file picker
  (setq projectile-switch-project-action #'projectile-find-file)

  ;; giữ nguyên tuning của bạn
  (setq projectile-sort-order 'recently-active
        projectile-enable-caching t
        projectile-indexing-method 'alien
        projectile-globally-ignored-directories
        '("vendor" "node_modules" ".git" ".idea" ".vscode" "dist" "build" "tmp")
        projectile-ignored-project-function
        (lambda (dir)
          (when-let ((real (and (stringp dir)
                                (file-truename dir))))
            (or
             (string-prefix-p (expand-file-name "~/go") real)
             (string-prefix-p "/opt/homebrew" real)))))

  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(setq grip-update-after-change nil)

;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;(use-package! dape
;;  :config
;;  ;; Turn on global bindings for setting breakpoints with mouse
;;  (dape-breakpoint-global-mode)
;;
;;  ;; Info buffers to the right
;;  (setq dape-buffer-window-arrangement 'right)
;;  )

;; Enable repeat mode for more ergonomic `dape' use
;; (use-package! repeat
;;   :config
;;   (repeat-mode))

(use-package! avy
  :bind
  ("M-g g" . avy-goto-line)
  ;; ("c-s-o" . avy-goto-word-opr-subword-1)
  ;;("M-g s" . avy-goto-char-timer)
  :config
  (avy-setup-default) ;; can use c-' after trigger isearch
  )



(after! magit
  (define-key magit-mode-map (kbd "C-<tab>") #'+workspace/switch-right)
  (setq  magit-refresh-status-buffer nil
         magit-diff-refine-hunk t)
  )

(use-package! dotenv-mode
  :mode
  (("\\.env\\'" . dotenv-mode))
  (("\\.env.test\\'" . dotenv-mode))
  (("\\.env.development\\'" . dotenv-mode)))

(use-package! gcmh
  :config
  (setq gcmh-idle-delay 5         ;; GC sau 5s idle
        gcmh-high-cons-threshold (* 64 1024 1024)  ;; 64MB khi đang làm việc
        gcmh-low-cons-threshold (* 16 1024 1024))  ;; 16MB khi idle
  (gcmh-mode 1))

;; Tắt font-lock khi scroll
(setq jit-lock-defer-time 0.05
      jit-lock-stealth-time 1.0
      jit-lock-stealth-nice 0.1
      scroll-conservatively 101
      scroll-margin 3
      fast-but-imprecise-scrolling t)

;; inhibit resize frame khi mở minibuffer — giảm redraw
(setq frame-inhibit-implied-resize t)

;; better defaults
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other winDows (not just current)
 x-stretch-cursor t                               ; Stretch cursor to the glyph width
 uniquify-buffer-name-style 'forward)


;; (setq gofmt-command "goimports")


(setq imenu-auto-rescan t)

;; (setq
;;  neo-smart-open t
;;  neo-window-fixed-size nil
;;  neo-theme (if (display-graphic-p) 'icons 'arrow))

;; (setenv "SHELL" (executable-find "zsh"))
(let ((exec-path (append '("/usr/local/bin" "/usr/bin" "/bin") exec-path)))
  (setenv "SHELL" (executable-find "zsh")))
(setq shell-file-name (executable-find "zsh"))
(setq shell-command-switch "-ic")

(with-eval-after-load 'go-mode
  (setq go-tag-args (list "-transform" "snakecase"))
  (define-key go-mode-map (kbd "C-c t") #'go-tag-add)
  (define-key go-mode-map (kbd "C-c T") #'go-tag-remove))

(setq doom-modeline-major-mode-icon t)

;; (add-hook 'after-focus-change-function 'garbage-collect)
;; (run-with-idle-timer 5 t 'garbage-collect)

(setq default-frame-alist
      '((cursor-color . "dark orange")
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)
        (fullscreen . maximized)))

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

;; (defun set-exec-path-from-shell-PATH ()
;;   "Set up Emacs' `exec-path' and PATH env var to match that
;;    used by the user's shell.
;;  This is particularly useful under Mac OSX,
;;    where GUI apps are not started from a shell."
;;   (interactive)
;;   (let ((path-from-shell (replace-regexp-in-string
;;                           "[ \t\n]*$"
;;                           ""
;;                           (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
;;     (setenv "PATH" path-from-shell)
;;     (setq eshell-get-path path-from-shell) ; for eshell users
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer nil t)
  (add-hook 'before-save-hook #'lsp-organize-imports nil t))

(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Show current file-path in minibuffer and copy it to kill ring (clip-board)
(defun copy-full-path-to-kill-ring ()
  "Copy buffer's full path to kill ring."
  (interactive)
  (let ((buffer-path (bound-and-true-p dired-directory)))
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
      "^_" ""
      (replace-regexp-in-string
       "\\([A-Z]\\)" "_\\1" str)))))

(defun create-or-switch-to-shell(name)
  (if (get-buffer name)
      (switch-to-buffer name)
    ;; (eshell)
    (vterm name)
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

(defun open-claude-code-shell ()
  "Open claude code shell, start claude if new buffer."
  (interactive)
  (let ((exists (get-buffer "claude-code-shell")))
    (create-or-switch-to-shell "claude-code-shell")
    (unless exists
      (vterm-send-string "claude\n"))))

;; ─── gotest — chạy Go test trong Emacs ──────────────────────────────────────
(after! gotest
  (map! :map go-mode-map
        :leader
        (:prefix ("m t" . "test")
         :desc "Run test at point"  "t" #'go-test-current-test
         :desc "Run all tests"      "a" #'go-test-current-file
         :desc "Run package tests"  "p" #'go-test-current-project
         :desc "Run benchmarks"     "b" #'go-test-current-benchmark
         :desc "Test with coverage" "c" #'go-test-current-coverage)))

;; ─── ibuffer-vc — group buffers theo git repo ────────────────────────────────
(after! ibuffer
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))
