(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(imenus all-the-icons go-mode neotree dotenv-mode avy exec-path-from-shell highlight-symbol multiple-cursors projectile ag monokai-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 ;; setup files ending in .graphqls to open in graphql-mode
 (add-to-list
  'auto-mode-alist
  '("\\.graphqls?\\'" . graphql-mode))
 )
