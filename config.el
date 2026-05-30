;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Nguyễn Quốc Kiện (Sr. Software Engineer II)"
      user-mail-address "kien.nguyen2@cake.vn")

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
  '(eglot-highlight-symbol-face :background "#5c5b4e" :foreground "#e6db74" :weight bold)
  '(corfu-default :background "#2d2d2d" :foreground "#f8f8f2")
  '(corfu-current :background "#49483e" :foreground "#a6e22e" :weight bold)
  '(corfu-annotations :foreground "#75715e")
  '(+workspace-tab-selected-face :background "#fd971f" :foreground "#272822" :weight bold)
  '(+workspace-tab-face          :background "#3e3d31" :foreground "#75715e" :weight normal))

(use-package! all-the-icons)

(setq doom-theme 'monokai)
(setq display-line-numbers-type 'absolute)
(setq org-directory "~/org/")

;; Doom lazy-load những thư viện này — require đồng bộ sẽ gây chậm startup
;; (require 'lsp-mode)
;; (require 'projectile)
;; (require 'consult)

(setq-default tab-width 2)
(setq go-packages-function 'go-packages-go-list)
(defconst private-dir (expand-file-name "private" doom-user-dir))
(defconst temp-dir (expand-file-name "cache" private-dir))

(setq-default frame-title-format "%b - %f")

(setq confirm-kill-emacs                  'y-or-n-p
      confirm-nonexistent-file-or-buffer  t
      save-interprogram-paste-before-kill t
      mouse-yank-at-point                 t
      require-final-newline               t
      visible-bell                        nil
      ring-bell-function                  'ignore
      custom-file                         (expand-file-name "custom.el" doom-user-dir)
      minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt)
      cursor-in-non-selected-windows      'hollow
      highlight-nonselected-windows       nil
      inhibit-startup-message             t
      fringes-outside-margins             t
      select-enable-clipboard             t)

(setq markdown-command
      "pandoc --from markdown --to html --standalone --syntax-highlighting=pygments")

(setq-default cursor-type 'bar)
(blink-cursor-mode 1)

(setq history-length                   100
      backup-inhibited                 nil
      auto-save-default                t
      make-backup-files                t
      backup-directory-alist          `((".*" . ,(concat temp-dir "/backup/")))
      auto-save-file-name-transforms  `((".*" ,(concat temp-dir "/auto-save-list/") t))
      enable-recursive-minibuffers    t
      savehist-additional-variables   '(mark-ring
                                        global-mark-ring
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history
                                        kill-ring)
      savehist-autosave-interval      300)

(put 'minibuffer-history 'history-length 50)
(put 'evil-ex-history 'history-length 50)
(put 'kill-ring 'history-length 25)

(unless (file-exists-p (concat temp-dir "/auto-save-list"))
  (make-directory (concat temp-dir "/auto-save-list") :parents))

(setq use-short-answers t)
(setq auto-revert-use-notify t
      auto-revert-avoid-polling t)
(global-auto-revert-mode t)

(after! whitespace
  (setq whitespace-style
        (delq 'trailing whitespace-style)))

(delete-selection-mode +1)
(setq-default truncate-lines nil)

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))
(setq ns-function-modifier 'control)

(setq native-comp-async-report-warnings-errors nil)

;; emojify post-command hook kills redisplay on every keystroke — restrict to org/markdown only
(after! emojify
  (setq emojify-inhibit-in-buffer-functions
        (list (lambda (buf)
                (not (with-current-buffer buf
                       (derived-mode-p 'org-mode 'markdown-mode 'text-mode))))))
  (global-emojify-mode -1))

(use-package! blamer
  :bind (("s-i" . blamer-show-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 2.0)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                   :height 140
                   :italic t))))

(after! treemacs
  (add-hook 'treemacs-mode-hook
            (lambda ()
              (setq-local truncate-lines t)
              (setq-local word-wrap nil)))
  (setq treemacs-width 30)
  (setq treemacs-follow-after-init t
        treemacs-is-never-other-window nil
        treemacs-filewatch-mode nil)
  (treemacs-follow-mode 1)
  ;; Use frame scope — prevent Doom workspace-per-perspective from creating separate treemacs workspaces
  (treemacs-set-scope-type 'Frames))

(after! (treemacs projectile)
  (setq treemacs-project-follow-cleanup t)
  (treemacs-project-follow-mode 1)
  (add-hook 'projectile-after-switch-project-hook
            #'treemacs-add-and-display-current-project-exclusively))

(after! consult
  (setq consult-narrow-key "<")
  (setq consult-buffer-sources
        '(consult--source-hidden-buffer
          consult--source-modified-buffer
          consult--source-buffer
          consult--source-recent-file))
  (map! "M-g b" #'consult-bookmark))

(setq bookmark-save-flag 1)  ; auto-save bookmarks on change

(map! :leader
      :desc "Toggle Treemacs"
      "t t" #'treemacs
      "t s" #'treemacs-select-window)

(map!
 "C-<tab>" #'+workspace/switch-right
 "C-S-<tab>" #'+workspace/switch-left
 "C-x p r" #'projectile-ripgrep
 "C-S-i" #'windmove-up
 "C-S-k" #'windmove-down
 "C-S-j" #'windmove-left
 "C-S-l" #'windmove-right

 "C-." #'xref-find-definitions
 "C-\"" #'xref-find-references
 "M-g i" #'eglot-find-implementation

 "C-S-c C-S-c" #'mc/edit-lines
 "C->" #'mc/mark-next-like-this
 "C-<" #'mc/mark-previous-like-this
 "C-c C->" #'mc/mark-all-like-this

 [(control f3)] #'highlight-symbol
 [f3] #'highlight-symbol-next
 [(shift f3)] #'highlight-symbol-prev

 "C-S-a" #'eglot-code-actions
 "M-i" #'imenu-list-smart-toggle
 "M-," #'better-jumper-jump-backward
 "M-." #'better-jumper-jump-forward

 "C-c h" #'hs-hide-block
 "C-c d" #'hs-show-block
 "C-c g" #'hs-toggle-hiding

 "C-S-s" #'consult-line
 "M-g f" #'go-goto-function-name

 "M-s l" #'open-local-shell
 "M-s s" #'open-server-shell
 "M-s e" #'open-claude-code-shell)

;; Feed xref jumps into better-jumper so M-, works after C-. too
(after! better-jumper
  (add-hook 'xref-after-jump-hook #'better-jumper-set-jump))


;;; COMPLETION STACK
(after! vertico
  (setq vertico-cycle t
        vertico-sort-function #'vertico-sort-history-alpha))

(after! orderless
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion))))
  (setq orderless-matching-styles
        '(orderless-literal
          orderless-prefixes
          orderless-initialism
          orderless-flex)))

(after! corfu
  (corfu-popupinfo-mode)
  (setq corfu-sort-function #'corfu-sort-length-then-alpha
        corfu-auto t
        corfu-cycle t
        corfu-auto-delay 0.3
        corfu-auto-prefix 2
        corfu-preview-current nil
        corfu-quit-at-boundary nil
        corfu-preselect 'prompt
        corfu-quit-no-match t
        corfu-scroll-margin 5))

(after! cape
  (add-to-list 'completion-at-point-functions #'cape-file))

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

(map! "M-g d" #'consult-flymake
      "M-g s" #'consult-imenu)

(map!
 "C-S-f" #'consult-ripgrep
 "C-c s b" #'consult-buffer
 "C-c s i" #'consult-imenu)

;; ─── Protobuf ────────────────────────────────────────────────────────────────
(after! protobuf-mode
  (add-hook 'protobuf-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil
                    tab-width 2)
              (setq-local format-all-formatters nil)
              (when (fboundp 'apheleia-mode)
                (apheleia-mode -1))
              (add-hook 'before-save-hook #'eglot-format-buffer nil t)
              (eglot-ensure))))

(after! eglot
  (add-to-list 'eglot-server-programs
               '(protobuf-mode . ("buf" "lsp" "serve"))))

(after! dumb-jump
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 'append))

(after! projectile
  ;; Doom tự handle workspace switching qua hook khi behavior = t
  (setq +workspaces-on-switch-project-behavior t)
  (setq projectile-switch-project-action #'projectile-find-file-dwim)
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

(use-package! avy
  :bind
  ("M-g g" . avy-goto-line)
  :config
  (avy-setup-default))

(after! magit
  (define-key magit-mode-map (kbd "C-<tab>") #'+workspace/switch-right)
  (setq magit-refresh-status-buffer nil
        magit-diff-refine-hunk t
        magit-commit-show-diff nil)
  ;; Tránh re-render diff mỗi khi mở cửa sổ commit
  (remove-hook 'server-switch-hook #'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook #'magit-commit-diff)
  ;; Fix: (setting-constant nil) từ global-git-commit-mode
  (global-git-commit-mode -1))

(use-package! dotenv-mode
  :mode
  (("\\.env\\'" . dotenv-mode))
  (("\\.env.test\\'" . dotenv-mode))
  (("\\.env.development\\'" . dotenv-mode)))

(use-package! gcmh
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 256 1024 1024)
        gcmh-low-cons-threshold (* 32 1024 1024))
  (gcmh-mode 1))

(setq jit-lock-defer-time 0.05
      jit-lock-stealth-time 1.0
      jit-lock-stealth-nice 0.1
      scroll-conservatively 101
      scroll-margin 3
      fast-but-imprecise-scrolling t)

;; Giảm redraw khi mở minibuffer
(setq frame-inhibit-implied-resize t)

(setq-default
 delete-by-moving-to-trash t
 window-combination-resize t
 x-stretch-cursor t
 uniquify-buffer-name-style 'forward)

(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(go "https://github.com/tree-sitter/tree-sitter-go"))
  (add-to-list 'treesit-language-source-alist
               '(gomod "https://github.com/camdencheek/tree-sitter-go-mod"))
  (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode)))

(setq imenu-auto-rescan nil)

(setq exec-path (append '("/usr/local/bin" "/usr/bin" "/bin") exec-path))
(setenv "SHELL" (executable-find "zsh"))

;; Add cargo + local bins to exec-path so Emacs finds cargo-installed binaries
(dolist (dir (list (expand-file-name "~/.cargo/bin")
                   (expand-file-name "~/.local/bin")
                   "/opt/homebrew/bin"
                   "/usr/local/bin"))
  (add-to-list 'exec-path dir))
(setenv "PATH" (mapconcat #'identity (delete-dups exec-path) path-separator))
(setq shell-file-name (executable-find "zsh"))
(setq shell-command-switch "-c")

;; ─── Breadcrumb (LSP symbol path in header-line, no file path) ──────────────
(use-package! breadcrumb
  :hook ((go-ts-mode go-mode) . (lambda ()
                                  (setq-local header-line-format '(:eval (breadcrumb-imenu-crumbs)))))
  :config
  (setq bc-imenu-crumb-separator " ❯ ")
  (custom-set-faces!
    '(bc-imenu-crumbs-face :foreground "#75715e" :slant italic)
    '(bc-imenu-leaf-face   :foreground "#66d9e8" :weight bold :slant normal :underline t)))

;; ─── go-tag: apply to both modes ─────────────────────────────────────────────
(setq go-tag-args (list "-transform" "snakecase"))
(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "C-c t") #'go-tag-add)
  (define-key go-mode-map (kbd "C-c T") #'go-tag-remove))
(with-eval-after-load 'go-ts-mode
  (define-key go-ts-mode-map (kbd "C-c t") #'go-tag-add)
  (define-key go-ts-mode-map (kbd "C-c T") #'go-tag-remove))

(setq doom-modeline-major-mode-icon t)

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
          (lambda ()
            (local-set-key (kbd "C-l") 'eshell-clear-buffer)))

(defun my-file-notify-rm-all-watches ()
  "Remove all existing file notification watches from Emacs."
  (interactive)
  (maphash
   (lambda (key _value)
     (file-notify-rm-watch key))
   file-notify-descriptors))

(defun eglot-organize-imports ()
  "Organize imports using eglot."
  (interactive)
  (when (fboundp 'eglot-code-action-organize-imports)
    (eglot-code-action-organize-imports (point-min) (point-max))))

(defun my-go-eglot-save-h ()
  "Run organize-imports + format. Auto-start eglot if not alive."
  (unless (and (bound-and-true-p eglot--managed-mode) (fboundp 'eglot-current-server) (eglot-current-server))
    (when (fboundp 'eglot-ensure)
      (eglot-ensure)
      (sit-for 0.3)))
  (when (and (bound-and-true-p eglot--managed-mode) (fboundp 'eglot-current-server) (eglot-current-server))
    (with-demoted-errors "eglot format: %s"
      (eglot-format-buffer))
    (with-demoted-errors "eglot organize-imports: %s"
      (when (fboundp 'eglot-code-action-organize-imports)
        (eglot-code-action-organize-imports (point-min) (point-max))))))

(defun my-go-eglot-setup-h ()
  "Setup Eglot for Go with robust save hooks and disable conflicting formatters."
  (setq-local indent-tabs-mode t
              tab-width 4
              format-all-formatters nil)
  (when (fboundp 'apheleia-mode)
    (apheleia-mode -1))
  (add-hook 'before-save-hook #'my-go-eglot-save-h nil t))

(add-hook 'go-mode-hook #'my-go-eglot-setup-h)
(add-hook 'go-ts-mode-hook #'my-go-eglot-setup-h)

;; ─── Eglot ───────────────────────────────────────────────────────────────────
(after! flymake
  (setq flymake-no-changes-timeout 2.0)
  (setq flymake-start-on-flymake-mode t)
  (setq flymake-start-on-save-buffer t))

;; flycheck (syntax module) conflicts with eglot+flymake — disable for Go
(after! flycheck
  (setq flycheck-disabled-checkers
        (append flycheck-disabled-checkers
                '(go-gofmt go-golint go-vet go-build go-test go-errcheck go-staticcheck go-unconvert golangci-lint))))

;; Disable Doom's go module flycheck-golangci-lint hook — use go vet via flymake/eglot instead
(after! flycheck-golangci-lint
  (remove-hook 'go-mode-hook #'flycheck-golangci-lint-setup)
  (remove-hook 'go-ts-mode-hook #'flycheck-golangci-lint-setup))

(after! eglot
  (setq eglot-extend-to-xref t)
  ;; Không block UI khi gopls khởi động
  (setq eglot-sync-connect nil)
  (setq eldoc-echo-area-use-multiline-p nil)
  ;; Giảm tần suất eldoc update để không xung đột với flymake overlay
  (setq eldoc-idle-delay 0.5)
  ;; macOS hết file descriptor trên project lớn — nhường gopls tự watch native
  (setq eglot-ignored-server-capabilities '(:workspace/didChangeWatchedFiles))
  (setq-default eglot-workspace-configuration
                '((gopls .
                   (:gofumpt t
                    :usePlaceholders :json-false
                    :completeUnimported t
                    :expandWorkspaceToModule :json-false
                    :directoryFilters ["-.git" "-node_modules" "-vendor" "-tmp" "-dist" "-build"]
                    :deepCompletion :json-false
                    :matcher "Fuzzy"
                    :completionBudget "100ms"
                    :analyses
                    (:nilness t
                     :shadow t
                     :unusedparams t
                     :unusedwrite t
                     :unusedvariable t
                     :simplifycompositelit :json-false)))))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("env" "GOGC=50" "GOMEMLIMIT=1024MiB" "gopls")))
  (when (and (fboundp 'eglot-booster-mode)
             (executable-find "emacs-lsp-booster"))
    (eglot-booster-mode)))

;; ─── expand-region ───────────────────────────────────────────────────────────
(use-package! expand-region
  :bind ("C-=" . er/expand-region))

;; ─── flymake-golangci ────────────────────────────────────────────────────────
;; Disabled: golangci on large projects causes save-time hang.
;; Re-enable per-project via (flymake-golangci-load-backend) in dir-locals.
;; (after! flymake-golangci
;;   (add-hook 'go-mode-hook #'flymake-golangci-load-backend)
;;   (add-hook 'go-ts-mode-hook #'flymake-golangci-load-backend))

;; ─── consult-eglot ───────────────────────────────────────────────────────────
(after! consult-eglot
  (map! "M-g S" #'consult-eglot-symbols))

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
  (if-let* ((bounds (bounds-of-thing-at-point 'symbol))
            (str (buffer-substring-no-properties (car bounds) (cdr bounds)))
            (case-fn
             (if (string-match-p "_" str)
                 #'camelize-string
               #'snake-case))
            (new-str (funcall case-fn str)))
      (progn
        (delete-region (car bounds) (cdr bounds))
        (insert new-str))
    (message "No symbol at point")))

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

(defun create-or-switch-to-shell (name)
  (if (get-buffer name)
      (switch-to-buffer name)
    (vterm name)))

(defun open-local-shell ()
  "Open a shell with name `local-shell`"
  (interactive)
  (create-or-switch-to-shell "local-shell"))

(defun open-server-shell ()
  "Open a shell with name `server-shell`"
  (interactive)
  (create-or-switch-to-shell "server-shell"))

(defun open-claude-code-shell ()
  "Open claude code shell, start claude if new buffer."
  (interactive)
  (let ((exists (get-buffer "claude-code-shell")))
    (create-or-switch-to-shell "claude-code-shell")
    (unless exists
      (vterm-send-string "claude\n"))))

;; ─── dap-mode / dlv (Go debugger) ───────────────────────────────────────────
(after! dap-mode
  (require 'dap-dlv-go)
  (map! "<f5>"      #'dap-continue
        "<f9>"      #'dap-breakpoint-toggle
        "<f10>"     #'dap-next
        "<f11>"     #'dap-step-in
        "S-<f11>"   #'dap-step-out
        "C-<f5>"    #'dap-debug
        "S-<f5>"    #'dap-disconnect
        :map (go-mode-map go-ts-mode-map)
        "C-<f5>"    #'dap-debug
        "C-S-<f5>"  #'dap-go-debug-test-at-point))

;; ─── gotest ──────────────────────────────────────────────────────────────────
(after! gotest
  (map! :map (go-mode-map go-ts-mode-map)
        :leader
        (:prefix ("m t" . "test")
         :desc "Run test at point"  "t" #'go-test-current-test
         :desc "Run all tests"      "a" #'go-test-current-file
         :desc "Run package tests"  "p" #'go-test-current-project
         :desc "Run benchmarks"     "b" #'go-test-current-benchmark
         :desc "Test with coverage" "c" #'go-test-current-coverage)))

;; ─── Spew Dump Workflow ───────────────────────────────────────────────────────
(defun go-spew-dump-at-point ()
  "Wrap symbol at point inside spew.Dump( ... )"
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
    (if bounds
        (let ((sym (buffer-substring-no-properties (car bounds) (cdr bounds))))
          (delete-region (car bounds) (cdr bounds))
          (insert (format "spew.Dump(%s)" sym)))
      (insert "spew.Dump()"))))

(map! :after go-mode
      :map go-mode-map
      "C-c s d" #'go-spew-dump-at-point)
(map! :after go-ts-mode
      :map go-ts-mode-map
      "C-c s d" #'go-spew-dump-at-point)

;; ─── ibuffer-vc ──────────────────────────────────────────────────────────────
(after! ibuffer
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

;; ─── markdown-mode grip preview ──────────────────────────────────────────────
(add-hook 'markdown-mode-hook
          (lambda ()
            ;; C-c C-p: grip preview via local server (no temp files, full GFM with tables)
            (local-set-key (kbd "C-c C-p") #'grip-mode)))

;; Grip config — embedded webkit if Emacs supports it
(setq grip-preview-in-webkit t
      grip-command 'auto)

