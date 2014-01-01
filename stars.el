

(defun stars-region (start end) 
  "replace the region (assuming it's a number) with stars"
  (interactive "*r")
    (let (x sline)
      (save-excursion
      (setq x (read (buffer-substring start end)))
      (kill-region start end)
      (setq sline "")
      (while (> x 0) 
	(setq sline (format "%s%s" sline "*"))
	(setq x (- x 1)))
      (insert sline))))

(defun stars () 
"if the line is only a number, replace it with stars"
(interactive)
(save-excursion
  (let (start end) 
    (setq end (point))
    (search-backward-regexp "[^0-9]\\|^")
    (stars-region (point) end))))













		 
		 
		 
		 
