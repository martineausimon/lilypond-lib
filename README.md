# lilypond-lib

This is my personal framework for LilyPond scores. It's a WIP, and I regularly make additions or modifications.

<details>
<summary>SCORE EXAMPLES</summary>

<p align="center">
<img src="https://user-images.githubusercontent.com/89019438/261419196-7d16ba7e-72ea-4166-b730-11a1fd034b5e.jpg">
</p>

<p align="center">
<img src="https://user-images.githubusercontent.com/89019438/281694651-a93fc2ec-3b5f-4c0e-bc94-b27b10d0e367.jpg">
</p>

<p align="center">
<img src="https://user-images.githubusercontent.com/89019438/261419623-82890fde-b574-4395-a620-02b0591f90a9.jpg">
</p>
</details>

## Installation

Clone this repository :

```bash
git clone https://github.com/martineausimon/lilypond-lib
```

Add `lilypond-lib/` dir to [LilyPond include path](https://lilypond.org/doc/v2.24/Documentation/notation/including-lilypond-files) then use :

```lilypond
\version "2.24.2"
\include "lilypond-lib.ily"
%\include "stylesheet-alt.ly" %% Alternative stylesheet
```

## Stylesheet & fonts

This framework is based on [Futura PT](https://fonts.adobe.com/fonts/futura-pt) font.

All fonts are included in the repository, and loaded with `#(ly:font-config-add-directory "./fonts/")`

## Tools

### `\marquage`

Insert a non-transposable rythm section with `Pitch_squash_engraver` :

![](https://github.com/user-attachments/assets/cafb8ff8-16a5-4884-9901-576029c5ae06)

```lilypond
\relative c' {
  r8 f r f aes aes f c 
  ees4 f \marquage { b4. b8 }
  r8 f r f aes4 bes
}
```

### `\beat`

Insert beats for rhythm section :

![](https://github.com/user-attachments/assets/1e8f2652-6c5e-49a0-92b5-91939e96568d)

```lilypond
<<
  \chords {
    d2:m7 ees:7 aes:maj7 b:7 e:maj7 g:7 c1:maj7
  }
  {
    \beat 16
  }
>>
```

### `\kick`

Insert a non-transposable `\xNote` :

![](https://github.com/user-attachments/assets/932357ed-74a3-43e8-86fe-6edea1c56c71)

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

![](https://github.com/user-attachments/assets/f5159532-0ee0-4ff0-9114-07b0e16e4109)

```lilypond
\relative c' {
  a8 b c d \xSpan "Rit" { a b c d }
}
```

### `\crochet`

Add a simple analysis bracket with text :

![](https://github.com/user-attachments/assets/051d8a29-69ea-4627-84ed-60071eb86ded)

```lilypond
\relative c' {
  \crochet "Phrase A" { a8 b c d }
  \crochet "Phrase B" { d c b a }
}
```

### `\naturalizeMusic`

see [LilyPond manual](https://lilypond.org/doc/v2.21/Documentation/notation/changing-multiple-pitches.fr.html) :

![](https://github.com/user-attachments/assets/c5226e25-1955-417f-b4cf-dd642373dfb7)

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

### Parenthesis tool

Add several notes/chords between parenthesis, with a size (optional)  
`\openParen [size num (optional)] [fist note] ... \closeParen [size num (optional)] [last note]`

![](https://github.com/martineausimon/lilypond-lib/assets/89019438/e7acc600-ede4-4f84-b5a2-0f429f0a9ecb)

```lilypond
\relative c' {
  \openParen a b c \closeParen d
}
```

### `\xBook` tool

Use this function instead of `\book` to compile pdf with personalized odd and even headers. This function takes a string for argument, which will be used for `\bookOutputSuffix` and printed in `oddHeaderMarkup` and `evenHeaderMarkup`. The second argument must be a sheme list containing scores. Useful for transposed music :

![](https://github.com/martineausimon/lilypond-lib/assets/89019438/4fca5f26-40c2-429a-8b25-a5be6dad4f66)

```lilypond
\version "2.25.9"
\include "lilypond-lib.ily"

\header {
  title       = "TITLE"
  subtitle    = "Subtitle"
  subsubtitle = "subsubtitle"
  composer    = "Composer"
}

music = \relative c'' {
  \repeat unfold 20 {
    c1 d e f \break
  }  
}

musicBb = \transpose c d \music

\xBook ""   #(list #{ \music #})
\xBook "Bb" #(list #{ \musicBb #})
```


