
(require 'json) ;; needed to process the results from zemanta


(defcustom zemanta-api-key "zjllw8mgsmh7dxonivzedyis"
  "Zemanta api key"
  :type '(string)'
  :group 'zemanta)



(defun zemanta-get (links)
  "If no prefex argument, use zemanta to get tags and either add them to the
tags: frontmatter or make a new tags: frontmatter line. With a prefix argument, add the related links to the bottom of the document"
  (interactive "p")
  (let* ( (url  "http://api.zemanta.com/services/rest/0.0/")
	  (url-request-method "POST")
	  ;; need to set args and request data
	  ;; later since they need substitutions
	  args url-request-data callback)
    (progn
      (if (> links 1)
	  (setq callback 'zemanta-get-links-callback)
	(setq callback 'zemanta-get-tags-callback))
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
      (print callback)
      (url-retrieve url callback)))






(defun zemanta-get-tags-callback (status)
  "extracts the keywords and places them in a tag field in the jekyll post"
  (progn
    (let ((json-object-type 'plist) jsondata words)
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
	(if (search-forward "tags:" nil t) 
	    (progn 
	      (end-of-line)
	      (insert " "))
	  (progn
	    (search-forward "---")
	    (beginning-of-line)
	    (insert "tags: ")
	    ))
	  ;; add the tags
	  (insert (mapconcat 'identity words " "))
	  (insert "\n")
	  ))))




(defun zemanta-get-links-callback (status)
  "extracts the keywords and places them in a tag field in the jekyll post"
  (progn
    (let ((json-object-type 'plist) jsondata articles titleurls)
      (progn
	;; find the start of the json and encode it into jdsondata
	(search-forward "{")
	(forward-char -1)
	(setq jsondata (json-read))
	;; convert the plist into a list of keywords
	(setq articles (plist-get jsondata ':articles))
	;;(setq titles (mapcar (lambda (x) (plist-get x ':title)) articles))
	(setq titleurls (mapcar (lambda (x) 
			       (cons (plist-get x ':title) (plist-get x ':url))) articles))
	;; get to the post buffer
	;; this is a kludge and I should figure out how it works
	(kill-buffer (current-buffer))
	(switch-to-buffer (current-buffer))
	(switch-to-buffer (other-buffer))

	(end-of-buffer)
	(insert "\n")
	(insert (mapconcat (lambda (x) 
			     (format "[%s](%s)" (car x) (cdr x))) titleurls "\n"))
))))
