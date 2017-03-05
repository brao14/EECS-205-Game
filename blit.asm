; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc




.DATA
	;; If you need to, you can place global variables here

.CODE

DrawPixel PROC USES edx ecx x:DWORD, y:DWORD, color:DWORD
	cmp x, 0	;check the bounds of the screen
	jl done
	cmp x, 640
	jge done
	cmp y, 0
	jl done
	cmp y, 480
	jge done
	
	mov ecx, color		
	mov eax, y		;calculate the place to put the color
	mov edx, 640		;by 640*y + x and take cl which is the byte of color in ecx
	mul edx
	add eax, x
	add eax, ScreenBitsPtr
	mov BYTE PTR[eax], cl;
done:
	ret 			; Don't delete this line!!!
DrawPixel ENDP



BasicBlit PROC USES ecx ebx edx edi  ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
	LOCAL i:DWORD, tcolor:BYTE, x0:DWORD, x1:DWORD, y0:DWORD, y1:DWORD
	
	mov ecx, ptrBitmap  	;ecx store the address of start of bitmap
	mov i, 0
	mov bl, (EECS205BITMAP PTR [ecx]).bTransparent
	mov tcolor, bl		;store the transparent color in tcolor
	mov ebx, xcenter
	mov x0, ebx		;store xcenter in x0
	mov x1, ebx		;same for x1
	mov ebx, (EECS205BITMAP PTR[ecx]).dwWidth
	sar ebx, 1  		;divide width by 2
	sub x0, ebx		;subtract xcenter by half width, get x starting point in x0
	add x1, ebx		;add xcenter by half width, get x end point, store in x1
	mov ebx, ycenter	;same for y
	mov y0, ebx
	mov y1, ebx
	mov ebx, (EECS205BITMAP PTR [ecx]).dwHeight
	sar ebx, 1
	sub y0, ebx
	add y1, ebx


loop_x:

	mov ebx, x1
	cmp x0, ebx		;check if x0 < x1
	jge loop_y		;if x0 >= x1, update y
	mov ebx, (EECS205BITMAP PTR [ecx]).lpBytes
	mov edi, i
	mov dl, BYTE PTR [ebx + edi]
	mov al, tcolor
	cmp dl, al		;compare the color to transparent color
	je BREAK_loop		;if equal, break, else, invoke
	invoke DrawPixel, x0, y0, [ebx + edi]

BREAK_loop:
	inc i;
	inc x0			;increment x0, jmp back to loop_x for next column
	jmp loop_x	
	
loop_y:
	inc y0
	mov ebx, y0
	cmp ebx, y1
	jge DONE		;if y0 >= y1, the loop is finished
	mov ebx, (EECS205BITMAP PTR [ecx]).dwWidth	
	sub x0, ebx		;else, reset x0 and start the loop_x for this new y0
	jmp loop_x

DONE:	 
	ret 			; Don't delete this line!!!	
BasicBlit ENDP


RotateBlit PROC USES ecx edx ebx esi edi  lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
	LOCAL xInput:DWORD, yInput:DWORD, tcolor:BYTE,shiftX:DWORD, shiftY:DWORD, dstWidth:DWORD, dstHeight:DWORD, dstX:DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD, i:DWORD
	
	
	mov i, 0
	invoke FixedCos, angle
	mov ecx, eax			;ecx stores cos angle
	invoke FixedSin, angle	
	mov edi, eax			;edi stores sin angle
	
	mov esi, lpBmp
	mov bl, (EECS205BITMAP PTR [esi]).bTransparent
	mov tcolor, bl		;store the transparent color in tcolor

	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	imul ecx
	mov shiftX, eax
	sar shiftX, 1			;dwWidth*cosa/2
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	imul edi
	sar eax, 1			;dwHeight*sina /2
	sub shiftX, eax			;set shiftX
	
	;same thing for shiftY
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	imul ecx
	mov shiftY, eax
	sar shiftY, 1
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	imul edi
	sar eax, 1
	add shiftY, eax 
		
								
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	add eax, (EECS205BITMAP PTR [esi]).dwHeight
	mov dstWidth, eax		;set dstWidth and dstHeight
	mov dstHeight, eax
	
	neg eax
	mov dstX, eax		;dstX = -dstWidth
	mov dstY, eax		;dstY = -dstHeight
	
	sar shiftY, 16		;convert shiftY and shiftX to integer
	sar shiftX, 16

	jmp EVAL_X
loop_y:	
	mov eax, dstX	
	imul ecx
	mov srcX, eax
	mov eax, dstY
	imul edi
	add srcX, eax		;srcX = dstX*cosa + dstY*sina
	
	mov eax, dstY
	imul ecx
	mov srcY, eax
	mov eax, dstX
	imul edi
	sub srcY, eax		;srcY = dstY*cosa - dstX*sina
	
	sar srcX, 16		;convert srcX, srcY to integer
	sar srcY, 16
	
	cmp srcX, 0		;srcX >= 0
	jl INCRE_Y
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	cmp srcX, eax		;srcX < dwWidth
	jge INCRE_Y
	
	cmp srcY, 0		;srcY >= 0	
	jl INCRE_Y
	
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	cmp srcY, eax		;srcY < dwHeight
	jge INCRE_Y

	mov eax, xcenter
	add eax, dstX
	sub eax, shiftX
	cmp eax, 0
	jl INCRE_Y		;(xcenter+dstX-shiftX) >=0
	
	mov eax, xcenter
	add eax, dstX
	sub eax, shiftX
	cmp eax, 639
	jge INCRE_Y		;(xcenter+dstX-shiftX) < 639

	mov eax, ycenter
	add eax, dstY
	sub eax, shiftY
	cmp eax, 0
	jl INCRE_Y		;(ycenter+dstY-shiftY) >=0

	mov eax, ycenter
	add eax, dstY
	sub eax, shiftY
	cmp eax, 479
	jge INCRE_Y		;(ycenter+dstY-shiftY) < 479

	mov eax, (EECS205BITMAP PTR [esi]).dwWidth	;get the color at srcX, srcY
	mov edx, srcY					;by dwWidth*y + x
	imul edx
	add eax, srcX
	add eax, (EECS205BITMAP PTR [esi]).lpBytes
	mov dl, BYTE PTR [eax]
	cmp dl, tcolor					;cmp the color with transparent
	je INCRE_Y
	
	mov ebx, xcenter				;calculate the paramenters for draw
	add ebx, dstX
	sub ebx, shiftX
	mov xInput, ebx
	mov ebx, ycenter
	add ebx, dstY
	sub ebx, shiftY
	mov yInput, ebx
	invoke DrawPixel, xInput, yInput, BYTE PTR [eax]
INCRE_Y:
	inc dstY

EVAL_Y:
	mov eax, dstY
	cmp eax, dstHeight
	jl loop_y
	inc dstX

EVAL_X:


        mov eax, dstHeight
	neg eax
        mov dstY, eax	
	mov eax, dstX
	cmp eax, dstWidth
	jl EVAL_Y

	ret 			; Don't delete this line!!!		
RotateBlit ENDP

END
