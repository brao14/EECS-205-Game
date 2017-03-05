; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC USES edx ecx angle:FXPT
	local neg_angle:DWORD
;;	jmp done
	mov neg_angle, 0;

	mov edx, angle   	;use edx to store the angle

	cmp edx, 0
	je less_PI_HALF
	
inc_neg:
	cmp edx, 0
	jge dec_pos
	add edx, TWO_PI
	jmp inc_neg

dec_pos:			;here, the value is >= 0
	cmp edx, TWO_PI
	jl less_TWO_PI		
	sub edx, TWO_PI 
	jmp dec_pos
	
less_TWO_PI:			;here, 0 < value <= 2pi
	cmp edx, PI
	jl less_PI
	sub edx, PI
	xor neg_angle, 1
	jmp less_TWO_PI

	
less_PI:			;here, 0 < value < PI
	cmp edx, PI_HALF
	je equal_PI_HALF
	cmp edx, PI_HALF
	jl less_PI_HALF
	mov ecx, PI
	sub ecx, edx
	mov edx, ecx
	jmp less_PI

equal_PI_HALF:
	mov eax, 1
	shl eax, 16
	ret

less_PI_HALF:			;here, 0 < value < PI/2
	
	mov eax, edx
	mov edx, PI_INC_RECIP
	imul edx
	
	movzx eax, WORD PTR[SINTAB + edx*2]
	
	cmp neg_angle, 0
	je done
	neg eax
done:	
	ret			; Don't delete this line!!!
FixedSin ENDP 
	
FixedCos PROC USES edx angle:FXPT
	mov edx, angle		;simply use formula + pi/2 and call sin 
	add edx, PI_HALF
	invoke FixedSin, edx
	ret			; Don't delete this line!!!	
FixedCos ENDP	
END
