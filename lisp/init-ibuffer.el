;;; Code:


(use-package ibuffer
  :ensure nil
  :functions
  (all-the-icons-icon-for-file
   all-the-icons-icon-for-mode
   all-the-icons-auto-mode-match?
   all-the-icons-faicon
   my-ibuffer-find-file)
  :commands
  (ibuffer-find-file
   ibuffer-current-buffer)
  :bind
  (("C-x C-b" . ibuffer)
   :map ibuffer-mode-map
   ("j" . ibuffer-forward-line)
   ("k" . ibuffer-backward-line)
   ("h" . ibuffer-do-kill-lines)
   ("p" . ibuffer-jump-to-buffer))
  :custom
  (ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold)))
  :config
  (with-eval-after-load 'counsel
    (advice-add #'ibuffer-find-file :override #'(lambda ()
                                                  (interactive)
                                                  (let ((default-directory (let ((buf (ibuffer-current-buffer)))
                                                                             (if (buffer-live-p buf)
                                                                                 (with-current-buffer buf
                                                                                   default-directory)
                                                                               default-directory))))
                                                    (counsel-find-file default-directory))
                                                  )))

  (use-package all-the-icons-ibuffer
    :hook
    (ibuffer-mode . all-the-icons-ibuffer-mode))

  ;; Group ibuffer's list by project root
  (use-package ibuffer-projectile
    :functions all-the-icons-octicon ibuffer-do-sort-by-alphabetic
    :hook
    (ibuffer . (lambda ()
                 (ibuffer-projectile-set-filter-groups)
                 (unless (eq ibuffer-sorting-mode 'alphabetic)
                   (ibuffer-do-sort-by-alphabetic))))
    :custom
    (ibuffer-projectile-prefix
     (concat
      (all-the-icons-octicon "file-directory"
                             :face ibuffer-filter-group-name-face
                             :v-adjust -0.05
                             :height 1.25)
      " ")))
  )


(provide 'init-ibuffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-ibuffer.el ends here
