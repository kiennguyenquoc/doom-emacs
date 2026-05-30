# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## CLI Commands

```bash
doom sync          # after editing init.el or packages.el — required before restarting
doom upgrade       # update Doom + packages
doom doctor        # diagnose config issues
doom env           # regenerate env file
```

Inside Emacs:
- `M-x doom/reload` — reload config without restart
- `M-x doom/reload-packages` — reload package declarations

## Architecture

Three files, all in `~/.config/doom/`:

| File | Purpose |
|------|---------|
| `init.el` | Module selection — what Doom loads. Edit here to enable/disable language/tool modules. Run `doom sync` after. |
| `packages.el` | Extra package declarations via `(package! ...)`. No byte-compile. Run `doom sync` after. |
| `config.el` | All personal config — runs after Doom loads. Use `after!` / `use-package!` for deferred setup. |

## Key Patterns in config.el

**Deferred config** — always use `after!` or `use-package! ... :defer`:
```elisp
(after! eglot
  ...)
```
Never `(require 'eglot)` at top level — breaks startup time.

**LSP** — Eglot (not lsp-mode). Go uses `gopls` with GOGC/GOMEMLIMIT caps:
```elisp
'((go-mode go-ts-mode) . ("env" "GOGC=50" "GOMEMLIMIT=1024MiB" "gopls"))
```

**Go formatting** — `eglot-format-buffer` + `eglot-organize-imports` on `before-save-hook`. Apheleia and `format-all-formatters` disabled for Go to avoid conflicts.

**Protobuf** — `buf lsp serve` via Eglot. Format via `eglot-format-buffer` on save. Apheleia disabled.

**Treesit** — Go remapped to `go-ts-mode` via `major-mode-remap-alist`.

**Completion stack** — corfu + orderless + vertico + cape (no company).

**Flymake** (not flycheck) — check on save only (`flymake-start-on-save-buffer t`, `flymake-no-changes-timeout 2.0`).

## Key Bindings (custom)

| Key | Action |
|-----|--------|
| `C-.` | `xref-find-definitions` |
| `C-"` | `xref-find-references` |
| `M-g i` | `eglot-find-implementation` |
| `C-S-a` | `eglot-code-actions` |
| `C-S-f` | `consult-ripgrep` |
| `C-S-s` | `consult-line` |
| `C-<tab>` | switch workspace right |
| `M-s l/s/e` | local/server/claude-code vterm shells |
| `SPC t t` | toggle Treemacs |
| `C-c t/T` | go-tag add/remove |
| `C-c s d` | `go-spew-dump-at-point` |
| Leader `m t t/a/p/b/c` | gotest run test/all/package/bench/coverage |

## Modules Active (notable)

- Completion: `corfu +orderless`, `vertico`
- Editor: `format +onsave`, `multiple-cursors`, `snippets`
- Tools: `lsp +eglot`, `magit`, `tree-sitter`, `lookup`
- Lang: `go +lsp`, `graphql +lsp`, `sh`, `yaml`, `json`, `data`
- Term: `vterm`, `eshell`

## Extra Packages (packages.el)

`blamer`, `dumb-jump`, `highlight-symbol`, `monokai-theme`, `avy`, `protobuf-mode`, `dotenv-mode`, `rg`, `projectile-ripgrep`, `restclient`, `ob-restclient`, `go-gen-test`, `gotest`, `gcmh`, `imenu-list`, `ibuffer-vc`

## macOS Notes

- `mac-command-modifier` = meta, `mac-option-modifier` = nil
- `eglot-ignored-server-capabilities` excludes `:workspace/didChangeWatchedFiles` — avoids hitting macOS file descriptor limit on large projects
- `treemacs-filewatch-mode` disabled for same reason
