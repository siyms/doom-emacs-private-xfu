;;; lang/latex/+ref.el -*- lexical-binding: t; -*-

(use-package! reftex
  :hook (LaTeX-mode . reftex-mode)
  :config
  ;; set up completion for citations and references
  (set-company-backend! 'reftex-mode 'company-reftex-labels 'company-reftex-citations)
  ;; Get ReTeX working with biblatex
  ;; http://tex.stackexchange.com/questions/31966/setting-up-reftex-with-biblatex-citation-commands/31992#31992
  (setq reftex-cite-format
        '((?a . "\\autocite[]{%l}")
          (?b . "\\blockcquote[]{%l}{}")
          (?c . "\\cite[]{%l}")
          (?f . "\\footcite[]{%l}")
          (?n . "\\nocite{%l}")
          (?p . "\\parencite[]{%l}")
          (?s . "\\smartcite[]{%l}")
          (?t . "\\textcite[]{%l}"))
        reftex-plug-into-AUCTeX t
        reftex-toc-split-windows-fraction 0.3)
  (when +latex-bibtex-file
    (setq reftex-default-bibliography (list (expand-file-name +latex-bibtex-file))))
  (map! :map reftex-mode-map
        :localleader :n ";" 'reftex-toc)
  (after! reftex-toc
    (set-popup-rule! "\\*toc\\*" :size 80 :side 'left :transient nil :select t :quit nil)
    (advice-add 'reftex-toc :override #'+latex*reftex-toc)

    (add-hook! 'reftex-toc-mode-hook
      (reftex-toc-rescan)))
  ;; (add-hook! 'reftex-toc-mode-hook
  ;;   (reftex-toc-rescan)
  ;;   (map! :local
  ;;         :e "j"   #'next-line
  ;;         :e "k"   #'previous-line
  ;;         :e "q"   #'kill-buffer-and-window
  ;;         :e "ESC" #'kill-buffer-and-window))
  )

;; set up mode for bib files
(after! bibtex
  (setq bibtex-dialect 'biblatex
        bibtex-align-at-equal-sign t
        bibtex-text-indentation 20)
  (define-key bibtex-mode-map (kbd "C-c \\") #'bibtex-fill-entry))

(after! bibtex-completion
  (when +latex-bibtex-file
    (setq bibtex-completion-bibliography (list (expand-file-name +latex-bibtex-file)))))
