#lang scribble/manual
@require[@for-label[yacp
                    racket/base]]

@title{YACP: Yet Another C-Preprocessor}
@author{Yi Cao}

@defmodule[yacp]

YACC, interpreted as "Yet Another C-Preprocessor" or "YACP Ain't C-Plusplus",
is a Racket library / command-line tool / Racket-based DSL (if you'd like to
think so, and might be in the future) that aims to provide the most simple,
performant, and flexible language by evaluating stuff to C, which is a
well-designed *middle-level* language.
