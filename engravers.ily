\layout {
  \context {
    \Score
    \remove Metronome_mark_engraver
  }
  \context {
    \Staff
    \consists Metronome_mark_engraver
  }
  \context {
    \Voice
    \consists Horizontal_bracket_engraver
  }
}

