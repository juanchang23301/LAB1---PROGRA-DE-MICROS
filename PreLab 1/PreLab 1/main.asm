;************************************************************************
; Universidad del Valle de Guatemala
; IE2023: Programación de Microcontroladores
; Test.asm
;
; Author: Juan Chang
; Proyecto: Ejemplo
; Hardware: ATMega328P
; Creado: 2/5/2025 1:54:05 PM
; Modificado: 30/11/2024
; Descipción: Este programa consiste ens
;************************************************************************

.include "M328PDEF.inc"
.org 0x0000
    RJMP START

START:
    LDI R16, 0xFF
    OUT DDRD, R16       ; Configura PD0-PD7 como salida (LEDs CONTADOR)

	LDI R16, 0x1F
	OUT DDRC, R16		; Configura PC0-PC4 como salida (LEDs SUMADOR y CARRY)
    
    LDI R16, 0x00
    OUT DDRB, R16       ; Configura PORTB como entrada (botones)
    
    LDI R16, 0x1F
    OUT PORTB, R16      ; Habilita pull-ups en PB0 - PB4
    
    LDI R17, 0x00       ; Inicializa el contador en 0
	LDI R19, 0x00		; Inicializa el contador en 1111
	LDI R21, 0X00
	RCALL UPDATE_LEDS


MAIN_LOOP:
    SBIC PINB, 0			 ; Si PB0 (incrementar) está en alto, salta
    RJMP CHECK_DEC			 ; Si no, verifica el botón de decremento
    RCALL DELAY				 ; Antirrebote
    INC R17					 ; Incrementa el contador
    ANDI R17, 0x0F			 ; Mantiene el contador en 4 bits (0-15)
    RCALL UPDATE_LEDS		 ; Actualiza los LEDs
    RCALL WAIT_FOR_RELEASE	 ; Espera a que se suelte el botón

CHECK_DEC:
    SBIC PINB, 1			; Si PB1 (decrementar) está en alto, salta
    RJMP CHECK_INC2			; Si no, verificar el siguiente boton de decremento 
    RCALL DELAY				; Antirrebote
    DEC R17					; Decrementa el contador
    ANDI R17, 0x0F			; Mantiene el contador en 4 bits (0-15)
    RCALL UPDATE_LEDS		; Actualiza los LEDs
    RCALL WAIT_FOR_RELEASE	; Espera a que se suelte el botón

CHECK_INC2:
    SBIC PINB, 2			; Si PB2 (incrementar) está en alto, salta
    RJMP CHECK_DEC2			; Si no, verifica el botón de decremento
    RCALL DELAY				; Antirrebote
    INC R19					; Incrementa el contador
    ANDI R19, 0x0F			; Mantiene el contador en 4 bits (0-15)
    RCALL UPDATE_LEDS		; Actualiza los LEDs
    RCALL WAIT_FOR_RELEASE	; Espera a que se suelte el botón

CHECK_DEC2:
    SBIC PINB, 3			 ; Si PB3 (decrementar) está en alto, salta
	RJMP CHECK_SUM			 ; Si no, verifica el botón de suma
    RCALL DELAY				 ; Antirrebote
    DEC R19					 ; Decrementa el contador
    ANDI R19, 0x0F			 ; Mantiene el contador en 4 bits (0-15)
    RCALL UPDATE_LEDS		 ; Actualiza los LEDs
    RCALL WAIT_FOR_RELEASE	 ; Espera a que se suelte el botón

CHECK_SUM:
	SBIC PINB, 4			; Si PB4 está en alto, salta	
	RJMP MAIN_LOOP			; Si no, regresa al inicio
	RCALL DELAY				; Antirrebote
	RCALL UPDATE_SUM		; Actualizar el valor de la suma
	RCALL WAIT_FOR_RELEASE	; Esperar a que se suelte el boton
	RJMP MAIN_LOOP			; Regresar al inicio

UPDATE_LEDS:
    MOV R16, R17			; Mueve el valor de R17 a R16
	MOV	R20, R19			; Mueve el valor de R19 a R20
	SWAP R20				; Mueve el valor de R20 a los 4 bits menos significativos
	ANDI R18, 0XF0			; Verifica que solo haya valores en PD4 - PD7 
	OR R16, R20				
    OUT PORTD, R16			 ; Muestra el valor del contador en los LEDs
    RET

UPDATE_SUM:
    MOV R16, R17			; Mueve el valor de R17 a R16
	MOV	R20, R19			; Mueve el valor de R19 a R20
	SWAP R20				; Mueve el valor de R20 a los 4 bits menos significativos
	ANDI R18, 0XF0			; Verifica que solo haya valores en PD4 - PD7 

	ADD R16, R19			; Suma los valores de los contadores 
	MOV R21, R16			; Mueve el resultado de la suma a R21
	
	CPI R21, 0x10			; Compara la suma con 16 
		
	ANDI R18, 0X1F			; Verifica que solo haya valores en PC0 - PC3
	OUT PORTC, R21			; Muestra el valor de la suma

WAIT_FOR_RELEASE:
    SBIS PINB, 0
    RJMP WAIT_FOR_RELEASE
	SBIS PINB, 1	
	RJMP WAIT_FOR_RELEASE
    SBIS PINB, 2
	RJMP WAIT_FOR_RELEASE
    SBIS PINB, 3
    RJMP WAIT_FOR_RELEASE
    RET

DELAY:
    LDI     R18, 0xFF
SUB_DELAY1:
    DEC     R18
    CPI     R18, 0
    BRNE    SUB_DELAY1
    LDI     R18, 0xFF
SUB_DELAY2:
    DEC     R18
    CPI     R18, 0
    BRNE    SUB_DELAY2
    LDI     R18, 0xFF
SUB_DELAY3:
    DEC     R18
    CPI     R18, 0
    BRNE    SUB_DELAY3
    RET