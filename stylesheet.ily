\paper {
  bottom-margin = 10\mm
  indent        = 0\cm
  line-width    = 175\mm
  ragged-right  = ##f
  tagline       = ##f
  last-bottom-spacing.basic-distance   = #15
  top-system-spacing.basic-distance    = #20
  system-system-spacing.basic-distance = #20
  markup-system-spacing.basic-distance = #40
  top-markup-spacing.basic-distance    = #10
  score-system-spacing.basic-distance  = #30
  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 3.5)
    \sans \column {
      \fill-line { \fromproperty #'header:dedication }
      \override #'(baseline-skip . 3.5)
      \column {
        \fill-line { 
          \fontsize #10
          \fromproperty #'header:title }
        \fill-line { \large \fromproperty #'header:subtitle }
        \fill-line {
          \raise #1 \smaller
          \fromproperty #'header:subsubtitle
        }
        \fill-line {
          \fromproperty #'header:poet
          { \large \bold \fromproperty #'header:instrument }
          \fromproperty #'header:composer
        }
        \fill-line {
          \fromproperty #'header:meter
          \fromproperty #'header:arranger
        }
      }
    }
  }
  scoreTitleMarkup = \markup {
    \column {
      \if \should-print-all-headers { \bookTitleMarkup \hspace #1 }
      \sans \fill-line \fontsize #6 {
        \fromproperty #'header:piece
        \fromproperty #'header:opus
      }
    }
  }
}
