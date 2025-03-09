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
