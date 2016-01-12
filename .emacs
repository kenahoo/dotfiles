(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "dd4db38519d2ad7eb9e2f30bc03fba61a7af49a185edfd44e020aa5345e3dca7" default)))
 '(inhibit-startup-screen t)
 '(org-alphabetical-lists t)
 '(org-html-postamble t)
 '(org-html-postamble-format
   (quote
    (("en" "<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Date: %T</p>
"))))
 '(org-html-preamble-format (quote (("en" ""))))
 '(org-list-allow-alphabetical t)
 '(org-src-preserve-indentation t)
 '(show-paren-mode t)
 '(transient-mark-mode t)
 '(user-mail-address "kenahoo@gmail.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minibuffer-prompt ((t (:foreground "magenta")))))
 '(diff-added-face ((t (:foreground "green"))))
 '(diff-changed-face ((t (:foreground "blue" :slant italic :weight bold))))
 '(diff-removed-face ((t (:foreground "red"))))

(setq exec-path (append exec-path '("/usr/local/bin")))

(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 100))

;; Use cperl-mode instead of perl-mode, it's better.
(defalias 'perl-mode 'cperl-mode)

;;(add-hook 'before-save-hook 'delete-trailing-whitespace)

(savehist-mode 1)

(add-to-list 'vc-handled-backends 'Git)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org"   . "http://orgmode.org/elpa/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(if (display-graphic-p)
    (use-package zenburn-theme
      :ensure t))

(use-package markdown-mode
  :ensure t
  :mode ("\\.markdown$" "\\.md$"))

(use-package graphviz-dot-mode
  :mode "\\.dot$")

(use-package htmlize
  :ensure t)

(use-package php-mode
  :ensure t
  :mode ("\\.php\\'" "\\.inc\\'"))

(use-package ess-site
  :ensure ess
  :config
  (progn
    (ess-set-style 'GNU)))

(use-package yaml-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package org
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :config
  (progn
    (setq org-html-head
	   "<script type=\"text/javascript\" src=\"http://orgmode.org/org-info.js\"></script>
<style type=\"text/css\">
    <!--/*--><![CDATA[/*><!--*/
      pre.src          { background-color: #F0FFF0; }
      pre.src:before   { position: absolute; top: -15px; left: 10px; right: inherit; background: #ffffff; display: inline; }
      pre.example      { background-color: #FFF0F0; }
    /*]]>*/-->
</style>")

     (setq org-log-done 'time)
     (setq org-export-babel-evaluate nil)
     (setq org-confirm-babel-evaluate nil)
     (setq org-html-validation-link nil)

     (require 'ox-publish)
     (setq org-publish-project-alist
	   (append
	    )
	   )

     (setq org-latex-listings t)
     (add-to-list 'org-latex-packages-alist '("" "listings"))
     (add-to-list 'org-latex-packages-alist '("" "color"))
     (add-to-list 'org-latex-packages-alist '("" "tabularx"))
     (add-to-list 'org-latex-packages-alist '("" "tabu"))

     (setq org-src-fontify-natively t)
     (setq org-src-tab-acts-natively t)

     (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
	(sh . t)
	(plantuml . t)
	(R . t)
	(dot . t)
	(perl . t)))
     )
  )

(global-set-key (kbd "M--") 'ess-smart-underscore)
(global-set-key (kbd "C-/") 'comment-dwim)

(defun render-datadoc ()
  (interactive)
  (save-buffer)
  (shell-command (format "%s %s" "docs/data-build.sh" (buffer-file-name))))


(defun org-pubspec (name from to)
  "Create a spec for publishing an org-mode file to HTML"
  (list

   (list (concat name "-notes")
    :base-directory from
    :base-extension "org"
    :publishing-directory to
    :recursive nil
    :publishing-function 'org-publish-org-to-html
    :headline-levels 3
    :auto-preamble t
    )

   (list (concat name "-static")
    :base-directory from
    :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|svg\\|kml\\|html"
    :publishing-directory to
    :recursive nil
    :publishing-function 'org-publish-attachment
    )

   (list name
    :components (list (concat name "-notes") (concat name "-static")))
  )
)


(defun org-copy-outline-path-less-root-to-kill-ring (&optional a b)
  "Copy the current outline path, less the first node, to the kill ring, and echo to the echo area."
  (interactive "P")
  (let* ((bfn (buffer-file-name (buffer-base-buffer)))
	 (case-fold-search nil)
         (path (org-get-outline-path)))
    (setq path (append path
                       (save-excursion
                         (org-back-to-heading t)
                         (if (looking-at org-complex-heading-regexp)
                             (list (match-string 4))))))
    (let ((formatted-path (org-format-outline-path
                           path
                           (1- (frame-width)))))
      (kill-new formatted-path)
      (message "%s" formatted-path))))



;;; org-export-blocks-format-plantuml.el Export UML using plantuml
;;
;; Copy from org-export-blocks-format-ditaa
;;
;; E.g.
;; #+BEGIN_UML
;;   Alice -> Bob: Authentication Request
;;   Bob --> Alice: Authentication Response
;; #+END_UML

(eval-after-load "org-exp-blocks"
  '(progn
    (add-to-list 'org-export-blocks '(uml iy/org-export-blocks-format-plantuml nil))
    (add-to-list 'org-protecting-blocks "uml")))

(defvar org-plantuml-jar-path (expand-file-name "~/Downloads/plantuml.jar")
  "Path to the plantuml jar executable.")


;; See http://www.emacswiki.org/emacs/MoveLine
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
