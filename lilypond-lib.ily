$(if (ly:version? >= '(2 25 4))
     (ly:parser-include-string 
       (format #f "\\include \"~A\"\n" "fonts-dev.ily"))
     (ly:parser-include-string 
       (format #f "\\include \"~A\"\n" "fonts.ily")))

\include "./layout.ily"
\include "./stylesheet.ily"
\include "./tools.ily"
\include "./chords.ily"
