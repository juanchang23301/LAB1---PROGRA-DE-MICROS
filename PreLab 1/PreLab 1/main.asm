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
    OUT DDRD, R16       ; Configura PD0-PD7 como salida (LEDs)
    
    LDI R16, 0x00
    OUT DDRB, R16       ; Configura PORTB como entrada (botones)
    
    LDI R16, 0x0F
    OUT PORTB, R16      ; Habilita pull-ups en PB0 - PB3
    
    LDI R17, 0x00       ; Inicializa el contador en 0

MAIN_LOOP:
    SBIC PINB, 0         ; Si PD2 (incrementar) está en alto, salta
    RJMP CHECK_DEC       ; Si no, verifica el botón de decremento
    RCALL DELAY          ; Antirrebote
    INC R17              ; Incrementa el contador
    ANDI R17, 0x0F       ; Mantiene el contador en 4 bits (0-15)
    RCALL UPDATE_LEDS    ; Actualiza los LEDs
    RCALL WAIT_FOR_RELEASE ; Espera a que se suelte el botón

CHECK_DEC:
    SBIC PINB, 1         ; Si PD3 (decrementar) está en alto, salta
    RJMP MAIN_LOOP       ; Si no, vuelve al bucle principal
    RCALL DELAY          ; Antirrebote
    DEC R17              ; Decrementa el contador
    ANDI R17, 0xFF       ; Mantiene el contador en 4 bits (0-15)
    RCALL UPDATE_LEDS    ; Actualiza los LEDs
    RCALL WAIT_FOR_RELEASE ; Espera a que se suelte el botón

    RJMP MAIN_LOOP       ; Vuelve al inicio del bucle principal

UPDATE_LEDS:
    MOV R16, R17
    OUT PORTD, R16       ; Muestra el valor del contador en los LEDs
    RET

WAIT_FOR_RELEASE:
    SBIC PINB, 0         ; ¿Sigue presionado PD2?
    RJMP CHECK_DEC_RELEASE
    RJMP WAIT_FOR_RELEASE

CHECK_DEC_RELEASE:
    SBIC PINB, 1         ; ¿Sigue presionado PD3?
    RET
    RJMP WAIT_FOR_RELEASE

DELAY:
	LDI R18, 0xFF
SUB_DELAY1:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY1
	LDI R18, 0xFF
SUB_DELAY2:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY2
	LDI R18, 0xFF
SUB_DELAY3:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY3
	LDI R18, 0xFF
SUB_DELAY4:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY4
SUB_DELAY5:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY5
	LDI R18, 0xFF
SUB_DELAY6:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY6
	RET



