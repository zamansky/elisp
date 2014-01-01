
(defun eval-replace ()
  ""
  (interactive)
  (backward-kill-sexp)
  (let ((exp (eval (read  (car  kill-ring-yank-pointer)))))
    (insert (format "%s" exp))))
