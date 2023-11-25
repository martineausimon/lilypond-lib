#(define my-staff-height #f)

\paper {
  #(set! my-staff-height staff-height)
}

$(if (ly:version? >= '(2 25 4))
     #{
       \paper {
         property-defaults.fonts.sans = "Futura PT"
       }
     #}
     #{
       \paper {
         fonts = #(set-global-fonts
                   #:sans "Futura PT"
                   #:factor (/ my-staff-height (ly:pt 1) 20))
       }
     #})

\layout {
  \override HorizontalBracketText.font-family = #'sans
  \override TupletNumber.font-family          = #'sans
  \override Parentheses.font-size             = #0
  \override TextSpanner.font-name             = #'"Futura PT book italic"
  \override TextSpanner.font-size             = #-1
  \override DynamicTextSpanner.font-name      = #'"Futura PT book italic"
  \override DynamicTextSpanner.font-size      = #-1
  \override TextScript.font-family            = #'sans
  \override LyricText.font-family             = #'sans
  \override Score.BarNumber.font-family       = #'sans
  \override Score.JumpScript.font-name        = #'"Futura PT book italic"
  \override Score.VoltaBracket.font-name      = #'"Futura PT demi"
  \override Score.MetronomeMark.font-name     = #'"Futura PT demi"
  \override Score.RehearsalMark.font-name     = #'"Futura PT demi"
  \override Score.TextMark.font-family        = #'sans
  \override Score.CodaMark.font-size          = #4
  \override Score.SegnoMark.font-size         = #4
  \override Score.SectionLabel.font-family    = #'sans
  \override Score.VoltaBracket.font-size      = #-1
  \override Staff.StringNumber.font-name      = #'"Futura PT demi"
  \override Staff.Fingering.font-name         = #'"Futura PT demi"
  \override Staff.OttavaBracket.font-name     = #'"Futura PT book italic"
  \override Staff.OttavaBracket.font-size     = #-2
  \override Staff.InstrumentName.font-family  = #'sans
}

\markup bold   = \markup \override #'(font-name . "Futura PT Demi") \etc
\markup italic = \markup \override #'(font-name . "Futura PT book italic") \etc
