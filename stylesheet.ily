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
    \column {
      \fill-line { \fromproperty #'header:dedication }
      \override #'(baseline-skip . 3.5)
      \column {
        \fill-line {
          \fontsize #10 \sans
          \fromproperty #'header:title
        }
        \fill-line {
          \large \sans
          \fromproperty #'header:subtitle
        }
        \fill-line {
          \smaller \sans
          \fromproperty #'header:subsubtitle
        }
        \fill-line {
          \sans \fromproperty #'header:poet
          { 
            \bold \sans
            \large \fromproperty #'header:instrument 
          }
          \sans \fromproperty #'header:composer
        }
        \fill-line {
          \sans \fromproperty #'header:meter
          \sans \fromproperty #'header:arranger
        }
      }
    }
  }
}

xBook = 
#(define-void-function (key scores)
                       ((string? "") list?)
     (print-book-with-defaults
   #{ \book {
        #(if (not (string-null? key))
           #{ \bookOutputSuffix $key #}
           "")
        \paper {
          oddHeaderMarkup = \markup {
            \if \on-first-page {
            #(if (not (string-null? key))
               #{ \markup \circle \pad-around #2 \sans $key #}
               "")
            } 
            \unless \on-first-page-of-part {
              \sans \fromproperty #'header:title
              #(if (not (string-null? key))
                 #{ \markup \sans \concat { "[" $key "]"  } #}
                 "")
              \sans { "- p." \fromproperty #'page:page-number-string }
            }
          }
          evenHeaderMarkup = \markup {
            \sans \fromproperty #'header:title
            #(if (not (string-null? key))
               #{ \markup \sans \concat { "[" $key "]"  } #}
               "")
            \sans { "- p." \fromproperty #'page:page-number-string }
          }
        }
        $@scores
      } 
   #}))
