#(define my-staff-height #f)

\paper {
  #(set! my-staff-height staff-height)
}

$(if (ly:version? >= '(2 25 4))
     #{
       \paper {
         fonts.sans = "Futura PT,Jost"
       }
     #}
     #{
       \paper {
         fonts = #(set-global-fonts
                   #:sans "Futura PT,Jost"
                   #:factor (/ my-staff-height (ly:pt 1) 20))
       }
     #})

\layout {
  \override HorizontalBracketText.font-family = #'sans
  \override TupletNumber.font-family          = #'sans
  \override Parentheses.font-size             = #0
  \override TextSpanner.font-name             = #'"Futura PT book italic,Jost Italic"
  \override TextSpanner.font-size             = #-1
  \override DynamicTextSpanner.font-name      = #'"Futura PT book italic,Jost Italic"
  \override DynamicTextSpanner.font-size      = #-1
  \override TextScript.font-family            = #'sans
  \override LyricText.font-family             = #'sans
  \override Score.BarNumber.font-family       = #'sans
  \override Score.JumpScript.font-name        = #'"Futura PT book italic,Jost Italic"
  \override Score.VoltaBracket.font-name      = #'"Futura PT demi,Jost SemiBold"
  \override Score.MetronomeMark.font-name     = #'"Futura PT demi,Jost SemiBold"
  \override Score.RehearsalMark.font-name     = #'"Futura PT demi,Jost SemiBold"
  \override Score.TextMark.font-family        = #'sans
  \override Score.CodaMark.font-size          = #4
  \override Score.SegnoMark.font-size         = #4
  \override Score.SectionLabel.font-family    = #'sans
  \override Score.VoltaBracket.font-size      = #-1
  \override Staff.StringNumber.font-name      = #'"Futura PT demi,Jost SemiBold"
  \override Staff.Fingering.font-name         = #'"Futura PT demi,Jost SemiBold"
  \override Staff.OttavaBracket.font-name     = #'"Futura PT book italic,Jost SemiBold Italic"
  \override Staff.OttavaBracket.font-size     = #-2
  \override Staff.InstrumentName.font-family  = #'sans
}

\markup bold   = \markup \override #'(font-name . "Futura PT Demi,Jost SemiBold") \etc
\markup italic = \markup \override #'(font-name . "Futura PT book italic,Jost Italic") \etc
