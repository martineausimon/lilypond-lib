include-fonts = #(define-scheme-function ()()
   (let ((version (ly:version)))
      (if (equal? version '(2 25 4))
        (ly:parser-include-string 
          (format #f "\\include \"~A\"\n" "fonts-dev.ily"))
        (ly:parser-include-string 
          (format #f "\\include \"~A\"\n" "fonts.ily")))))

\include-fonts
\include "./layout.ily"
\include "./stylesheet.ily"
\include "./tools.ily"
\include "./chords.ily"
