#(ly:font-config-add-directory "./fonts/")

#(define my-staff-height #f)

\paper {
  #(set! my-staff-height staff-height)
}

$(if (ly:version? >= '(2 25 4))
     #{
       \paper {
         property-defaults.fonts.sans = "FuturaPT"
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
  \override TextSpanner.font-name             = #'"FuturaPTBookItalic"
  \override TextSpanner.font-size             = #-1
  \override DynamicTextSpanner.font-name      = #'"FuturaPTBookItalic"
  \override DynamicTextSpanner.font-size      = #-1
  \override TextScript.font-family            = #'sans
  \override LyricText.font-family             = #'sans
  \override Score.BarNumber.font-family       = #'sans
  \override Score.JumpScript.font-name        = #'"FuturaPTBookItalic"
  \override Score.VoltaBracket.font-name      = #'"FuturaPTdemi"
  \override Score.MetronomeMark.font-name     = #'"FuturaPTdemi"
  \override Score.RehearsalMark.font-name     = #'"FuturaPTdemi"
  \override Score.TextMark.font-family        = #'sans
  \override Score.CodaMark.font-size          = #4
  \override Score.SegnoMark.font-size         = #4
  \override Score.SectionLabel.font-family    = #'sans
  \override Score.VoltaBracket.font-size      = #-1
  \override Staff.StringNumber.font-name      = #'"FuturaPTdemi"
  \override Staff.Fingering.font-name         = #'"FuturaPTdemi"
  \override Staff.OttavaBracket.font-name     = #'"FuturaPTBookItalic"
  \override Staff.OttavaBracket.font-size     = #-2
  \override Staff.InstrumentName.font-family  = #'sans
}

\markup bold   = \markup \override #'(font-name . "FuturaPTDemi") \etc
\markup italic = \markup \override #'(font-name . "FuturaPTBookItalic") \etc
