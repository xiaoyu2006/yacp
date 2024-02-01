#lang racket/base

(define-namespace-anchor yacp-ns)
(provide yacp-ns)


;; Temp Solution
(provide (all-from-out racket/base))

;; TODO:
; ;; Stripped down Racket stuff
; (provide
;  ; Primitives
;  quote eq? car cdr cons lambda cond null
;  ; Other Stuff
;  struct define set! if begin)

(struct csrc (str)
  #:guard (lambda (x name)
            (unless (string? x)
              (error 'csrc "Expected a string"))
            x)
  #:transparent) ;; Wrapper for C source code
(define s~ csrc-str) ;; Shortcut for unwrapping csrc

(provide (struct-out csrc) s~)

;; TODO: Implement core C
;; TODO: Compile-time type infomation, etc.
;; TODO: Advanced middleware?
