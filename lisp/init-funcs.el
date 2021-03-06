;;; Code:


(defun kumo-open-init-file()
  "Open init.el file."
  (interactive)
  (find-file "~/.emacs.d/init.el"))


(defun dos2unix ()
  "Convert the current buffer to UNIX file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix nil))


(defun unix2dos ()
  "Convert the current buffer to DOS file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos nil))


(defun save-buffer-as-utf8 (coding-system)
  "Revert a buffer with `CODING-SYSTEM' and save as UTF-8."
  (interactive "zCoding system for visited file (default nil):")
  (revert-buffer-with-coding-system coding-system)
  (set-buffer-file-coding-system 'utf-8)
  (save-buffer))


(defun kumo-kill-this-buffer (&optional arg)
  "Kill the current buffer.
ARG: If the universal prefix argument is used then kill also the window."
  (interactive "P")
  (if (window-minibuffer-p)
      (abort-recursive-edit)
    (if arg
        (kill-buffer-and-window)
      (kill-buffer)))
  (message "Buffers deleted!"))


(defun kumo-kill-other-buffers (&optional arg)
  "Kill other buffers.
ARG: If the universal prefix argument is used then will the windows too."
  (interactive "P")
  (when (yes-or-no-p (format "Killing all buffers except \"%s\"? "
                             (buffer-name)))
    (mapc 'kill-buffer
          (delq (current-buffer) (buffer-list)))
    (when arg (delete-other-windows))
    (message "Buffers deleted!")))


(defun kumo-kill-all-buffers ()
  "Kill all buffers."
  (interactive "P")
  (mapc 'kill-buffer (buffer-list))
  (kumo-open-dashboard)
  (message "Buffers deleted!"))


(defun kumo-switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))


(defvar temp-number 0 "Temp-buffer tag.")
(defun kumo-new-temp-buffer ()
  "New a temp buffer."
  (interactive)
  (progn
    (switch-to-buffer-other-window (concat "*temp-" (number-to-string temp-number) "*"))
    (setq temp-number (+ temp-number 1))
    (insert (concat "// Happy hacking, " user-login-name " - Emacs ♥ you!"))))


(defun kumo-rename-current-buffer-file ()
  "Rename current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!")
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully rename to '%s'"
                   name (file-name-nondirectory new-name)))))))


(defun kumo-delete-current-buffer-file ()
  "Removes file connected to current buffer and kill buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))


(defun kumo-cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))


(defun kumo-cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (kumo-cleanup-buffer-safe)
  (indent-region (point-min) (point-max)))


(defun kumo-rotate-window ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))


(defun kumo-toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))


;; Font
(defun kumo-font-size-increase ()
  "Font size increase."
  (interactive)
  (let ((old-face-attribute (face-attribute 'default :height)))
    (set-face-attribute 'default nil :height (+ old-face-attribute 10))))


(defun kumo-font-size-decrease ()
  "Font size decrease."
  (interactive)
  (let ((old-face-attribute (face-attribute 'default :height)))
    (set-face-attribute 'default nil :height (- old-face-attribute 10))))


;; Wrap selected text by input symbol.
(defun kumo-wrap-with-input (beg end symbol)
  "Wrap selected text by input symbol."
  (interactive "r \nsPlease input symbol: ")
  (let ((map-list '(("''" . "'")
                    ("\"\"" . "\"")
                    ("``" . "`"))))
    (cl-loop for (i . j) in map-list
             do (when (string= symbol i)
                  (setq symbol j))))

  (let ((beg-symbol symbol)
        (end-symbol symbol))
    (cl-loop for (i . j) in kumo/symbol-list
             do (cond
                 ((string= symbol j)
                  (setq beg-symbol i))
                 ((string= symbol i)
                  (setq end-symbol j))
                 ))
    (goto-char beg)
    (insert beg-symbol)
    (goto-char (1+ end))
    (insert end-symbol)))


(defun kumo-window-vertically-selected ()
  "Split window vertically and selected."
  (interactive)
  (split-window-vertically)
  (other-window 1))


(defun kumo-window-horizontally-selected ()
  "Split window horizontally and selected."
  (interactive)
  (split-window-horizontally)
  (other-window 1))


(defun kumo-flycheck-list-errors-toggle ()
  "Open or delete flycheck-errors-list window."
  (interactive)
  (let ((w (get-buffer-window kumo/flycheck-errors-buffer-name)))
    (if w
        (delete-window w)
      (flycheck-list-errors))))


(defun kumo-flycheck-list-errors-select-window ()
  "Select window for flycheck-errors-list."
  (interactive)
  (select-window (get-buffer-window kumo/flycheck-errors-buffer-name)))


(defun kumo-vterm-select-window ()
  "Select window for vterm."
  (interactive)
  (catch 'break
    (dolist (i (window-list))
      (let ((name (buffer-name (window-buffer i))))
        (when (string-match-p "vterm" name)
          (select-window (get-buffer-window name))
          (throw 'break nil))))
    ))


(defun kumo-new-vterm ()
  "New a vterm."
  (interactive)
  (if (fboundp 'vterm-mode)
      (let ((buffer (generate-new-buffer "vterm")))
        (with-current-buffer (buffer-name buffer)
          (vterm-mode))
        (kumo-bottom-window buffer))
    (vterm)))


(defun kumo-bottom-window (buffer)
  "Open a bottom window.
BUFFER is the symbol."
  (display-buffer-in-side-window
   buffer
   '((side . bottom)
     (dedicated . t)
     (reusable-frames . visible)
     (window-height . 0.3))))


(defun kumo-current-buffer-bottom-window ()
  "Current buffer display on then bottom window."
  (interactive)
  (delete-window)
  (kumo-bottom-window (window-buffer)))


(defun kumo-open-dashboard ()
  "Open the *dashboard* buffer and jump to the first widget."
  (interactive)
  (delete-other-windows)
  (if (get-buffer dashboard-buffer-name)
      (kill-buffer dashboard-buffer-name))
  (dashboard-insert-startupify-lists)
  (switch-to-buffer dashboard-buffer-name)
  (run-at-time "0.1sec" nil
               (lambda ()
                 (goto-line kumo/dashboard-position))))


(defun kumo-indent-all ()
  "Mark whole buffer."
  (interactive)
  (let ((point (point)))
    (mark-whole-buffer)
    (indent-for-tab-command)
    (goto-char point)))


(defun kumo-home-path-resolve (path)
  "Return $HOME + path.
PATH is a string."
  (concat (getenv "HOME") path))


(defun kumo-number-division (beg end &optional num)
  "Selected number division.
BEG is begin point.
END is end point.
NUM is a number."
  (interactive "r\nsPlease input number: ")
  (setq num (string-to-number num))
  (if (use-region-p)
      (let ((regionp (buffer-substring beg end))
            (n (if (= num 0) 14 num)))
        (delete-region beg end)
        (insert
         (number-to-string (/ (string-to-number regionp) (float n)))))))


(defun kumo-timestamp ()
  "Timestamp.
eg: 2020-02-22T22:22:22."
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%H:%M:%S")))


(defun kumo-select-minibuffer-window ()
  "Select minibuffer window."
  (interactive)
  (select-window (active-minibuffer-window)))


(defun kumo-winum-delete-window-factory (num)
  "Winum delete window function macro factory.
NUM is the window number."
  `(defun ,(intern (concat "winum-delete-window-" (number-to-string num))) ()
     (interactive)
     (,(intern-soft (concat "winum-select-window-" (number-to-string num))) t)))


(defmacro kumo-winum-delete-window-macro-factory ()
  "Winum delete window function macro factory."
  `(progn ,@(mapcar 'kumo-winum-delete-window-factory '(0 1 2 3 4 5 6 7 8 9))))


(provide 'init-funcs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-funcs.el ends here
