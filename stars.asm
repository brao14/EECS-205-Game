; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc

	;; draw 16 stars from upper left corner of the screen all the way down
	invoke DrawStar, 10, 10
	invoke DrawStar, 20, 20	
	invoke DrawStar, 30, 30
	invoke DrawStar, 40, 40
	invoke DrawStar, 50, 50	
	invoke DrawStar, 60, 60
	invoke DrawStar, 70, 70
	invoke DrawStar, 80, 80	
	invoke DrawStar, 90, 90
	invoke DrawStar, 100, 100
	invoke DrawStar, 110, 110	
	invoke DrawStar, 120, 120
	invoke DrawStar, 130, 130
	invoke DrawStar, 140, 140	
	invoke DrawStar, 150, 150
	invoke DrawStar, 160, 160
	ret  			; Careful! Don't remove this line
DrawStarField endp



END
