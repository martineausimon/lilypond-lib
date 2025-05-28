\include "./tools/naturalizeMusic.ily"
\include "./tools/pitchPolygon.ily"

marquage = 
#(define-music-function (mus)
   (ly:music?)
   #{
     \new Voice \with { \consists Pitch_squash_engraver }
     { \improvisationOn $mus \improvisationOff } #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hidePitches =
#(define-music-function (position mus)
   ((number? 7) ly:music?)
   #{
     \new Voice \with {
       \consists Pitch_squash_engraver
       \override NoteHead.no-ledgers = ##t
       squashedPosition = #position
       #(if (< position 0)
            #{ \stemDown #}
            #{ \stemUp #})
       \hide Voice.NoteHead
       \hide Voice.Accidental
     }
     $mus
   #}
   )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rhythmMarks =
#(define-music-function (position rhythms)
   ((number? 7) ly:music?)
   #{
     \new Voice \with {
       \consists Pitch_squash_engraver
       \improvisationOn
       \override MultiMeasureRest.staff-position = #position
       \override Rest.staff-position = #position
       \override NoteHead.no-ledgers = ##t
       fontSize = -3
       squashedPosition = #position
       #(if (< position 0)
            #{ \stemDown #}
            #{ \stemUp #})
     \voiceOne
     }
     $rhythms
   #}
   )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

beat = 
#(define-music-function (beats)
   (number?)
   #{
     \new Voice \with { \consists Pitch_squash_engraver } 
     { \improvisationOn \repeat unfold $beats { \once \omit Voice.Stem c4 } \improvisationOff } #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kick = 
#(define-music-function (mus)
   (ly:music?)
   #{
     \once \omit Accidental \withMusicProperty untransposable ##t \xNote $mus
   #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\layout {
  \context {
    \Voice
    \consists Horizontal_bracket_engraver
  }
}

xSpan =
#(define-music-function (txt mus)
   ((string? "") ly:music?)
   #{ #(if (not (string-null? txt))
           #{ 
             \once \override TextSpanner.bound-details.left.text = \markup { 
               $txt \hspace #0.3 
             }
           #})
      <>\startTextSpan $mus \stopTextSpan #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

singleB =
#(define-music-function (partial fretnum)
   ((string? "") number?)
   #{ 
     ^\markup {
       \hspace #.5 \center-align \fontsize #-2 \concat { 
         \bold { 
           $(format #f "~@r" fretnum) 
           #(if (not (string-null? partial))
                #{ \markup \lower #.3 \fontsize #-4.2 #partial #})
         } 
         "¬" 
       } 
     } 
   #})

startB = 
#(define-event-function (partial fretnum) 
   ((string? "") number? )
   (let ((barre-event
          #{
            \tweak style #'line
            \tweak thickness #1.2
            \tweak bound-details.left.padding 0
            \tweak bound-details.left.attach-dir -1
            \tweak bound-details.left-broken.text ##f
            \tweak bound-details.left-broken.attach-dir -1
            \tweak bound-details.right.padding 0
            \tweak bound-details.right.attach-dir 1
            \tweak bound-details.right-broken.text ##f
            \tweak bound-details.right.text
            \markup
            \with-dimensions #'(0 . 0) #'(-.3 . 0) 
            \draw-line #'(0 . -0.4)
            \startTextSpan 
          #})) 
     (if (string-null? partial)
         #{
           \tweak bound-details.left.text
           \markup 
           \fontsize #-1 \normal-text \bold \concat { 
             #(format #f "~@r" fretnum)
             \hspace #.1
           }
           \tweak bound-details.left.stencil-align-dir-y #-0.25
           #barre-event
         #}
         #{
           \tweak bound-details.left.text
           \markup 
           \fontsize #-1 \normal-text \bold \concat { 
             #(format #f "~@r" fretnum)
             \lower #.3 \fontsize #-4.2 #partial
             \hspace #.1 }
           \tweak bound-details.left.stencil-align-dir-y #0
           #barre-event
         #})))

stopB = \stopTextSpan

xBarre =
#(define-music-function (fing str mus) 
   ((string? "") number? ly:music?)
   #{ <>\startB $fing $str $mus \stopB #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

crochet =
#(define-music-function (txt mus)
   ((string? "") ly:music?)
   #{ #(if (not (string-null? txt))
           #{ \once \override HorizontalBracketText.text = $txt #})
      <>\startGroup $mus \stopGroup #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
          \sans { 
            \if \on-first-page {
              #(if (not (string-null? key))
                   #{ \markup \circle \pad-around #2 $key #} "")
            } 
            \unless \on-first-page-of-part {
              \fromproperty #'header:title
              #(if (not (string-null? key))
                   #{ \markup \concat { "[" $key "]"  } #}
                   "")
              "- p." \fromproperty #'page:page-number-string
            }
          }
        }
        evenHeaderMarkup = \markup {
          \sans {
            \fromproperty #'header:title
            #(if (not (string-null? key))
                 #{ \markup \concat { "[" $key "]"  } #}
                 "")
            "- p." \fromproperty #'page:page-number-string
          }
        }
      }
      $@scores
       } 
    #}))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define ((paren-stencil start) grob) 
   (let* ((par-list (parentheses-interface::calc-parenthesis-stencils grob)) 
          (null-par (grob-interpret-markup grob (markup #:null)))) 
     (if start 
         (list (car par-list) null-par) 
         (list null-par (cadr par-list))))) 

openParen = 
#(define-music-function (parser location size note) 
   ((number? #f) ly:music?) 
   #{ 
     \once \override Parentheses.font-size = #size
     \once \override Parentheses.stencils = #(paren-stencil #t) 
     \parenthesize #note 
   #}) 

closeParen = 
#(define-music-function (parser location size note) 
   ((number? #f) ly:music?) 
   #{ 
     \once \override Parentheses.font-size = #size
     \once \override Parentheses.stencils = #(paren-stencil #f) 
     \parenthesize #note 
   #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#(define (custom-line-breaks-engraver bar-list)
   (let* ((working-copy bar-list)
          (total (1+ (car working-copy))))
     (lambda (context)
       (make-engraver
        (acknowledgers ((paper-column-interface engraver grob
                                                source-engraver)
                        (let ((internal-bar (ly:context-property context
                                                                 'internalBarNumber)))
                          (if (and (pair? working-copy)
                                   (= (remainder internal-bar total) 0)
                                   (eq? #t (ly:grob-property grob 'non-musical)))
                              (begin
                               (set! (ly:grob-property grob 'line-break-permission)
                                     'force)
                               (if (null? (cdr working-copy))
                                   (set! working-copy bar-list)
                                   (begin
                                    (set! working-copy (cdr working-copy))))
                               (set! total (+ total (car working-copy))))))))))))

