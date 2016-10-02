;(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq inhibit-startub-screen t)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
   (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(load-theme 'tango-dark t)
(set-default-font "Monospace-12")

(setq-default tab-width 4)

;(define-abbrev-table 'global-abbrev-table 
;    '( ("8bulb" "💡") ("8ra" "→") ("8rt" "▶")))
;(setq-defaultabbrev-mode t)

(setq package-archives 
  '(("melpa" . "http://melpa.milkbox.net/packages/")
  ("marmalade" . "http://marmalade-repo.org/packages/")
  ("org" . "http://orgmode.org/elpa/")
  ("gnu" . "http://elpa.gnu.org/packages/")))


(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package evil
  :ensure t
  :config
  (setq evil-default-state 'emacs)
  (evil-mode)
  )

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (setq which-key-allow-evil-operators t)
  (setq which-key-show-operator-state-maps t)
  )

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

;;; org-mode  stuff

(defun rk-org-find-case ()
  (org-datetree-find-date-create (calendar-current-date))
  (goto-char (point-at-eol))
  (when (not (re-search-forward
               (format org-complex-heading-regexp-format
                       (regexp-quote "Cases")) nil t))
    (insert "\n**** Cases\n"))
  (goto-char (point-at-eol)))

(defun rk-org-find-task ()
  (org-datetree-find-date-create (calendar-current-date))
  (goto-char (point-at-eol))
  (when (not (re-search-forward
               (format org-complex-heading-regexp-format
                       (regexp-quote "Tasks")) nil t))
    (insert "\n**** Tasks\n"))
  (goto-char (point-at-eol)))

(use-package org
  :ensure org-plus-contrib
  :init
  (evil-define-key 'normal org-mod-map (kbd "g x") 'org-open-at-point)
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c b" . org-switchb))
  :config
    (use-package evil-org
       :ensure t)
    (use-package org-journal
       :ensure t
       :commands (org-journal-new-entry))
    (use-package org-bullets
       :ensure t
       :init
       (setq org-bullets-bullet-list 
             '( "●" "◉" "◎" "○" "◌" "◈" "◇" "◼" "◻" "▲" "△" "❀" "✿"
                "✸" "✚" "✜" "☯" "☢" "♠" "♣" "♦" "♥")))
    
    (setq org-directory (expand-file-name "~/org"))
    (setq org-agenda-files (list (concat org-directory "/agendas")))

	(setq org-todo-keywords 
          '((sequence "TODO(t)" "IN PROGRESS(p)" "⚑ WAITING(w)" "|" "✔ DONE(d)" "✘ CANCELED(c)" )))

    (setq org-capture-templates
     '(
         ("c" "Case" plain (file+function "~/org/worktodo2.org" rk-org-find-case)
            "***** TODO %^{CASE} %? 
:PROPERTIES:
:SCRUB: %^{SCRUB}
:BACK: %^{BACK}
:NURSE: %^{NURSE}
:ST:
:ET:
:END:")
         ("t" "Task" plain (file+function "~/org/worktodo2.org" rk-org-find-task)
            "***** TODO %? 
:PROPERTIES:
:ENTERED: %T
:FINISHED:
:END:")))
    
    (setq org-log-done t)

    (setq org-fontify-done-headline t)
    ;(set-face-attribute 'org-done nil :strike-through t)
    ;(set-face-attribute 'org-headline-done nil :strike-through t :foreground "gray")

    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1) (org-indent-mode t) (abbrev-mode 1)))
 )


;    (add-hook 'org-mode-hook 'turn-on-auto-fill)
  

