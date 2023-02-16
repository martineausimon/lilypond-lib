\paper {
  #(define fonts
    (set-global-fonts
      #:sans "Futura PT,Jost"
      #:factor (/ staff-height pt 20)
    )) 
}

\layout {
  \override HorizontalBracketText.font-family = #'sans
  \override TupletNumber.font-family          = #'sans
  \override Parentheses.font-size             = #0
  \override TextSpanner.font-name             = #'"Futura PT book italic,Jost Italic"
  \override TextSpanner.font-size             = #-1
  \override TextScript.font-family            = #'sans
  \override LyricText.font-family             = #'sans
  \override Score.BarNumber.font-family       = #'sans
  \override Score.JumpScript.font-name        = #'"Futura PT book italic,Jost Italic"
  \override Score.VoltaBracket.font-name      = #'"Futura PT demi,Jost SemiBold"
  \override Score.MetronomeMark.font-name     = #'"Futura PT demi,Jost SemiBold"
  \override Score.SectionLabel.font-family    = #'sans
  \override Score.VoltaBracket.font-size      = #-1
  \override Staff.StringNumber.font-name      = #'"Futura PT demi,Jost SemiBold"
  \override Staff.Fingering.font-name         = #'"Futura PT demi,Jost SemiBold"
  \override Staff.OttavaBracket.font-name     = #'"Futura PT book italic,Jost SemiBold Italic"
  \override Staff.OttavaBracket.font-size     = #-2
}

\markup bold = \markup \override #'(font-name . "Futura PT Demi,Jost SemiBold") \etc
