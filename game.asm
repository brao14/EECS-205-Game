; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
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
include game.inc

include Z:\home\peter\wine-masm\drive_c\masm32\include\windows.inc 
include Z:\home\peter\wine-masm\drive_c\masm32\include\winmm.inc 
includelib Z:\home\peter\wine-masm\drive_c\masm32\lib\winmm.lib

include Z:\home\peter\wine-masm\drive_c\masm32\include\masm32.inc 
includelib Z:\home\peter\wine-masm\drive_c\masm32\lib\masm32.lib

include Z:\home\peter\wine-masm\drive_c\masm32\include\user32.inc 
includelib Z:\home\peter\wine-masm\drive_c\masm32\lib\user32.lib  

;; Has keycodes
include keys.inc



;_EECS205BITMAP STRUCT
; dwWidth      DWORD  ?
; dwHeight     DWORD  ?
; bTransparent BYTE   ?
;              BYTE   3 DUP(?)
; lpBytes      DWORD  ?
;_EECS205BITMAP ENDS

	
.DATA

gameoverWAV BYTE "game_over.wav",0
bombWAV BYTE "bomb_sound.wav",0
missleWAV BYTE "missle_launch.wav",0
thrusterWAV BYTE "rocket_thrusters.wav",0





rock0x DWORD ?
rock0y DWORD ?
rock0angle FXPT ?
rock0bitMap DWORD ?
rock0on DWORD ?

rock1x DWORD ?
rock1y DWORD ?
rock1angle FXPT ?
rock1bitMap DWORD ?
rock1on DWORD ?

rock2x DWORD ?
rock2y DWORD ?
rock2angle FXPT ?
rock2bitMap DWORD ?
rock2on DWORD ?

rock3x DWORD ?
rock3y DWORD ?
rock3angle FXPT ?
rock3bitMap DWORD ?
rock3on DWORD ?

rock4x DWORD ?
rock4y DWORD ?
rock4angle FXPT ?
rock4bitMap DWORD ?
rock4on DWORD ?


fighter0ptr DWORD ?
fighter0x DWORD ?
fighter0y DWORD ?
fighter0angle FXPT ?
fightermode DWORD 0
fighterSpeed DWORD 10

nukeptr DWORD ?
nukex DWORD ?
nukey DWORD ?
nukeangle FXPT ? 
nukeOn DWORD ?  ;; 0 = nuke not on, 1 = nuke on
nukeLife DWORD ? ;; default life time 20 * 10 px

gameOverStr BYTE "Game Over!", 0
gameOver DWORD 0
pauseStr BYTE "Resume with Enter/Return", 0
pause DWORD 0
resumeStr BYTE "Pause with Space Bar", 0
winStr BYTE "CONGRATULATIONS YOU WIN!", 0

timeclick DWORD 0
score DWORD 0

fmtStrTime BYTE "time: %d", 0 
outStrTime BYTE 256 DUP(0)

fmtStrScore BYTE "Score: %d", 0 
outStrScore BYTE 256 DUP(0)


fighter_000 EECS205BITMAP <44, 37, 255,, offset fighter_000 + sizeof fighter_000>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,0b6h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h
	BYTE 0ffh,0e0h,0e0h,080h,080h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,080h,080h
	BYTE 080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h,013h,049h,00ah,024h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,049h,091h,049h,013h,0ffh,00ah,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h
	BYTE 013h,013h,0ffh,00ah,00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,013h,013h,013h,00ah
	BYTE 00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,013h,013h,013h,00ah,00ah,091h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,049h,091h,0b6h,049h,013h,013h,00ah,024h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,091h
	BYTE 0b6h,049h,0ffh,024h,091h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,0b6h,091h,091h
	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,091h,049h,049h,049h,049h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,080h,0ffh,0ffh
	BYTE 0ffh,049h,091h,049h,049h,091h,049h,049h,024h,024h,049h,024h,0ffh,0ffh,0ffh,080h
	BYTE 080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,080h,080h,0ffh,049h,091h,091h,0b6h
	BYTE 091h,049h,049h,024h,049h,049h,049h,049h,024h,0ffh,0e0h,080h,080h,080h,080h,080h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0e0h,049h,049h,049h,024h,080h,0ffh,049h,091h,0b6h,0b6h,091h,091h,049h,049h
	BYTE 049h,049h,049h,049h,024h,0ffh,0e0h,024h,024h,024h,024h,080h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h
	BYTE 091h,049h,024h,049h,091h,091h,0b6h,091h,091h,091h,049h,049h,049h,049h,049h,049h
	BYTE 049h,024h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0ffh
	BYTE 049h,0b6h,091h,091h,091h,091h,049h,049h,049h,049h,049h,049h,024h,0e0h,091h,049h
	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0ffh,049h,049h,091h
	BYTE 091h,091h,049h,049h,049h,049h,024h,024h,0e0h,080h,091h,049h,049h,049h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0e0h,049h,091h,049h,049h,049h,049h,024h
	BYTE 024h,024h,049h,024h,080h,080h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,049h,049h
	BYTE 049h,024h,024h,0e0h,0e0h,0b6h,049h,0b6h,0b6h,091h,080h,049h,049h,049h,024h,049h
	BYTE 080h,080h,049h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,091h,091h,049h,024h
	BYTE 0e0h,0b6h,049h,091h,0b6h,091h,080h,049h,049h,024h,024h,049h,080h,091h,049h,049h
	BYTE 049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,049h,0b6h,091h,091h,091h,091h,091h,049h,024h,0e0h,0b6h,049h,0b6h
	BYTE 091h,049h,080h,024h,024h,049h,024h,049h,080h,091h,049h,049h,049h,049h,049h,024h
	BYTE 024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h
	BYTE 0b6h,091h,091h,000h,091h,091h,049h,024h,0e0h,0b6h,091h,049h,0b6h,091h,080h,049h
	BYTE 049h,024h,049h,049h,080h,091h,049h,049h,000h,049h,049h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,049h,0b6h,091h,000h,0fch
	BYTE 000h,091h,049h,024h,0e0h,0b6h,091h,049h,091h,091h,080h,049h,024h,024h,049h,049h
	BYTE 080h,091h,049h,000h,090h,000h,049h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,0b6h,000h,0fch,000h,0fch,000h,049h,024h
	BYTE 0e0h,0b6h,091h,049h,0b6h,049h,080h,024h,049h,024h,049h,049h,080h,091h,000h,090h
	BYTE 000h,090h,000h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0b6h,091h,049h,0e0h,0b6h,000h,000h,000h,000h,000h,049h,024h,080h,0b6h,091h,091h
	BYTE 049h,091h,080h,049h,024h,049h,049h,049h,080h,091h,000h,000h,000h,000h,000h,024h
	BYTE 024h,024h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0e0h,0e0h,080h
	BYTE 0b6h,091h,091h,091h,091h,091h,049h,024h,080h,0b6h,091h,0b6h,091h,049h,080h,024h
	BYTE 049h,049h,049h,049h,080h,091h,049h,049h,049h,049h,049h,024h,024h,080h,080h,080h
	BYTE 049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,080h,080h,0ffh,0ffh,049h,049h,049h
	BYTE 049h,049h,024h,0e3h,0b6h,0b6h,091h,091h,0b6h,091h,024h,049h,049h,049h,049h,049h
	BYTE 024h,0e3h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,080h,080h,080h,080h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0e0h,080h,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,0e0h,0e0h,080h,080h
	BYTE 0ffh,0b6h,049h,049h,049h,0b6h,091h,024h,024h,024h,024h,024h,0ffh,0e0h,0e0h,080h
	BYTE 080h,080h,080h,080h,080h,0ffh,0ffh,0ffh,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,080h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,080h,080h,080h,080h,080h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0e0h,024h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh


fighter_002 EECS205BITMAP <41, 41, 255,, offset fighter_002 + sizeof fighter_002>

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,049h,049h,024h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,049h,0ffh,0e0h,0e0h,080h,080h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,080h

	BYTE 080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,049h,091h,049h,013h,049h,00ah,024h,049h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h

	BYTE 013h,0ffh,00ah,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,013h,013h,0ffh,00ah,00ah,049h,024h,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h

	BYTE 091h,013h,013h,013h,00ah,00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,013h,013h,013h,00ah,00ah,091h

	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 049h,091h,0b6h,049h,013h,013h,00ah,024h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,091h,0b6h,049h,0ffh,024h

	BYTE 091h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,049h,049h,091h,091h,0b6h,091h,091h,049h,049h,024h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,091h

	BYTE 049h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h

	BYTE 080h,0ffh,0ffh,0ffh,049h,091h,049h,049h,091h,049h,049h,024h,024h,049h,024h,0ffh

	BYTE 0ffh,0ffh,080h,080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,080h,080h,0ffh,049h,091h,091h,0b6h

	BYTE 091h,049h,049h,024h,049h,049h,049h,049h,024h,0ffh,0e0h,080h,080h,080h,080h,080h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,049h

	BYTE 049h,049h,024h,080h,0ffh,049h,091h,0b6h,0b6h,091h,091h,049h,049h,049h,049h,049h

	BYTE 049h,024h,0ffh,0e0h,024h,024h,024h,024h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,049h,091h,091h

	BYTE 0b6h,091h,091h,091h,049h,049h,049h,049h,049h,049h,049h,024h,091h,049h,049h,049h

	BYTE 024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0b6h,091h,091h,091h,049h,024h,0ffh,049h,0b6h,091h,091h,091h,091h,049h,049h,049h

	BYTE 049h,049h,049h,024h,0e0h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h

	BYTE 0ffh,049h,049h,091h,091h,091h,049h,049h,049h,049h,024h,024h,0e0h,080h,091h,049h

	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0e0h,049h,091h,049h,049h,049h,049h

	BYTE 024h,024h,024h,049h,024h,080h,080h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,049h,049h,049h,024h

	BYTE 024h,0e0h,0e0h,0b6h,049h,0b6h,0b6h,091h,080h,049h,049h,049h,024h,049h,080h,080h

	BYTE 049h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0b6h,091h,091h,091h,091h,091h,049h,024h,0e0h,0b6h,049h,091h,0b6h

	BYTE 091h,080h,049h,049h,024h,024h,049h,080h,091h,049h,049h,049h,049h,049h,024h,024h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,091h,091h,091h

	BYTE 091h,091h,049h,024h,0e0h,0b6h,049h,0b6h,091h,049h,080h,024h,024h,049h,024h,049h

	BYTE 080h,091h,049h,049h,049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,049h,049h,0b6h,091h,091h,000h,091h,091h,049h,024h,0e0h,0b6h,091h

	BYTE 049h,0b6h,091h,080h,049h,049h,024h,049h,049h,080h,091h,049h,049h,000h,049h,049h

	BYTE 024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,049h,0b6h,091h

	BYTE 000h,0fch,000h,091h,049h,024h,0e0h,0b6h,091h,049h,091h,091h,080h,049h,024h,024h

	BYTE 049h,049h,080h,091h,049h,000h,090h,000h,049h,024h,024h,024h,049h,024h,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,091h,0b6h,091h,049h,0b6h,000h,0fch,000h,0fch,000h,049h,024h,0e0h

	BYTE 0b6h,091h,049h,0b6h,049h,080h,024h,049h,024h,049h,049h,080h,091h,000h,090h,000h

	BYTE 090h,000h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,049h,0e0h

	BYTE 0b6h,000h,000h,000h,000h,000h,049h,024h,080h,0b6h,091h,091h,049h,091h,080h,049h

	BYTE 024h,049h,049h,049h,080h,091h,000h,000h,000h,000h,000h,024h,024h,024h,049h,049h

	BYTE 024h,0ffh,0ffh,0ffh,091h,091h,0e0h,0e0h,080h,0b6h,091h,091h,091h,091h,091h,049h

	BYTE 024h,080h,0b6h,091h,0b6h,091h,049h,080h,024h,049h,049h,049h,049h,080h,091h,049h

	BYTE 049h,049h,049h,049h,024h,024h,080h,080h,080h,049h,024h,0ffh,0ffh,0ffh,0e0h,080h

	BYTE 080h,0ffh,0ffh,049h,049h,049h,049h,049h,024h,0e3h,0b6h,0b6h,091h,091h,0b6h,091h

	BYTE 024h,049h,049h,049h,049h,049h,024h,0e3h,024h,024h,024h,024h,024h,024h,0ffh,0ffh

	BYTE 080h,080h,080h,080h,0ffh,0ffh,0e0h,080h,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,0e0h

	BYTE 0e0h,080h,080h,0ffh,0b6h,049h,049h,049h,0b6h,091h,024h,024h,024h,024h,024h,0ffh

	BYTE 0e0h,0e0h,080h,080h,080h,080h,080h,080h,0ffh,0ffh,0ffh,080h,080h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,080h,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,080h,080h,080h,080h,080h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh

	BYTE 00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh

	BYTE 017h,017h,017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,0ffh,0ffh,017h,017h

	BYTE 00fh,0ffh,0ffh,0ffh,0ffh,0e0h,024h,080h,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh

	BYTE 0ffh,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 00fh,017h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,080h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,017h,00fh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,0ffh,0ffh

	BYTE 017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h

	BYTE 017h,0ffh,0ffh,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h

	BYTE 017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,00fh,017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh

nuke_000 EECS205BITMAP <8, 9, 255,, offset nuke_000 + sizeof nuke_000>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh
	BYTE 01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

asteroid_001 EECS205BITMAP <32, 32, 255,, offset asteroid_001 + sizeof asteroid_001>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,049h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,091h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,091h,049h,091h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,091h,091h,091h,091h,049h,091h,049h,024h,049h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,091h,091h,091h,049h,024h,049h,091h,024h,024h,049h,049h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,091h,091h,091h,049h,024h,049h,091h,049h,024h,049h,049h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 091h,0b6h,0b6h,091h,049h,049h,024h,049h,024h,024h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 049h,091h,0b6h,091h,091h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h
	BYTE 091h,049h,091h,091h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h
	BYTE 091h,091h,091h,091h,049h,049h,024h,024h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,0b6h
	BYTE 0b6h,091h,091h,049h,049h,024h,024h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,0b6h,0b6h
	BYTE 091h,091h,049h,049h,049h,024h,024h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,091h,0b6h,0b6h,0b6h,091h,091h,0b6h,091h
	BYTE 091h,091h,049h,049h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,049h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,049h,024h,024h,091h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,049h
	BYTE 091h,049h,049h,049h,049h,024h,049h,091h,091h,049h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,049h,049h
	BYTE 049h,091h,049h,049h,024h,024h,049h,049h,091h,091h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,091h,091h,0b6h,091h,091h,0b6h,091h,049h,049h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,091h,091h,049h,024h,024h,024h,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,091h,091h,049h,049h,091h,0b6h,091h,091h,091h,091h,091h,049h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,091h,091h,049h,024h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,0b6h,091h,091h,091h,049h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,091h,049h,049h,049h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h
	BYTE 049h,049h,049h,049h,024h,024h,049h,091h,049h,049h,049h,091h,049h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,0b6h,091h,0b6h,0b6h,091h,091h,091h,091h
	BYTE 049h,049h,049h,049h,024h,024h,024h,049h,049h,049h,091h,049h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,049h
	BYTE 049h,049h,091h,049h,049h,049h,049h,049h,049h,091h,091h,049h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,049h,049h
	BYTE 049h,024h,049h,091h,049h,049h,049h,049h,091h,091h,049h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,049h
	BYTE 049h,049h,024h,049h,091h,091h,091h,091h,091h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,091h,091h,091h
	BYTE 091h,091h,091h,091h,091h,049h,049h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,091h
	BYTE 091h,049h,049h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,049h
	BYTE 049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

asteroid_002 EECS205BITMAP <13, 14, 255,, offset asteroid_002 + sizeof asteroid_002>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h
	BYTE 049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h,024h,024h,024h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,091h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,049h,049h,024h,049h,024h,024h,0ffh,091h
	BYTE 0b6h,091h,091h,091h,0b6h,091h,091h,049h,049h,049h,024h,0ffh,091h,0b6h,0b6h,091h
	BYTE 049h,091h,0b6h,091h,049h,024h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,091h,049h,091h
	BYTE 049h,049h,024h,024h,024h,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,091h,049h,049h
	BYTE 024h,024h,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,091h,091h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

asteroid_003 EECS205BITMAP <48, 42, 255,, offset asteroid_003 + sizeof asteroid_003>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,024h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,049h
	BYTE 049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,049h,091h,091h
	BYTE 049h,049h,049h,024h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,049h,049h
	BYTE 049h,049h,049h,049h,024h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,0b6h,0b6h,091h,091h,049h
	BYTE 049h,049h,024h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,091h,091h,091h,0b6h,091h,091h,049h,091h,0b6h,0b6h,091h,091h
	BYTE 049h,049h,049h,049h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,0b6h,091h,091h
	BYTE 091h,049h,049h,049h,024h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,091h,091h,091h,091h,091h,049h,049h,049h,091h,091h,0b6h,091h
	BYTE 091h,091h,049h,049h,024h,024h,049h,049h,024h,024h,049h,049h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,091h,091h,091h,091h,0b6h,091h,091h,049h,049h,049h,049h,0b6h,091h
	BYTE 091h,091h,049h,049h,049h,024h,049h,049h,024h,024h,049h,049h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,091h
	BYTE 091h,091h,049h,049h,049h,024h,024h,049h,049h,024h,024h,049h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h,091h
	BYTE 091h,091h,049h,049h,049h,049h,049h,049h,049h,024h,024h,049h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h,024h,049h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 0b6h,091h,091h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h,0b6h,0b6h,091h,091h
	BYTE 049h,049h,091h,049h,049h,049h,049h,049h,049h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 0b6h,091h,091h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,0b6h,0b6h,091h,091h,049h
	BYTE 049h,091h,091h,049h,049h,049h,024h,049h,049h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h
	BYTE 0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,049h
	BYTE 091h,091h,091h,049h,049h,024h,024h,049h,049h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h
	BYTE 091h,091h,091h,049h,091h,0b6h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h
	BYTE 091h,091h,049h,049h,049h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h
	BYTE 091h,091h,091h,091h,049h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h
	BYTE 091h,091h,049h,049h,024h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h
	BYTE 091h,091h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,024h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h
	BYTE 091h,091h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,024h,024h,024h,049h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h
	BYTE 091h,091h,049h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h,091h,091h,091h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h
	BYTE 091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,049h,091h,091h,091h,091h
	BYTE 049h,049h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,0b6h
	BYTE 0b6h,091h,091h,049h,091h,0b6h,091h,091h,091h,091h,091h,091h,091h,091h,091h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h,091h,049h,091h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,091h,049h,049h,091h,091h,091h,091h,049h,049h
	BYTE 049h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,049h,091h
	BYTE 091h,0b6h,091h,049h,091h,091h,091h,049h,049h,091h,091h,091h,049h,049h,049h,049h
	BYTE 049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,0b6h,0b6h,091h,049h,049h
	BYTE 091h,0b6h,091h,049h,091h,091h,091h,049h,091h,091h,049h,049h,049h,049h,024h,024h
	BYTE 049h,049h,049h,024h,024h,024h,024h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,049h
	BYTE 091h,0b6h,091h,049h,091h,091h,049h,049h,091h,049h,049h,091h,091h,049h,049h,024h
	BYTE 024h,049h,024h,024h,024h,024h,049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h,091h,0b6h,091h,049h
	BYTE 091h,0b6h,091h,049h,091h,049h,049h,091h,049h,049h,024h,049h,091h,091h,049h,024h
	BYTE 024h,049h,024h,024h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,0b6h,091h
	BYTE 049h,091h,049h,091h,091h,049h,049h,091h,049h,024h,049h,049h,049h,091h,049h,024h
	BYTE 024h,024h,024h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h
	BYTE 091h,091h,091h,091h,091h,049h,049h,091h,049h,024h,024h,049h,049h,091h,049h,049h
	BYTE 024h,024h,024h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,049h,091h,0b6h,091h,091h,091h,091h,091h,091h
	BYTE 091h,091h,091h,091h,091h,049h,049h,091h,049h,049h,024h,024h,091h,049h,049h,049h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,091h,091h,091h,0b6h,091h
	BYTE 091h,091h,091h,091h,091h,091h,049h,049h,091h,049h,049h,049h,049h,049h,049h,049h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h
	BYTE 091h,091h,049h,091h,091h,091h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h
	BYTE 024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,0b6h,091h,091h
	BYTE 091h,091h,049h,049h,049h,091h,049h,049h,049h,049h,049h,049h,049h,049h,024h,024h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,0b6h,0b6h,091h
	BYTE 091h,091h,049h,049h,091h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h
	BYTE 091h,091h,049h,024h,049h,091h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h
	BYTE 091h,091h,049h,024h,024h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 091h,091h,091h,049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 091h,091h,091h,049h,049h,049h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,049h,049h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,091h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh


asteroid_004 EECS205BITMAP <18, 26, 255,, offset asteroid_004 + sizeof asteroid_004>
	BYTE 0ffh,0ffh,091h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,0b6h,091h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,091h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,024h,049h,091h,049h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,024h
	BYTE 024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h
	BYTE 049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,049h,049h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,091h,049h,049h,024h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,049h,049h,024h,024h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,049h,049h,049h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,049h,049h,024h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,091h
	BYTE 049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h
	BYTE 091h,0b6h,091h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,0b6h,091h,091h,049h,024h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,024h,049h,049h,024h,024h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,0b6h,0b6h,091h,091h,049h,024h,049h,049h,024h,049h,024h,024h,024h
	BYTE 024h,0ffh,0ffh,091h,0b6h,0b6h,0b6h,0b6h,091h,049h,049h,091h,049h,024h,024h,024h
	BYTE 049h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,049h,091h,0b6h,049h,049h,049h,049h,049h
	BYTE 024h,024h,024h,049h,049h,024h,0ffh,091h,0b6h,0b6h,091h,049h,091h,049h,091h,049h
	BYTE 049h,091h,049h,024h,024h,049h,049h,024h,0ffh,0ffh,091h,0b6h,091h,091h,049h,049h
	BYTE 091h,049h,024h,049h,091h,049h,024h,024h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,091h
	BYTE 049h,049h,049h,091h,049h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,0b6h,091h,049h,049h,091h,091h,049h,049h,049h,049h,024h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,0b6h,091h,091h,049h,091h,091h,091h,049h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,091h,091h,091h,049h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,049h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh


asteroid_005 EECS205BITMAP <21, 23, 255,, offset asteroid_005 + sizeof asteroid_005>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h
	BYTE 049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,091h,049h,049h,024h,049h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,0b6h,0b6h
	BYTE 091h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,049h,091h,0b6h,0b6h,091h,049h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,0b6h,0b6h,091h,049h,091h,091h,0b6h,091h,049h,024h,049h,049h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,091h,091h,049h,049h,091h,0b6h
	BYTE 091h,049h,024h,049h,049h,024h,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h
	BYTE 091h,091h,049h,049h,091h,049h,049h,024h,024h,049h,024h,024h,091h,0b6h,0b6h,0b6h
	BYTE 0b6h,0b6h,091h,091h,0b6h,091h,091h,091h,049h,049h,024h,049h,049h,024h,024h,024h
	BYTE 024h,091h,0b6h,0b6h,091h,091h,0b6h,091h,049h,091h,0b6h,091h,049h,049h,024h,024h
	BYTE 024h,024h,049h,024h,024h,024h,091h,0b6h,091h,091h,0b6h,0b6h,091h,049h,049h,091h
	BYTE 091h,091h,049h,049h,049h,024h,024h,024h,024h,049h,024h,091h,0b6h,091h,091h,0b6h
	BYTE 091h,091h,091h,091h,091h,049h,049h,091h,091h,049h,049h,024h,024h,024h,024h,024h
	BYTE 091h,0b6h,091h,091h,091h,091h,049h,091h,091h,049h,049h,091h,049h,049h,091h,049h
	BYTE 024h,024h,024h,024h,0ffh,091h,0b6h,0b6h,091h,091h,0b6h,091h,091h,091h,091h,091h
	BYTE 0b6h,091h,091h,049h,024h,024h,024h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,091h,091h
	BYTE 091h,0b6h,0b6h,0b6h,0b6h,091h,091h,0b6h,091h,049h,024h,049h,091h,049h,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,0ffh,0ffh,091h,091h,049h,049h
	BYTE 091h,091h,049h,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,091h,091h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,049h,091h,091h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh

.CODE
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;-- CheckIntersect: check if two sprites collided
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckIntersect PROC USES ecx edx ebx esi oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
	
	xor eax, eax 
	;;check horizontal one's right border <=  two's left border, if yes, return 0, else jmp to check one's left border >= two's right border
	mov ecx, oneBitmap
	mov ebx, (EECS205BITMAP PTR [ecx]).dwWidth
	sar ebx, 1
	add ebx, oneX
 
	mov edx, twoBitmap
	mov esi, (EECS205BITMAP PTR [edx]).dwWidth
	sar esi, 1
	mov eax, twoX
	sub eax, esi
	
	cmp ebx, eax
	jle No_intersect
	
	;;check horizonal one's left border >=  two's right border, if yes return 0, else jmp to check vertical 
        mov ebx, (EECS205BITMAP PTR [ecx]).dwWidth
        sar ebx, 1 
        mov eax, oneX
	sub eax, ebx

        mov esi, (EECS205BITMAP PTR [edx]).dwWidth
        sar esi, 1
        add esi, twoX
        
        cmp eax, esi
        jge No_intersect

	;;check vertical, now we know they intersect horizontally, see if vertical as well, see if one's top <= two's bottom
        mov ebx, (EECS205BITMAP PTR [ecx]).dwHeight
        sar ebx, 1 
        add ebx, oneY

        mov esi, (EECS205BITMAP PTR [edx]).dwHeight
        sar esi, 1
        mov eax, twoY
        sub eax, esi
	
	cmp ebx, eax
	jle No_intersect

	;;check vertical, see if one bottm >= two's top
	mov ebx, (EECS205BITMAP PTR [ecx]).dwHeight
        sar ebx, 1
        mov eax, oneY
        sub eax, ebx

        mov esi, (EECS205BITMAP PTR [edx]).dwHeight
        sar esi, 1
        add esi, twoY

        cmp eax, esi
        jge No_intersect
	
	;;they intersect 
	mov eax, 1
	jmp DONE	
	
No_intersect:
	mov eax, 0
DONE:
	ret
CheckIntersect ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;-- ClearRotateObject: clear a rotated object with angle 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearRotateObject PROC USES ecx edx ebx esi edi  lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
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
	invoke DrawPixel, xInput, yInput, 0
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
ClearRotateObject ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;-- helper FireNuke: update/fire the nuke, posn based on direction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FireNuke PROC USES ecx
	;see if nuke already fired then update
	cmp nukeOn, 1
	je updateNuke
	
	;nuke not fired, see if we need to fire one
	mov eax, OFFSET MouseStatus
	mov eax, [eax + 8]
	cmp eax, MK_LBUTTON   ;;left mouse clicked
	jne nukeDONE
	mov ecx, fighter0x
	mov nukex, ecx
	mov ecx, fighter0y
	mov nukey, ecx
	mov ecx, fighter0angle
	mov nukeangle, ecx
	mov nukeOn, 1
	mov nukeLife, 20
	invoke RotateBlit, nukeptr, nukex, nukey, nukeangle
	invoke PlaySound, offset missleWAV, 0, SND_FILENAME OR SND_ASYNC
	jmp nukeDONE

updateNuke:
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle
	cmp nukeangle, 0
	jne downNuke
	sub nukey, 10
	jmp renderNuke
downNuke:
	cmp nukeangle, 205886
	jne leftNuke
	add nukey, 10
	jmp renderNuke
leftNuke:
	cmp nukeangle, 308829
	jne rightNuke
	sub nukex, 10
	jmp renderNuke
rightNuke:
	cmp nukeangle, 102943
	jne nukeDONE
	add nukex, 10
	jmp renderNuke
renderNuke:
	invoke RotateBlit, nukeptr, nukex, nukey, nukeangle
	sub nukeLife, 1
	cmp nukeLife, 0
	jne nukeDONE
	mov nukeOn, 0
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle
	
nukeDONE:
	ret
FireNuke ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;-- helper UpdateFighter: update the posn of fighter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateFighter PROC

	mov eax, OFFSET MouseStatus
        mov eax, [eax + 8]
	cmp eax, MK_RBUTTON
	jne checkUp
	xor fightermode, 1
	invoke ClearRotateObject, fighter0ptr, fighter0x, fighter0y, fighter0angle
	cmp fightermode, 0
	je setOne
	mov fighterSpeed, 10
        lea eax, fighter_000
        mov fighter0ptr, eax
	jmp updateFighter
setOne:
	mov fighterSpeed, 20
        lea eax, fighter_002
        mov fighter0ptr, eax
updateFighter:	
        invoke RotateBlit, fighter0ptr, fighter0x, fighter0y, fighter0angle
        mov eax, OFFSET MouseStatus
        mov DWORD PTR [eax + 8], 0
checkUp:
	cmp KeyPress, 57h
	jne checkDown
	invoke ClearRotateObject, fighter0ptr, fighter0x, fighter0y, fighter0angle
	mov fighter0angle, 0
	mov eax, fighterSpeed
	sub fighter0y, eax
	invoke BasicBlit, fighter0ptr, fighter0x, fighter0y

checkDown:
	cmp KeyPress, 53h
	jne checkLeft
	invoke ClearRotateObject, fighter0ptr, fighter0x, fighter0y, fighter0angle
	mov fighter0angle, 205886
	mov eax, fighterSpeed
	add fighter0y, eax
	invoke RotateBlit, fighter0ptr, fighter0x, fighter0y, 205886

checkLeft:
	cmp KeyPress, 41h
	jne checkRight
	invoke ClearRotateObject, fighter0ptr, fighter0x, fighter0y,  fighter0angle
	mov fighter0angle, 308829
	mov eax,fighterSpeed
	sub fighter0x, eax
	invoke RotateBlit, fighter0ptr, fighter0x, fighter0y, 308829

checkRight:
	cmp KeyPress, 44h
	jne done
	invoke ClearRotateObject, fighter0ptr, fighter0x, fighter0y, fighter0angle
	mov fighter0angle, 102943
	mov eax, fighterSpeed
	add fighter0x, eax
	invoke RotateBlit, fighter0ptr, fighter0x, fighter0y, 102943
done:
	ret
UpdateFighter ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;-- UpdateRocks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateRocks PROC
	
	cmp rock0on, 1
	je updaterock1
	invoke nrandom, 500
	add eax, 40
	mov rock0x, eax
	invoke nrandom, 350
	mov rock0y, eax
	add rock0y, 50
	invoke BasicBlit, rock0bitMap, rock0x, rock0y
	mov rock0on, 1
updaterock1:
	cmp rock1on, 1
	je updaterock2
	invoke nrandom, 500
        add eax, 40
        mov rock1x, eax
        invoke nrandom, 350
        mov rock1y, eax
        add rock1y, 50
        invoke BasicBlit, rock1bitMap, rock1x, rock1y
	mov rock1on, 1
updaterock2:
	cmp rock2on, 1
	je updaterock3
	invoke nrandom, 500
        add eax, 40
        mov rock2x, eax
        invoke nrandom, 350
        mov rock2y, eax
        add rock2y, 50
        invoke BasicBlit, rock2bitMap, rock2x, rock2y
	mov rock2on, 1
updaterock3:
	cmp rock3on, 1
	je updaterock4
	 invoke nrandom, 500
        add eax, 40
        mov rock3x, eax
        invoke nrandom, 350
        mov rock3y, eax
        add rock3y, 50
        invoke BasicBlit, rock3bitMap, rock3x, rock3y
	mov rock3on, 1
updaterock4:
	cmp rock4on, 1
	je rocksover
	 invoke nrandom, 500
        add eax, 40
        mov rock4x, eax
        invoke nrandom, 350
        mov rock4y, eax
        add rock4y, 50
        invoke BasicBlit, rock4bitMap, rock4x, rock4y	
	mov rock4on, 1
rocksover:
	ret
UpdateRocks ENDP


UpdateScore PROC
        push score
        push offset fmtStrScore
        push offset outStrScore
        call wsprintf
        add esp, 12
        invoke DrawStr, offset outStrScore, 550, 10, 0
        inc score
        push score
        push offset fmtStrScore
        push offset outStrScore
        call wsprintf
        add esp, 12
        invoke DrawStr, offset outStrScore, 550, 10, 255
        ret
UpdateScore ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;helper check collison
CheckCollision PROC
	
	;;check collision of nuke and rocks if nuke on
	cmp nukeOn, 1
	jne checkRock0
	cmp rock0on, 0
	je checknuke1
	invoke CheckIntersect, nukex, nukey, nukeptr, rock0x, rock0y, rock0bitMap
	cmp eax, 0
	je checknuke1
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle	
	invoke ClearRotateObject, rock0bitMap, rock0x, rock0y, rock0angle
	invoke UpdateScore
;	invoke PlaySound, offset bombWAV, 0, SND_FILENAME OR SND_ASYNC
	mov nukeOn, 0
	mov rock0on, 0
	jmp checkRock0
checknuke1:
        cmp rock1on, 0
        je checknuke2
	invoke CheckIntersect, nukex, nukey, nukeptr, rock1x, rock1y, rock1bitMap
	cmp eax, 0
	je checknuke2
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle	
	invoke ClearRotateObject, rock1bitMap, rock1x, rock1y, rock1angle
	invoke UpdateScore
   ;     invoke PlaySound, offset bombWAV, 0, SND_FILENAME OR SND_ASYNC
	mov nukeOn, 0
	mov rock1on, 0
	jmp checkRock0
checknuke2:
        cmp rock2on, 0
        je checknuke3
	invoke CheckIntersect, nukex, nukey, nukeptr, rock2x, rock2y, rock2bitMap
	cmp eax, 0
	je checknuke3
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle	
	invoke ClearRotateObject, rock2bitMap, rock2x, rock2y, rock2angle
	invoke UpdateScore
 ;       invoke PlaySound, offset bombWAV, 0, SND_FILENAME OR SND_ASYNC
	mov nukeOn, 0
	mov rock2on, 0
	jmp checkRock0
checknuke3:
        cmp rock3on, 0
        je checknuke4
	invoke CheckIntersect, nukex, nukey, nukeptr, rock3x, rock3y, rock3bitMap
	cmp eax, 0
	je checknuke4
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle	
	invoke ClearRotateObject, rock3bitMap, rock3x, rock3y, rock3angle
	invoke UpdateScore
  ;      invoke PlaySound, offset bombWAV, 0, SND_FILENAME OR SND_ASYNC
	mov nukeOn, 0
	mov rock3on, 0
	jmp checkRock0
checknuke4:
        cmp rock4on, 0
        je checkRock0
	invoke CheckIntersect, nukex, nukey, nukeptr, rock4x, rock4y, rock4bitMap
	cmp eax, 0
	je checkRock0
	invoke ClearRotateObject, nukeptr, nukex, nukey, nukeangle	
	invoke ClearRotateObject, rock4bitMap, rock4x, rock4y, rock4angle
	invoke UpdateScore
;        invoke PlaySound, offset bombWAV, 0, SND_FILENAME OR SND_ASYNC
	mov nukeOn, 0
	mov rock4on, 0

checkRock0:
	cmp rock0on, 0
	je checkRock1
	invoke CheckIntersect, fighter0x, fighter0y, fighter0ptr, rock0x, rock0y, rock0bitMap
	cmp eax, 0
	je checkRock1
	invoke ClearRotateObject, fighter0ptr,fighter0x, fighter0y, fighter0angle	
	invoke ClearRotateObject, rock0bitMap, rock0x, rock0y, rock0angle
	invoke UpdateScore
	jmp over
checkRock1:
	cmp rock1on, 0
	je checkRock2
	invoke CheckIntersect, fighter0x, fighter0y, fighter0ptr, rock1x, rock1y, rock1bitMap
	cmp eax, 0
	je checkRock2
	invoke ClearRotateObject, fighter0ptr,fighter0x, fighter0y, fighter0angle	
	invoke ClearRotateObject, rock1bitMap, rock1x, rock1y, rock1angle
	jmp over
checkRock2:
	cmp rock2on, 0
	je checkRock3
	invoke CheckIntersect, fighter0x, fighter0y, fighter0ptr, rock2x, rock2y, rock2bitMap
	cmp eax, 0
	je checkRock3
	invoke ClearRotateObject, fighter0ptr,fighter0x, fighter0y, fighter0angle	
	invoke ClearRotateObject, rock2bitMap, rock2x, rock2y, rock2angle
	jmp over
checkRock3:
	cmp rock3on, 0
	je checkRock4
	invoke CheckIntersect, fighter0x, fighter0y, fighter0ptr, rock3x, rock3y, rock3bitMap
	cmp eax, 0
	je checkRock4
	invoke ClearRotateObject, fighter0ptr,fighter0x, fighter0y, fighter0angle	
	invoke ClearRotateObject, rock3bitMap, rock3x, rock3y, rock3angle
	jmp over
checkRock4:
	cmp rock4on, 0
	je noCollision
	invoke CheckIntersect, fighter0x, fighter0y, fighter0ptr, rock4x, rock4y, rock4bitMap
	cmp eax, 0
	je noCollision
	invoke ClearRotateObject, fighter0ptr,fighter0x, fighter0y, fighter0angle	
	invoke ClearRotateObject, rock0bitMap, rock4x, rock4y, rock4angle
	jmp over
over:
	invoke DrawStr, offset gameOverStr, 270, 200, 0ffh
        invoke PlaySound, offset bombWAV, NULL, SND_ASYNC AND SND_MEMORY
;	invoke PlaySound,NULL,NULL,SND_ASYNC
	invoke PlaySound, offset gameoverWAV, NULL, SND_ASYNC AND SND_MEMORY
	mov gameOver, 1
noCollision:
	ret
CheckCollision ENDP


GameInit PROC USES ebx ecx esi
	
	mov timeclick, 1000
	mov score, 0	
	
	invoke DrawStarField

        push score
        push offset fmtStrScore
        push offset outStrScore
        call wsprintf
        add esp, 12
        invoke DrawStr, offset outStrScore, 550, 10, 255
	
	;random seed
	rdtsc 
	invoke nseed, eax	

	;load the fighter
	mov fightermode, 0
	mov fighterSpeed, 10
	lea ebx, fighter_000
	mov fighter0ptr, ebx
	mov fighter0x, 270	
	mov fighter0y, 200
	mov fighter0angle, 0
	invoke BasicBlit, ebx, 270, 200
	
	;load the nuke
	lea ecx, nuke_000
	mov nukeptr, ecx
	mov nukeOn, 0
	mov nukeLife, 20
	mov nukeangle, 0
	
	;load the asteroids

	lea ebx, asteroid_001
	mov rock0x, 100
	mov rock0y, 120
	mov rock0bitMap, ebx
	mov rock0on, 1
	invoke BasicBlit, ebx, 100,120

	lea ebx, asteroid_002
	mov rock1x, 150
	mov rock1y, 40
	mov rock1bitMap, ebx
	mov rock1on, 1
	invoke BasicBlit, ebx, 150,40

	lea ebx, asteroid_003
	mov rock2x, 400
	mov rock2y, 130
	mov rock2bitMap, ebx
	mov rock2on, 1
	invoke BasicBlit, ebx, 400,130


	lea ebx, asteroid_004
	mov rock3x, 240
	mov rock3y, 300
	mov rock3bitMap, ebx
	mov rock3on, 1
	invoke BasicBlit, ebx, 240,300
	
	lea ebx, asteroid_005
	mov rock4x, 500
	mov rock4y, 200
	mov rock4bitMap, ebx
	mov rock4on, 1
	invoke BasicBlit, ebx, 500, 200


	ret         ;; Do not delete this line!!!
GameInit ENDP
	


GamePlay PROC USES ebx ecx

	invoke DrawStarField

	cmp gameOver, 1
	je gameover
	
	cmp KeyPress, 20h ;;space
	jne checkResume
	mov pause, 1
	jmp checkPause
checkResume:
	cmp KeyPress, 0dh ;;enter
	jne checkPause
	mov pause, 0
checkPause:
	cmp pause, 1
	jne keepGoing
        invoke DrawStr, offset resumeStr, 250, 10, 000h
	invoke DrawStr, offset pauseStr, 250, 10, 0ffh	
	jmp gameover
keepGoing:
        push timeclick
        push offset fmtStrTime
        push offset outStrTime
        call wsprintf
        add esp, 12
        invoke DrawStr, offset outStrTime, 470, 10, 0
	dec timeclick	
        push timeclick
        push offset fmtStrTime
        push offset outStrTime
        call wsprintf
        add esp, 12
        invoke DrawStr, offset outStrTime, 470, 10, 255

	
	invoke DrawStr, offset pauseStr, 250, 10, 000h
	invoke DrawStr, offset resumeStr, 250, 10, 0ffh
	invoke FireNuke
	invoke UpdateFighter
	invoke UpdateRocks
	invoke CheckCollision
gameover:
	ret     
GamePlay ENDP







END
