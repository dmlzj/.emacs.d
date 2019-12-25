(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

(defvar current-directory default-directory
  "emacs startup directory")

;; Prefers the newest version of a file
(setq load-prefer-newer t)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; Environment
;; (when (or sys/mac-x-p sys/linux-x-p)
;;   (use-package exec-path-from-shell
;;     :init
;;     (setq exec-path-from-shell-check-startup-files nil)
;;     (setq exec-path-from-shell-variables '("PATH" "MANPATH" "GOPATH"))
;;     (setq exec-path-from-shell-arguments '("-l"))
;;     (exec-path-from-shell-initialize)))

;; (mapconcat 'identity (list "zzzz" "ffff" "/a/v") ",") 
(progn
  (setenv "PATH" (concat (getenv "PATH") ":" (mapconcat 'identity sys/path ":")))
  (dolist (i sys/path)
    (add-to-list 'exec-path i)))
  ;; (add-to-list 'exec-path my-path))

 ;; (let ((my-path "/usr/local/bin"))
 ;;   (setenv "PATH" (concat my-path ":" (getenv "PATH"))) ; Assume ":" is the separator
 ;;   (add-to-list 'exec-path my-path))

;; History
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :init
  (setq recentf-max-saved-items 200)
  (setq recentf-exclude '((expand-file-name package-user-dir)
                          ".cache"
                          ".cask"
                          ".elfeed"
                          "bookmarks"
                          "cache"
                          "ido.*"
                          "persp-confs"
                          "recentf"
                          "url"
                          "COMMIT_EDITMSG\\'")))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
                                              global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300))

(setq mouse-drag-copy-region t)

;; open init.el
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") 'open-init-file)


;; fixed : Disabling backend flymake-proc-legacy-flymake because (error Can’t find a suitable init function)
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)


(provide 'init-basic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-basic.el ends here
