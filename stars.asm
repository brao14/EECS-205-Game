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

DrawStarField proc USES ebx ecx

	;; draw 16 stars from upper left corner of the screen all the way down
	invoke DrawStar, 196, 43
	invoke DrawStar, 177, 17
	invoke DrawStar, 450, 323
	invoke DrawStar, 515, 337
	invoke DrawStar, 437, 286
	invoke DrawStar, 250, 31
	invoke DrawStar, 458, 422
	invoke DrawStar, 572, 87
	invoke DrawStar, 310, 444
	invoke DrawStar, 506, 278
	invoke DrawStar, 569, 292
	invoke DrawStar, 444, 325
	invoke DrawStar, 401, 442
	invoke DrawStar, 286, 203
	invoke DrawStar, 97, 50
	invoke DrawStar, 636, 37
	invoke DrawStar, 386, 150
	invoke DrawStar, 364, 380
	invoke DrawStar, 339, 88
	invoke DrawStar, 267, 233
	invoke DrawStar, 253, 321
	invoke DrawStar, 251, 176
	invoke DrawStar, 622, 55
	invoke DrawStar, 612, 85
	invoke DrawStar, 112, 246
	invoke DrawStar, 406, 130
	invoke DrawStar, 95, 32
	invoke DrawStar, 245, 429
	invoke DrawStar, 489, 82
	invoke DrawStar, 413, 328
	invoke DrawStar, 317, 84
	invoke DrawStar, 576, 48
	invoke DrawStar, 182, 418
	invoke DrawStar, 282, 151
	invoke DrawStar, 172, 256
	invoke DrawStar, 346, 5
	invoke DrawStar, 21, 407
	invoke DrawStar, 345, 293
	invoke DrawStar, 293, 320
	invoke DrawStar, 311, 119
	invoke DrawStar, 55, 126




	ret
DrawStarField endp



END
