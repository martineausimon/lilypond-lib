#(define (make-stencil-rounded-boxer thickness padding radius)
   (grob-transformer
    'stencil
    (lambda (grob original)
      (rounded-box-stencil original thickness padding radius))))

\layout {
  \set Staff.explicitClefVisibility         = #end-of-line-invisible
  \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
  \set Staff.ottavationMarkups              = #ottavation-simple-ordinals
  \set Staff.fingeringOrientations          = #'(left)
  \set Staff.breathMarkType                 = #'outsidecomma
  \accidentalStyle Score.modern
  \override Staff.KeyCancellation.break-visibility    = #all-invisible
  \override Staff.StringNumber.outside-staff-priority = 0
  \override Staff.StringNumber.script-priority        = 1000
  \override Staff.StringNumber.staff-padding          = #0.5
  \override Staff.Fingering.staff-padding             = #0.5
  \override Score.MetronomeMark.padding               = #2.5
  \override Score.VoltaBracketSpanner.padding         = #2
  \override Score.JumpScript.padding                  = #1.5
  \override Score.SectionLabel.padding                = #2.5
  \override Score.CodaMark.padding                    = #1.5
  \override Score.SegnoMark.padding                   = #1.5
  \override Score.SectionLabel.stencil = #(make-stencil-rounded-boxer 0.1 0.6 1.0)
  \override Score.TimeSignature.break-visibility      = #'#(#f #t #t)
  \override Score.TimeSignature.style                 = #'numbered
  \override Score.RehearsalMark.stencil = #(make-stencil-circler 0.1 0.8 ly:text-interface::print)
  \override Score.RehearsalMark.break-align-symbols   = #'(left-edge)
  \override Score.RehearsalMark.padding               = #2.5
  \override Score.RehearsalMark.self-alignment-X      = #-1
}
