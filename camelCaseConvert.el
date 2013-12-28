
;; Fit cut at converting a c style identifier (all lower case) into camelCase
;; You have to mark the identifier since this works on a region.
(defun toCamelTest (start end) 
  "something"
  (interactive "*r")
  (upcase-initials-region start end)
  (narrow-to-region start end)
  (replace-string "_" "")
  (widen))

(defun toCamel ()
  "Convert the identifier at the current point from c style (lower case with underscores) to camelCase"
  (interactive)
  (let (start end)
    (save-excursion
      (search-backward-regexp "^\\| ") ;; go to beginning of word
      (search-forward "_") ;; and then to the first _
      (setq start (- (point) 1))
      (forward-char 1)
      (search-forward-regexp "(\\| \\|$") ;; find the end of the identifier
      (setq end (point))
      (upcase-initials-region (+ 1 start) end) ;; upcase all the words
      (replace-string "_" "" nil start end) ;; remove the _
      (downcase-word nil)))) ;; make the first letter lowercase


(defun toSnake ()
  "Convert the identifier at the current point from camelCase to C style"
  (interactive)
  (let (start end)
    (save-excursion
      (search-backward-regexp " \\|^") ;; find the start of the identifier
      (setq start (point))
      (forward-char 1)
      (search-forward-regexp "( \\|$") ;; and the end
      (setq end (point))
      (replace-regexp "\\([A-Z]\\)" "_\\1" nil start end) ;; replace upper case letters with _L where L is the letter
      (downcase-region start end) ;; then make everything lowercase
      )))


(defun switch-java-c ()
  "Converts between camelcase and snakecase"
  (interactive)
  (let (start end snake) 
    (save-excursion) 
      (search-backward-regexp " \\|^")
      (setq start (point))
      (forward-char 1)
      (search-forward-regexp "(\\| \\|$")
      (setq end (point))
      (save-restriction
	(narrow-to-region start end)
	(goto-char 0)
	(setq snake (search-forward "_" nil t))) ;; _ means snake_case
      (if snake 
	  (toCamel)
	(toSnake))))

;; bind to a key for demo and testing purposes
;;(global-set-key (kbd "<f1>") 'switch-java-c)


