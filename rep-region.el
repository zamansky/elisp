


(defun count-region (start end)
"count chars in region"
(interactive "r")
(print (- end start)))


(defun replace-region-with-count (start end)
""
(interactive "r")
(let ( (len (- end start)))
  (kill-region start end)
  (insert (format "%d" len))))
  
    
