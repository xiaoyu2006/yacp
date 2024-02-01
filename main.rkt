#lang racket/base

(module+ test
  (require rackunit))

(define yacp-version "0.0")

(define lg (make-logger 'cli))
(current-logger lg)

(require "yacp.rkt")
(require racket/string)
(require racket/format)
(define yacp-eval  ;; TODO: Figure out how to embed module in the executable AND make-evaluator
  (lambda (sexpr)
    (eval sexpr (namespace-anchor->namespace yacp-ns))))
(define (eval-and-emit sexpr-list)
  ;; Evaluate every s-expression and concate them to a string if it's an instance of csrc
  (string-join (filter csrc? (map (compose1 ~a yacp-eval) sexpr-list))
               "\n"
               #:after-last "\n"))

(module+ test
  (check-equal? (eval-and-emit '((csrc "xyz") 1)) "xyz\n"))

(module+ main
  (require racket/cmdline)
  (require racket/logging)
  (define output-file (make-parameter #f))
  (define log-level (make-parameter 'info))

  (define (read-all in-port)
    (let loop ([sexpr (read in-port)])
      (if (eof-object? sexpr)
          '()
          (cons sexpr (loop (read in-port))))))

  (command-line
   #:program "yacp"
   #:once-each
   [("-o" "--output") output-param
                      "Which file to write to (defaults to stdout)"
                      (output-file output-param)]
   [("-l" "--logging-level") log-level-param
                             "Set logging level"
                             (log-level log-level-param)]
   [("-v" "--version") "Print version and exit" (begin (displayln (format "yacp ~a" yacp-version))
                                                       (exit))]
   #:args (filename)
   (with-logging-to-port (current-error-port)
     (lambda ()
       (define in-port (open-input-file filename))
       (define out-port
         (if (output-file)
             (open-output-file (output-file) #:exists 'replace)
             (current-output-port)))
       (define sexpr-list (read-all in-port))
       (log-debug "Read s-expressions: ~a" sexpr-list)
       (define result (eval-and-emit sexpr-list))
       (log-debug "Result: ~a" result)
       (display result out-port))
     (string->symbol (log-level)))))
