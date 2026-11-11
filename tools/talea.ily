#(define (duration-from-symbol x)
   (cond
     ((and (number? x) (inexact? x))
      (let ((n (inexact->exact x)))
        (ly:make-duration
          (cond
            ((= n 1) 0)
            ((= n 2) 1)
            ((= n 4) 2)
            ((= n 8) 3)
            ((= n 16) 4)
            (else
              (ly:error "Durée inconnue: ~a" x)))
          1)))

     ((number? x)
      (ly:make-duration
        (cond
          ((= x 1) 0)
          ((= x 2) 1)
          ((= x 4) 2)
          ((= x 8) 3)
          ((= x 16) 4)
          (else
            (ly:error "Durée inconnue: ~a" x)))
        0))

     ((symbol? x)
      (let* ((s (symbol->string x))
             (dot? (string-suffix? "." s))
             (n (string->number
                  (if dot?
                    (substring s 0 (- (string-length s) 1))
                    s))))
        (ly:make-duration
          (cond
            ((= n 1) 0)
            ((= n 2) 1)
            ((= n 4) 2)
            ((= n 8) 3)
            ((= n 16) 4)
            (else
              (ly:error "Durée inconnue: ~a" x)))
          (if dot? 1 0))))

     (else
       (ly:error "Format de durée inconnu: ~a" x))))


#(define (set-note-duration note duration)
   (let ((copy (ly:music-deep-copy note)))
     (ly:music-set-property!
       copy
       'duration
       (duration-from-symbol duration))
     copy))


#(define (is-rhythmic-event? m)
   (let ((name (ly:music-property m 'name)))
     (or (eq? name 'NoteEvent)
         (eq? name 'RestEvent)
         (eq? name 'SkipEvent))))


#(define (set-event-duration event duration)
   (let ((copy (ly:music-deep-copy event)))
     (ly:music-set-property!
       copy
       'duration
       (duration-from-symbol duration))
     copy))


#(define (apply-pattern-to-music music rhythm)
   (let ((elements (ly:music-property music 'elements)))
     (let loop ((items elements)
                (r rhythm)
                (result '()))
       (if (null? items)
         (make-sequential-music (reverse result))

         (let ((item (car items)))
           (if (is-rhythmic-event? item)

             (loop
               (cdr items)
               (if (null? (cdr r))
                 rhythm
                 (cdr r))
               (cons
                 (set-event-duration item (car r))
                 result))

             (loop
               (cdr items)
               r
               (cons item result))))))))


talea =
#(define-music-function
   (parser location rhythm music)
   (list? ly:music?)
   (apply-pattern-to-music music rhythm))
