(setq rijks-result-data "")

; https://stackoverflow.com/questions/11912027/emacs-lisp-search-anything-in-a-nested-list
(require 'cl)

(defun rijks-tree-assoc (key tree)
  (when (consp tree)
    (destructuring-bind (x . y)  tree
      (if (eql x key) tree
        (or (rijks-tree-assoc key x) (rijks-tree-assoc key y))))))

; TODO: Actually pick a random painting
(defun rijks-random-painting ()
  "SK-C-5")

(defun rijks-request-image ()
  (setq img-url (concat "https://www.rijksmuseum.nl/api/nl/collection/" (rijks-random-painting) "?key=" rijks-key))
  (request
    img-url
    :parser 'json-read
    :success (cl-function
              (lambda (&key data &allow-other-keys)
		(when data
		  (setq rijks-result-data data))))))

(defun rijks-get-time-str ()
  (mapconcat 'identity (mapcar 'number-to-string (current-time)) ""))

(defun rijks-get-img-url ()
  (setq url-cell (rijks-tree-assoc 'url rijks-result-data))
  (setq url (cdr url-cell))
  url)

(defun rijks-download-image (img-url)
  (setq output-name (concat "/tmp/" (rijks-get-time-str) ".jpg"))
  (call-process-shell-command (concat "curl -o " output-name " " img-url) nil t)
  (call-process-shell-command (concat "convert -resize 10% " output-name " " output-name) nil t)
  output-name)

(defun rijks-display-random-image ()
  "Display a random work of art from the Rijks Museum"
  (interactive)
  (rijks-request-image)
  (setq img-url (rijks-get-img-url))
  (setq file-path (rijks-download-image img-url))
  (find-file file-path))
