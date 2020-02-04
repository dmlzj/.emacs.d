;;; Code:


;; C/C++ Mode
(use-package cc-mode
  :bind
  (:map c-mode-base-map
         ("C-c c" . compile))
  :custom
  (c-basic-offset 2)
  :config
  (use-package modern-cpp-font-lock
    :diminish
    :init (modern-c++-font-lock-global-mode t)))


(provide 'init-cpp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-cpp.el ends here
