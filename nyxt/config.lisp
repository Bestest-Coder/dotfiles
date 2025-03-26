(in-package #:nyxt-user)

(defvar *bestest-keymap* (make-keymap "bestest-map"))

(define-key *bestest-keymap*
            "J" 'switch-buffer-previous
            "K" 'switch-buffer-next
            "C-o" 'make-buffer-with-context)
            ;"C-S-1" ('make-buffer-with-context "school"))

(define-mode bestest-mode
             nil
             "dummy mode for the custom keybindings in *bestest-keymap*"
             ((keyscheme-map
                (nkeymaps/core:make-keyscheme-map nyxt/keyscheme:vi-normal
                                                  *bestest-keymap*))))

(define-configuration modable-buffer
                      ((prompt-on-mode-toggle-p T)))

(define-configuration web-buffer
    ((default-modes (append '(bestest-mode) '(vi-normal-mode) %slot-default%))))

(define-generic format-status-tabs
    ((status status-buffer))
  "Render the open buffers to HTML string suitable for STATUS.
Augment this with style of STATUS, if necessary."
  (let* ((buffers
          (remove nil
                  (if (display-tabs-by-last-access-p status)
                      (nyxt::sort-by-time (buffer-list)) ; not recognized
                      (reverse (buffer-list)))))
         (domain-deduplicated-urls
          (remove-duplicates (mapcar #'url buffers) :test #'string=
                             :key #'quri.domain:uri-domain)))
    (spinneret:with-html-string
      (loop for url in domain-deduplicated-urls
            collect (let* ((internal-buffers
                            (remove-if-not #'internal-url-p buffers
                                           :key #'url))
                           (domain (quri.domain:uri-domain url))
                           (tab-display-text
                            (if (internal-url-p url)
                                "internal"
                                domain))
                           (url url)
                           (current (current-buffer (window status))))
                      (:span :class
                       (if (and current ; determines span class based on this procedure
                                (string=
                                 (quri.domain:uri-domain
                                  (url current))
                                 (quri.domain:uri-domain url)))
                           "selected-tab tab"
                           "tab")
                       :onclick
                       (parenscript:ps
                         (if (or
                              (=
                               (parenscript:chain window event which)
                               2)
                              (=
                               (parenscript:chain window event which)
                               4))
                             (nyxt/parenscript:lisp-eval
                              (:title "delete-tab-group" :buffer
                               status)
                              (let ((buffers-to-delete
                                     (if (internal-url-p url)
                                         internal-buffers
                                         (serapeum:filter
                                          (match-domain domain)
                                          buffers))))
                                (prompt :prompt "Delete buffer(s)"
                                        :sources
                                        (make-instance 'buffer-source
                                                       :constructor
                                                       buffers-to-delete
                                                       :marks
                                                       buffers-to-delete
                                                       :actions-on-return
                                                       (list
                                                        (lambda-mapped-command
                                                         buffer-delete))))))
                             (nyxt/parenscript:lisp-eval
                              (:title "select-tab-group" :buffer
                               status)
                              (if (internal-url-p url)
                                  (prompt :prompt
                                          "Switch to buffer with internal page"
                                          :sources
                                          (make-instance
                                           'buffer-source
                                           :constructor
                                           internal-buffers))
                                  (nyxt::switch-buffer-or-query-domain ; not recognized
                                   domain)))))
                       ;(let ((buffer-context (slot-value (serapeum:filter
                       ;                                    (match-url url)
                       ;                                    buffers) 'context-name)))
                       ;  (cond
                       ;    ((string= buffer-context "school") (:style (:raw "background-color:rgb(255, 137, 0);")))))
                       tab-display-text))))))
