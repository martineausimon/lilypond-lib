marquage = 
#(define-music-function (mus)
     (ly:music?)
   #{
   \new Voice \with { \consists Pitch_squash_engraver } 
   { \improvisationOn $mus \improvisationOff } #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kick = \withMusicProperty untransposable ##t \xNote \etc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xSpan =
#(define-music-function (txt mus)
     ((string? "") ly:music?)
   #{ #(if (not (string-null? txt))
     #{ 
     \once \override TextSpanner.bound-details.left.text = \markup { 
       $txt \hspace #0.3 
     }
     #})
   \once \override TextSpanner.style = #'dashed-line
   \once \override TextSpanner.dash-fraction = #0.3
   \once \override TextSpanner.dash-period = #1
   \once \override TextSpanner.staff-padding = #3
   \once \override TextSpanner.direction = #DOWN
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
   (if (not (string-null? partial)) 
   #{
      \tweak bound-details.left.text
        \markup 
          \fontsize #-1 \normal-text \bold \concat { 
          #(format #f "~@r" fretnum)
             \lower #.3 \fontsize #-4.2 #partial
             \hspace #.1 }
      \tweak style #'line
      \tweak thickness #1.2
      \tweak bound-details.left.stencil-align-dir-y #0
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
   #}
    #{
      \tweak bound-details.left.text
        \markup 
          \fontsize #-1 \normal-text \bold \concat { 
          #(format #f "~@r" fretnum)
          \hspace #.1
        }
      \tweak style #'line
      \tweak thickness #1.2
      \tweak bound-details.left.stencil-align-dir-y #-0.25
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
   #})
)

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

#(define (naturalize-pitch p)
  (let ((o (ly:pitch-octave p))
    (a (* 4 (ly:pitch-alteration p)))
    ;; alteration, a, in quarter tone steps,
    ;; for historical reasons
    (n (ly:pitch-notename p)))
  (cond
    ((and (> a 1) (or (eqv? n 6) (eqv? n 2)))
      (set! a (- a 2))
      (set! n (+ n 1)))
    ((and (< a -1) (or (eqv? n 0) (eqv? n 3)))
      (set! a (+ a 2))
      (set! n (- n 1))))
  (cond
    ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
    ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
  (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
  (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
  (ly:make-pitch o n (/ a 4))))

#(define (naturalize music)
 (let ((es (ly:music-property music 'elements))
    (e (ly:music-property music 'element))
    (p (ly:music-property music 'pitch)))
  (if (pair? es)
    (ly:music-set-property!
      music 'elements
      (map naturalize es)))
  (if (ly:music? e)
    (ly:music-set-property!
      music 'element
      (naturalize e)))
  (if (ly:pitch? p)
    (begin
      (set! p (naturalize-pitch p))
      (ly:music-set-property! music 'pitch p)))
  music))

naturalizeMusic =
#(define-music-function (mus)
  (ly:music?)
  (naturalize mus))

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
