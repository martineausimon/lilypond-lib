#(define (duration-from-symbol x)
   (define (dur n dots)
     (ly:make-duration
      (inexact->exact (/ (log n) (log 2)))
      dots))
   (cond
    ((and (number? x) (inexact? x))
     (dur (inexact->exact x) 1))
    ((number? x)
     (dur x 0))
    ((symbol? x)
     (let* ((s (symbol->string x))
            (dot? (string-suffix? "." s))
            (n (string->number
                (if dot?
                    (substring s 0 (- (string-length s) 1))
                    s))))
       (dur n (if dot? 1 0))))))

#(define (is-rhythmic-event? m)
   (memq (ly:music-property m 'name)
         '(NoteEvent RestEvent SkipEvent)))

#(define (apply-pattern-to-music music rhythm)
   (let ((i 0)
         (n (length rhythm)))
     (music-map
      (lambda (m)
        (if (is-rhythmic-event? m)
            (begin
              (ly:music-set-property!
               m 'duration
               (duration-from-symbol
                (list-ref rhythm (modulo i n))))
              (set! i (+ i 1))))
        m)
      (ly:music-deep-copy music))))

talea =
#(define-music-function
   (parser location rhythm music)
   (list? ly:music?)
   (apply-pattern-to-music music rhythm))
