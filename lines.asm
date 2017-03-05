; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;   Name: Qiang Bi   NetID: qbw653
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here

.CODE
	

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
DrawLine PROC USES ebx ecx edx edi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
        LOCAL delta_x:DWORD, delta_y:DWORD, inc_x:DWORD, inc_y:DWORD
	;; Place your code here
	;calculate abs(x1-x0)
	mov ebx, x1
	sub ebx, x0
	jge POS_X
	neg ebx
POS_X:  mov delta_x, ebx
	
	;same for abs(y1-y0)
	mov ebx, y1
	sub ebx, y0
	jge POS_Y
	neg ebx
POS_Y:  mov delta_y, ebx

	;check x0 < x1, assign inc_x
	mov ebx, x0
	cmp ebx, x1
	jl IF_X
	mov inc_x, -1
	jmp AWAY1
IF_X:   mov inc_x, 1
AWAY1:

	;y0 < y1  assign inc_y
	mov ebx, y0
	cmp ebx, y1
	jl IF_Y
	mov inc_y, -1
	jmp AWAY2
IF_Y:   mov inc_y, 1
AWAY2:
	
	;delta_X > delta_y assign error
	;use edx for error
	mov ebx, delta_x
	cmp ebx, delta_y
	jg IF_DELTA_X
	mov edx, delta_y
	shr edx, 1
	neg edx
	jmp AWAY3
IF_DELTA_X:
	mov edx, delta_x
	shr edx, 1
AWAY3:
	
	;use ebx and ecx for curr_x and curr_y
	mov ebx, x0
	mov ecx, y0

	invoke DrawPixel, ebx, ecx, color
	
	;while loop, use edi for prev_error
	jmp EVAL
DO:   
	invoke DrawPixel, ebx, ecx, color
	mov edi, edx
	
	;cmp prev_error and -delta_x
	neg delta_x
	cmp edi, delta_x
	jle AWAY4
	sub edx, delta_y
	add ebx, inc_x
AWAY4:	neg delta_x       ;restore delta_x

	;cmp prev_error and delta_y
	cmp edi, delta_y
	jge EVAL
	add edx, delta_x
	add ecx, inc_y

EVAL:   cmp ebx, x1
	jne DO
	cmp ecx, y1
	jne DO

RETURN:	ret        	;;  Don't delete this line...you need it
DrawLine ENDP




END
