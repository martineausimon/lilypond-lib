hiFl   = \markup { \hspace #.1 \raise #.4 \fontsize #-1.2 \flat }
hiSh   = \markup { \hspace #.1 \raise #.6 \fontsize #-1.2 \sharp }
delta  = \markup { #whiteTriangleMarkup }
xSlash = \markup { \override #'(font-name . "LilyPond Sans Serif") "/" }
sN     = \markup { "6" \xSlash "9" }

chExceptionMusic = {
  <c f g a bes>         -\markup { \super "7sus4(add6)" }
  <c ees ges bes>       -\markup { \super \fontsize #1.5 "ø" }
  <c ees ges>           -\markup { \super \fontsize #1.5 "o" }
  <c ees ges beses>     -\markup { \super { \fontsize #1.5 "o" "7" } }
  <c ees g a d'>        -\markup { "m" \super { \sN } }
  <c ees g bes d' a'>   -\markup { "m" \super "7(9,13)" }
  <c e f g a>           -\markup { \super "6(add4)" }
  <c e f g b >          -\markup { \super { \delta "(add4)" } }
  <c e f g bes>         -\markup { \super "7(add4)" }
  <c e f g bes d'>      -\markup { \super "9(add4)" }
  <c e f g bes a'>      -\markup { \super "13(add4)" }
  <c e g a d'>          -\markup { \super \sN }
  <c e g a d' fis'>     -\markup { \super { \sN "(" \hiSh "11)" } }
  <c e g bes des' aes'> -\markup { \super "7(alt)" }
  <c e g bes des'>      -\markup { \super { "7(" \hiFl "9)" } }
  <c e g bes des' a'>   -\markup { \super { "7(" \hiFl "9,13)" } }
  <c e g bes dis' a'>   -\markup { \super { "7(" \hiSh "9,13)" } }
  <c e g bes d'>        -\markup { \super "7(9)" }
  <c e g bes d' a'>     -\markup { \super "7(9,13)" }
  <c e g bes d' aes'>   -\markup { \super { "7(9," \hiFl "13)" } }
  <c e g bes a'>        -\markup { \super "7(13)" }
  <c e g bes aes'>      -\markup { \super { "7(" \hiFl "13)" } }
  <c e g b fis'>        -\markup { \super { \delta \hiSh 11 } }
}

chExceptions = 
  #(append
    (sequential-music-to-chord-exceptions chExceptionMusic #t)
    ignatzekExceptions)

#(define (chordNamer pitch majmin)
  (let* ((alt (ly:pitch-alteration pitch)))
    (make-line-markup
    (list
      (make-simple-markup 
        (vector-ref #("C" "D" "E" "F" "G" "A" "B")
          (ly:pitch-notename pitch)))
      (if (= alt 0)
        (markup "")
      (if (= alt FLAT)
        (make-line-markup
          (list
            (make-fontsize-markup -3
              (make-raise-markup 0.50
                (make-flat-markup)))))
      (if (= alt DOUBLE-SHARP)
        (make-line-markup
          (list
            (make-fontsize-markup -3
              (make-raise-markup 0.40
                (make-doublesharp-markup)))))
      (if (= alt DOUBLE-FLAT)
        (make-line-markup
          (list
            (make-fontsize-markup -3
              (make-raise-markup 0.50
                (make-doubleflat-markup)))))
      (make-line-markup
        (list
          (make-fontsize-markup -3
            (make-raise-markup 1
              (make-sharp-markup)))))))))))))

\layout {
  \set slashChordSeparator = \xSlash
  \override VerticalAxisGroup.nonstaff-relatedstaff-spacing = #'(
    (basic-distance . 1)
    (padding . 1))
  \set chordNameExceptions = #chExceptions
  \set chordRootNamer      = #chordNamer
  \set chordNoteNamer      = #chordNamer
  \set chordNameSeparator  = #(make-hspace-markup 0)
}
