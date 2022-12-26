# lilypond-lib

This is my personal framework for LilyPond scores. It's a WIP, and I regularly make additions or modifications.

## Installation

Clone this repository, e.g. in `$HOME` folder :

```bash
cd $HOME
git clone https://github.com/martineausimon/lilypond-lib
```

Add `lilypond-lib/` dir to [LilyPond include path](https://lilypond.org/doc/v2.24/Documentation/notation/including-lilypond-files), then use :

```lilypond
\version "2.24.0"
\include "lilypond-lib.ily"
```

## Stylesheet & fonts

This framework is based on the "Futura PT" font, which is not open source. That's why this repository contains the "Jost" font, an open source alternative ([OFL](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)) that is very similar as a fallback font if you can't use Futura PT.

Adapt and add this lines to `~/.config/fontconfig/conf.d/10-lilypond-fonts.conf` to install Jost fonts :

```xml
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <dir>~/path/to/lilypond-lib/fonts/</dir>
</fontconfig>
```

Then run `fc-cache -f`

## Tools

### `\marquage`

Insert a non-transposable rythm section with `Pitch_squash_engraver` :

```lilypond
\relative c' {
  r8 f r f aes aes f c 
  ees4 f \marquage { b4. b8 }
  r8 f r f aes4 bes
}
```

### `\kick`

Insert a non-transposable `\xNote` :

```lilypond
music = \relative c' {
  \partial 8 f8
  bes bes aes bes aes aes f aes
  f4 r8 \kick b r2
}

\score { \transpose c d \music }
```

### `\xSpan`

Quickly add a test spanner with or without text :

```lilypond
\relative c' {
  a8 b c d \xSpan "Rit" { a b c d }
}
```

### `\crochet`

Add a simple analysis bracket with text :

```lilypond
\relative c' {
  \crochet "Phrase A" { a8 b c d }
  \crochet "Phrase B" { d c b a }
}
```

### `\naturalizeMusic`

see [LilyPond manual](https://lilypond.org/doc/v2.21/Documentation/notation/changing-multiple-pitches.fr.html) :

```lilypond
music = \relative c' { c4 d e g }

\score {
  \new Staff {
    \transpose c ais { \music }
    \naturalizeMusic \transpose c ais { \music }
    \transpose c deses { \music }
    \naturalizeMusic \transpose c deses { \music }
  }
  \layout { }
}
```

### "barre" tools

Add barre indication for fretted strings instruments

* `\singleB ["partial num" (optional)] [fret num]` : barre for single note/chord
* `\xBarre ["partial num" (optional)] [fret num] { ... }` : barre for a music section
* `... \startB ["partial num" (optional)] [fret num] ... \stopB` : barre delimiters for more complex situations


```lilypond
\relative c'' {
  % Single note/chord barre, partial barre :
  <bes d g>1 \singleB "3" 3
  % Same, complete barre
  <g, d' g bes d g> \singleB 3

  \xBarre 3 { g16 d' g bes d g8. } 
  % equivalent to
  g,,16 \startB 3 d' g bes d g8. \stopB

  \xBarre "3" 3 { g8 d bes4 }
  % Or
  \tuplet 3/2 { fis'4 g8 \startB "3" 3 } d8 bes \stopB
}
```
