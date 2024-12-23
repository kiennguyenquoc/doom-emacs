;;; go-lang-server.el -*- lexical-binding: t; -*-

;; Start LSP Mode and YASnippet mode
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\~/go\\'")
  ;; or
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.yaml\\'"))

(after! lsp-mode
  (setq
   lsp-use-plists 1
   read-process-output-max (* 3 1024 1024)
   gc-cons-threshold 100000000
   lsp-headerline-breadcrumb-enable 1
   lsp-go-use-gofumpt t
   lsp-auto-guess-root t ; Detect project root
   lsp-keep-workspace-alive nil ; Auto-kill LSP server
   ;; lsp-prefer-capf t
   lsp-file-watch-threshold 2000
   lsp-enable-on-type-formatting nil
   lsp-ui-sideline-enable nil
   lsp-ui-sideline-show-code-actions nil
   lsp-log-io nil
   lsp-enable-links nil
   lsp-ui-doc-enable nil
   lsp-enable-folding t
   lsp-diagnostics-provider :auto
   lsp-signature-auto-activate nil
   lsp-signature-render-documentation nil
   lsp-enable-snippet t
   lsp-ui-doc-show-with-cursor nil
   lsp-ui-doc-show-with-mouse nil
   lsp-restart 'auto-restart
   lsp-lens-enable nil
   lsp-idle-delay 1
   lsp-headerline-breadcrumb-segments '(project file symbols)
   lsp-client-packages '(lsp-golangci-lint)
   lsp-go-analyses '(
                     (simplifycompositelit . :json-false)
                     (nilness . t)
                     (shadow . t)
                     (unusedparams . t)
                     (unusedwrite . t)
                     (useany . t)
                     (unusedvariable . t))
   ))

(setenv "LSP_USE_PLISTS" "true")
;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

;; Optional: install eglot-format-buffer as a save hook.
;; The depth of -10 places this before eglot's willSave notification,
;; so that that notification reports the actual contents that will be saved.
(defun eglot-format-buffer-before-save ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t)
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))

;; (add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook #'lsp-deferred)
;; (add-hook 'go-mode-hook #'yas-minor-mode)
;; (add-hook 'go-mode-hook #'eglot-format-buffer-before-save)
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

(map!
 "M-g i" #'lsp-find-implementation
 "C-S-a" #'lsp-execute-code-action
 )
