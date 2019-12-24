(use-package evil)
(evil-mode 1)

(use-package evil-search-highlight-persist
  :init
  (add-hook 'after-init-hook '(lambda()
                                (global-evil-search-highlight-persist t))))

(use-package general)
(define-key evil-normal-state-map (kbd "SPC") (general-simulate-key "C-c"))

(general-define-key
 :states '(normal visual)
 :prefix ","
 "q"  'save-buffers-kill-terminal
 "Q"  'kumo-kill-emacs
 "bd"  'kumo-kill-this-buffer
 "bm"  'kumo-kill-other-buffers
 "ba"  'kumo-kill-all-buffers
 "k"   'symbol-overlay-put
 "dr"  'dired
 "sc"  'kumo-no-hlsearch
 "cc"  'comment-dwim-2
 "wd"  'delete-window
 "u"   'undo-tree-visualize
 "ff" 'counsel-find-file
 "ft" 'counsel-imenu
 "ag" 'kumo-ag
 "bb" 'counsel-switch-buffer
 ","  'counsel-M-x
 "w" 'avy-goto-char-timer
 
;; "fg" 'counsel-git
;; "gb"  'magit-blame-echo
;; "gs"  'magit-status
;; "gm"  'magit-dispatch-popup
;; "ww"  'save-buffer
 )

(general-define-key
 :prefix "C-c"
 "j" 'avy-goto-line-below
 "k" 'avy-goto-line-above
 "R" 'kumo-rename-current-buffer-file
 "K" 'kumo-delete-current-buffer-file
 "n" 'global-display-line-numbers-mode
 "t" 'treemacs-select-window
 "T" 'treemacs
 "S" 'counsel-rg
 "s" 'swiper
 )

(general-define-key
 :states '(normal visual)
 "j" 'evil-next-visual-line
 "k" 'evil-previous-visual-line
 "H" 'mwim-beginning-of-code-or-line
 "L" 'mwim-end-of-code-or-line
 "f" 'avy-goto-char-in-line
 "gb" 'pop-tag-mark
 "<f1>" 'start-eshell)



;; esc quits
(provide 'init-evil)
