(defun circuit-1s-complement (in &optional base)
  "return 1's complement to list
BASE should be 2 or 8 or 10 or 16"
  )

(defun circuit-make-binary (&optional bits)
  "make BITS binary in a list, return a list
each item represent bit
if BITS is null, default bits is 8"
  (make-list (or bits 8) 0)
)

;; fixme : variable parameters
(defun circuit-logic-and (a b)
  "logical and
parameter a, b should be a list represent a bits"
  
  )

(defun circuit-logic-nand ()
  "logical !and"
  )

(defun circuit-logic-or ()
  "logical or"
  )

(defun circuit-logic-nor ()
  "logical !or"
  )

(defun circuit-logic-xnor ()
  "logical !xor"
  )

(defun circuit-logic-not ()
  "logical not"
  )
