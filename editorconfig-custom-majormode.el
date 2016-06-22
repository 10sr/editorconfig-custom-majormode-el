;;; editorconfig-custom-majormode.el --- Decide major-mode from EditorConfig

;; Author: 10sr <8slashes+el [at] gmail [dot] com>
;; URL: https://github.com/10sr/editorconfig-custom-major-mode-el
;; Version: 0.0.1
;; Package-Requires: ((editorconfig "0.6.0"))
;; Keywords: editorconfig util

;; This file is not part of GNU Emacs.

;; Copyright (C) 2015 by 10sr <8slashes+el [at] gmail [dot] com>
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.


;;; Commentary:

;; An EditorConfig extension that defines a property to specify which
;; Emacs major-mode to use for files.

;; To enable this plugin, add `editorconfig-custom-majormode' to
;; `editorconfig-custom-hooks':

;; (add-hook 'editorconfig-custom-hooks
;;           'editorconfig-custom-majormode)

;;; Code:

;;;###autoload
(defun editorconfig-custom-majormode (hash)
  "Get emacs_mode property from HASH and set major mode.

If `package' is installed on your Emacs and the major mode specified is
installable, this plugin asks whether you want to install and enable it
automatically."
  (let* ((mode-str (gethash 'emacs_mode
                            hash))
         (mode (and mode-str
                    (not (string= mode-str
                                  ""))
                    (intern (concat mode-str
                                    "-mode")))))
    (when (and mode
               (not (eq mode
                        major-mode)))
      (if (fboundp mode)
          (funcall mode)
        (if (and (eval-and-compile (require 'package nil t))
                 (assq mode
                       package-archive-contents)
                 (yes-or-no-p (format "Major-mode `%S' not found but available as a package. Install?"
                                      mode)))
            (progn
              (package-install mode)
              (require mode)
              (funcall mode))
          (display-warning :error (format "Major-mode `%S' not found"
                                          mode)))))))

(provide 'editorconfig-custom-majormode)

;;; editorconfig-custom-majormode.el ends here
