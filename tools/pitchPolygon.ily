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

#(define (make-dotted-polygon points dot-radius spacing)
  (apply ly:stencil-add
    (apply append
      (map (lambda (i)
             (let* ((start (list-ref points i))
                    (end   (list-ref points (modulo (+ i 1) (length points))))
                    (dist  (sqrt (+ (expt (- (car end) (car start)) 2)
                                    (expt (- (cdr end) (cdr start)) 2))))
                    (steps (if (> spacing 0)
                               (inexact->exact (truncate (/ dist spacing)))
                               0)))
               (interpolate-line start end steps dot-radius)))
           (iota (length points))))))

#(define (make-polygon-stencil points thickness style)
  (case style
    ((line)
     (apply ly:stencil-add
       (map (lambda (i)
              (let* ((start (list-ref points i))
                     (end   (list-ref points (modulo (+ i 1) (length points)))))
                (make-line-stencil thickness
                                   (car start) (cdr start)
                                   (car end)   (cdr end))))
            (iota (length points)))))
    ((dotted)
     (make-dotted-polygon points (* thickness 0.7) 0.09))
    (else (ly:make-stencil '()))))

#(define (make-dots-circle pitch-list polygon-style thickness dots-thickness)
  (define all-indices (iota 12))
  (define played-indices (sort (map pitch-to-class pitch-list) <))
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
    (apply ly:stencil-add (map dot all-indices))))

#(define-markup-command (pitchPolygon layout props music)
  (ly:music?)
  #:properties
  ((size 4)
   (polygon-style 'line)
   (thickness 2)
   (polygon-thickness #f)
   (dots-thickness #f))
  (let* ((poly-thick (or polygon-thickness thickness))
         (dots-thick (or dots-thickness (* thickness 0.5)))
         (notes (extract-named-music music 'NoteEvent))
         (pitches (map (lambda (n) (ly:music-property n 'pitch)) notes)))
    (ly:stencil-scale
      (make-dots-circle
        pitches
        polygon-style
        (* poly-thick 0.01)
        (* dots-thick 0.01))
      size size)))
