;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Alfred Lohmann
;* Version            : V1.0
;* Date               : 15.07.2012
;* Description        : This is a simple main.
;					  : The output is send to UART 1. Open Serial Window when 
;					  : when debugging. Select UART #1 in Serial Window selection.
;					  :
;					  : Replace this main with yours.
;
;*******************************************************************************

	IMPORT 	Init_TI_Board		; Initialize the serial line
	;IMPORT	initHW				; Init Timer
	IMPORT	puts				; C output function
	IMPORT	TFT_puts			; TFT output function

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 2
	
filter	fill 1000,0xf
prim fill 168,2,2

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main
                EXTERN Init_TI_Board
main            PROC
                bl    Init_TI_Board                 ; HW Initialisieren

; r0 = Adresse auf Speicher mit 1000 Einsen von denen die Vielfachen einer Zahl mit 0 gestrichen
; r1 = Adresse auf Speicher in der die Primzahlen stehen
; r2 = Zählvariable
; r3 = Endvariable
; r4 = Zahlen die gestrichen werden
; r5 = Endvariable
; r6 = Konstante mit 0
; r7 = Vergleicht ob eine Zahl gleich Eins ist

		ldr r0,=filter		; Die Adresse auf ein Feld mit 1000 Einsen wird geladen
		ldr r1,=prim		; Die Adresse auf ein Feld mit den Primzahlen bis 1000 wird geladen
		mov r6,#0			; Konstante um 0 zu speichern
						
										; Sieb des Eratosthenes

for_00 
		mov r2,#2			; Zählvariable
		mov r3,#1000		; Endvariable
until_00
		cmp r2,r3			; Vergleich
		bgt enddo_00		; Sprung, wenn r2 größer ist als r3, ans Ende der Schleife 00
do_00
	
if_01
		ldrb r7, [r0,r2]	; Wert der Adresse an der Stelle r0 + r2 wird in r7 geschrieben 
		cmp r7,#0xf			; Vergleich mit 1
		bne else_01			; bei false zu else_01
		
then_01

for_02
		mul r4,r2,r2		; Zählvariable ab Quadratzahl
		mov r5,#1000		; Endvariable
until_02
		cmp r4,r5			; Vergleich
		bge enddo_02		; Sprung, wenn r4 größer gleich ist als r5, ans Ende der Schleife 02
do_02
		strb r6,[r0,r4]		; Der Wert r6=0 wird auf die Adresse an der Stelle r0+r4 geschrieben 
step_02 
		add r4,r2			; Um alle Vielfachen von r2 zu streichen wird r4 um r2 erhöht
		b	until_02
enddo_02

else_01
		b	step_00
step_00 
		add r2,#1			; Wenn alle Vielfachen von r2 gestrichen wurden, wird r2 um 1 erhöht
		b	until_00
enddo_00

									; Speichern der Primzahlen in einem Feld

for_03
		mov r2,#2			; Zählvariable
		mov r3,#1000		; Endvariable
until_03
		cmp r2,r3			; Vergleich
		bge enddo_03
do_03

if_04
		ldrb r7, [r0,r2]	; Lädt den Wert von r0 + r2 in r7
		cmp	r7,#0xf			; Vergleich
		bne else_04
then_04
		strh r2,[r1],#2		; Speichert den Wert der Zählvariable in r1
else_04
		b step_03
step_03
		add r2,#1			; r2++
		b until_03
enddo_03
	
forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END
		