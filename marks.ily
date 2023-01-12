circleMark =
#(define-scheme-function (a)
     (markup?)
   #{ 
   \sectionLabel \markup { 
   \circle \pad-around #.8
   \bold #a } 
   #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boxMark = 
#(define-scheme-function (a)
     (markup?)
   #{ 
   \sectionLabel \markup { 
   \rounded-box \pad-around #.2
   \sans #a } 
   #})
