\layout {
  \set Staff.explicitClefVisibility         = #end-of-line-invisible
  \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
  \set Staff.ottavationMarkups              = #ottavation-simple-ordinals
  \set Staff.fingeringOrientations          = #'(left)
  \override Staff.KeyCancellation.break-visibility  = #all-invisible
  \override Staff.StringNumber.script-priority      = 1000
  \override Staff.StringNumber.staff-padding        = #0.5
  \override Staff.Fingering.staff-padding           = #0.5
  \override Score.TimeSignature.break-visibility    = #'#(#f #t #t)
  \override Score.RehearsalMark.self-alignment-X    = #-1
  \override Score.RehearsalMark.padding             = #3.5
  \override Score.MetronomeMark.padding             = #2.5
  \override Score.RehearsalMark.break-align-symbols = #'(left-edge)
  \override Score.VoltaBracketSpanner.padding       = #2
  \override Score.TimeSignature.style               = #'numbered
}
