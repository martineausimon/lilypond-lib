\paper {
  markup-system-spacing.basic-distance = #25
  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 3.5)
    \sans \column {
      \fill-line { \fromproperty #'header:dedication }
      \override #'(baseline-skip . 3.5)
      \column {
        \fontsize #8 \fromproperty #'header:title 
        \large \fromproperty #'header:subtitle 
        \raise #1 \smaller \fromproperty #'header:subsubtitle 
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
}

#(define subtitle-no-year 
  (lambda (layout props str)
    (if (ly:version? >= '(2 25 4))
        (let ((pat (ly:make-regex " \\(\\d{4}\\)")))
          (ly:regex-replace pat str))
        str)))

xBook = 
#(define-void-function (key scores)
   ((string? "") list?)
   (print-book-with-defaults
    #{ \book {
      #(if (not (string-null? key))
           #{ \bookOutputSuffix $key #} "")
      \paper {
        oddHeaderMarkup = \markup {
          \sans {
            \if \on-first-page {
              #(if (not (string-null? key))
                   #{ \markup \fill-line { \null \circle \pad-around #2 $key } #} "")
            } 
            \unless \on-first-page-of-part {
              \fromproperty #'header:title "-" 
              \with-string-transformer $subtitle-no-year
              \fromproperty #'header:subtitle
              #(if (not (string-null? key))
                   #{ \markup \concat { "[" $key "]"  } #} "")
              "- p." \fromproperty #'page:page-number-string
            }
          }
        }
        evenHeaderMarkup = \markup {
          \sans { 
            \fromproperty #'header:title 
            "-"
            \with-string-transformer $subtitle-no-year
            \fromproperty #'header:subtitle
            #(if (not (string-null? key))
                 #{ \markup \concat { "[" $key "]"  } #} "")
            "- p." \fromproperty #'page:page-number-string
          }
        }
      }
      $@scores
     } 
  #}))
