
(defcustom zemanta-api-key nil
  "Zemanta api key"
  :type '(string)'
  :group 'zemanta)




(defun zemanta-get-tags ()
  ""
  (interactive)
  (let* ( (url  "http://api.zemanta.com/services/rest/0.0/")
	  (url-request-method "POST")
	  ;; need to set args and request data
	  ;; later since they need substitutions
	  args url-request-data )
    (progn
      (setq args '(("method" . "zemanta.suggest")
		   ("api_key" . "")
		   ("text" . "")
		   ("format"."json")
		   ))
      (setcdr (assoc "text" args) (buffer-string)))
      (setcdr (assoc "api_key" args) zemanta-api-key)

      (setq url-request-data
	  (mapconcat (lambda (arg)
		       (concat (url-hexify-string (car arg))
			       "="
			       (url-hexify-string (cdr arg))))
		     args
		     "&"))
      (url-retrieve url 'zemanta-get-tags-callback)))



(defun zemanta-get-tags-callback (status)
  "extracts the keywords and places them in a tag field in the jekyll post"
  (progn
    (let ((json-object-type 'plist) jsondata)
      (progn
	;; find the start of the json and encode it into jdsondata
	(search-forward "{")
	(forward-char -1)
	(setq jsondata (json-read))
	;; convert the plist into a list of keywords
	(setq words (plist-get jsondata ':keywords))
	(setq words (mapcar (lambda (x) (elt x 1)) words))

	;; get to the post buffer
	;; this is a kludge and I should figure out how it works
	(kill-buffer (current-buffer))
	(switch-to-buffer (current-buffer))
	(switch-to-buffer (other-buffer))

	;; find the second --- line marking the bottom of data
	(goto-char 1)
	(search-forward "---")
	(search-forward "---")
	(beginning-of-line)
	;; add the tags
	(insert "tags: ")
	(insert (mapconcat 'identity words " "))
	(insert "\n")
	))))




