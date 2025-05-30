#(define pi 3.141592653589793)
#(define circle-radius 0.8)
#(define dot-radius 0.065)

#(define (pitch-to-class p)
   (define pitch-name-to-semitone #(0 2 4 5 7 9 11))
   (modulo
    (+ (* 12 (ly:pitch-octave p))
       (vector-ref pitch-name-to-semitone (ly:pitch-notename p))
       (inexact->exact (round (* 2 (ly:pitch-alteration p)))))
    12))

#(define (index->pos i)
   (let* ((angle (/ (* 2 pi i) 12))
          (x (* circle-radius (sin angle)))
          (y (* circle-radius (cos angle))))
     (cons x y)))

#(define (interpolate-line start end steps dot-radius)
   (let* ((dx (- (car end) (car start)))
          (dy (- (cdr end) (cdr start))))
     (map (lambda (s)
            (let* ((t (/ s steps 1.0))
                   (x (+ (car start) (* t dx)))
                   (y (+ (cdr start) (* t dy))))
              (ly:stencil-translate
               (make-circle-stencil dot-radius 0 #t)
               (cons x y))))
          (iota (+ 1 steps) 0))))

#(define (draw-polygon points drawer)
   (apply ly:stencil-add
          (map (lambda (i)
                 (let* ((start (list-ref points i))
                        (end (list-ref points (modulo (+ i 1) (length points)))))
                   (drawer start end)))
               (iota (length points)))))

#(define (make-polygon-stencil points thickness style)
   (case style
     ((line)
      (draw-polygon
       points
       (lambda (start end)
         (make-line-stencil thickness
                            (car start) (cdr start)
                            (car end)   (cdr end)))))
     ((dotted)
      (draw-polygon
       points
       (lambda (start end)
         (let* ((dist (sqrt (+ (expt (- (car end) (car start)) 2)
                               (expt (- (cdr end) (cdr start)) 2))))
                (steps (inexact->exact (truncate (/ dist 0.09)))))
           (apply ly:stencil-add
                  (interpolate-line start end steps (* thickness 0.7)))))))
     (else (ly:make-stencil '()))))

#(define (notename->markup pitch)
   (let* ((alt (ly:pitch-alteration pitch))
          (name (make-simple-markup
                 (vector-ref #("C" "D" "E" "F" "G" "A" "B")
                             (ly:pitch-notename pitch)))))
     (make-concat-markup
      (list name
            (if (= alt 0)
                (markup "")
                (make-hspace-markup 0.015))
            (make-alteration-markup alt 0.1)))))

#(define (make-note-labels layout props pitch-name-mode pitch-fontsize played-indices pitch-list)
   (if (not pitch-name-mode)
       '()
       (map
        (lambda (i p)
          (let* ((angle (/ (* 2 pi i) 12))
                 (r (+ circle-radius 0.25))
                 (x (* r (sin angle)))
                 (y (* r (cos angle))))
            (ly:stencil-translate
             (interpret-markup layout props
                               (markup #:raise -0.077 #:center-align #:fontsize (- pitch-fontsize 20) #:sans (notename->markup p)))
             (cons x y))))
        played-indices pitch-list)))

#(define (make-dots-circle-with-labels layout props pitch-list polygon-style thickness dots-thickness pitch-name-mode pitch-fontsize)
   (define all-indices (iota 12))
   (define played-pairs (sort (map (lambda (p) (cons (pitch-to-class p) p)) pitch-list)
                             (lambda (a b) (< (car a) (car b)))))
   (define played-indices (map car played-pairs))
   (define played-pitches (map cdr played-pairs))
   (define played-points (map index->pos played-indices))

   (define (dot i)
     (let ((pos (index->pos i)))
       (ly:stencil-translate
        (if (member i played-indices)
            (make-circle-stencil dot-radius dots-thickness #t)
            (make-circle-stencil dot-radius dots-thickness #f))
        pos)))

   (ly:stencil-add
    (if (and (not (eq? polygon-style 'none)) (> (length played-points) 1))
        (make-polygon-stencil played-points thickness polygon-style)
        (ly:make-stencil '()))
    (apply ly:stencil-add (map dot all-indices))
    (apply ly:stencil-add
           (make-note-labels layout props pitch-name-mode pitch-fontsize played-indices played-pitches))))


#(define-markup-command (pitchPolygon layout props music)
   (ly:music?)
   #:properties
   ((size 4)
    (polygon-style 'line)
    (thickness 2)
    (polygon-thickness #f)
    (dots-thickness #f)
    (pitch-name #f)
    (pitch-fontsize 0))
   (let* ((poly-thick (or polygon-thickness thickness))
          (dots-thick (or dots-thickness (* thickness 0.5)))
          (notes (extract-named-music music 'NoteEvent))
          (pitches (map (lambda (n) (ly:music-property n 'pitch)) notes)))
     (ly:stencil-scale
      (make-dots-circle-with-labels
       layout
       props
       pitches
       polygon-style
       (* poly-thick 0.01)
       (* dots-thick 0.01)
       pitch-name
       pitch-fontsize)
      size size)))
