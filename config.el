;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Srinidhi P V"
      user-mail-address "srinidhi.812@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-outrun-electric)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Notes/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Display battery stats on modeline
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))

;; Display time on modeline
(display-time-mode 2)

;; BEGIN: Org-roam configure
(setq org-roam-directory '"~/Documents/Notes/")
(setq org-roam-capture-templates
      (quote (("d" "default" plain (function org-roam--capture-get-point)
               "%?"
               :file-name "%<%Y-%m-%H%M>${slug}"
               :head "#+TITLE: ${title}\n"
               :unarrowed t
               ))))
(org-roam-db-autosync-mode)

;; END: Org-roam configure

;; BEGIN: Bibtex in Org configure
;; Configure org-ref and helm-bibtex
(after! helm
  (use-package! helm-bibtex
    :custom
    ;; Configure default library for helm-bibtex
    (bibtex-completion-bibliography '("~/Documents/Notes/BibTex/default.bib"))
    (reftex-default-bibliography '("~/Documents/Notes/BibTex/default.bib"))
    ;; Not sure of this configuration)
    (bibtex-completion-pdf-field "field"))
  ;; This key-map is done to access the bibiliography from anaywhere in emacs
  (map! :leader
        :desc "Open literature database"\
        "o l" #'helm-bibtex)
;; Configure org-ref (not sure why we need this or why not use biblio)
(use-package! org-ref
  :custom
  ;; Configure defaults
  (org-ref-default-bibliography "~/Documents/Notes/BibTex/default.bib")
  (org-ref-defualt-citation-link "citep"))

;; A bit more of configuration to get org-ref and helm-bibtex to work together
(setq org-ref-completion-library 'org-ref-helm-cite
      org-export-latex-format-toc-function 'org-export-latex-no-toc
      ;; For pdf export engines
      org-latex-pdf-process (list "latexmk -pdflatex='%latex -shell-escape -interaction nonstopmode' -pdf -bibtex -f -output-directory=%0 %f")
      ;; Some configuration on orb which I don't quite get. Will add later
      )

;; There is some more custom functions related to org-ref that allows to open the file/pdf
;; in the citation. But I don't download things from arxiv much. Maybe I'll write my own
;; custom function to open using url in bibtex entry

;; The keybinding below is just to get the helm-meu to behave according evil-mode
;; defaults
  (map! :map  helm-map
        "C-j" #'helm-next-line
        "C-k" #'helm-previous-line))

;; TODO: Read Helm-bibtex documentation and clean up the configuration a bit
;; TODO: Read org-ref documentation and clean up the configuration even more
;; TODO: Add util functions to view web versions of the resources I add in bib files in emacs itself
;;
;; END: BibTex in Org configure

;; BEGIN: View pdfs in emacs configure
;; Configuration to use pdf-tools instead of doc viewer
(use-package! pdf-tools
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-width)
  :custom
  (pdf-annot-minor-mode t))


;; END: View pdfs in emacs configure
