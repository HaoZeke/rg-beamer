;;; rg-beamer.el --- Load the rg Beamer theme from this checkout -*- lexical-binding: t; -*-

;; Puts theme/ on TEXINPUTS and registers an org-latex class so
;; #+LaTeX_CLASS: rg-beamer works from ox-beamer.

;;; Commentary:

;; In Doom, from config.org:
;;
;;   (load! (expand-file-name "Git/Github/TeX/rg-beamer/emacs/rg-beamer.el" (getenv "HOME")))
;;
;; The yasnippet in emacs/org-beamer-rg is a sibling of
;; orgBeamerMetropolis. Copy or symlink it into
;; ~/.config/doom/snippets/org-mode/.

;;; Code:

(defgroup rg-beamer nil
  "HaoZeke Beamer theme helpers."
  :group 'org-export)

(defconst rg-beamer-root
  (file-name-directory (directory-file-name (file-name-directory load-file-name)))
  "Checkout root that contains theme/.")

(defun rg-beamer--theme-dir ()
  (expand-file-name "theme" rg-beamer-root))

(defun rg-beamer-setup-texinputs ()
  "Prepend the theme directory to TEXINPUTS for tectonic and xelatex."
  (let* ((dir (file-name-as-directory (rg-beamer--theme-dir)))
         (cur (or (getenv "TEXINPUTS") "")))
    (unless (string-match-p (regexp-quote dir) cur)
      (setenv "TEXINPUTS" (concat dir ":" cur)))))

(defun rg-beamer-register-org-class ()
  "Add `rg-beamer' and `rg-report' to `org-latex-classes'."
  (require 'ox-latex)
  (unless (assoc "rg-beamer" org-latex-classes)
    (add-to-list 'org-latex-classes
                 '("rg-beamer"
                   "\\documentclass[aspectratio=169,11pt]{beamer}\n\\usetheme{rg}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
  (unless (assoc "rg-report" org-latex-classes)
    (add-to-list 'org-latex-classes
                 '("rg-report"
                   "\\documentclass[12pt,a4paper,oneside,headinclude]{scrartcl}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))))

(rg-beamer-setup-texinputs)
(with-eval-after-load 'ox-latex
  (rg-beamer-register-org-class))
(with-eval-after-load 'ox-beamer
  (rg-beamer-register-org-class))

(provide 'rg-beamer)
;;; rg-beamer.el ends here
