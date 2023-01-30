;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
; 
;AUTOR: Jersson Alexander Castillo Machuca
;DATE:  29/01/2023
;PRACTICA:  Ejercicio2_PARCIAL2
;DESCRIPCION: Este programa hace un prendido y apagado de led de la placa(que es el 
    ;programa principal,RF3), cuando pulsas la INT0(RA3,boton de la placa) inicia una secuencia de 
    ;leds, si presionas INT1(RB4) capta los leds al momento que pulsate, y 
    ;vuelve al programa principal, mientras que INT2(RF2) apaga los leds 
    ;y vuelve al progrma principal, y si no pulsas INT1 O INT2, entonces durante 
    ;5 repeticiones de la secuencia de leds, acaba la secuencia y vuelve al programa principal
    ;, la cual trabajamos con una Frecuencia de 4MHz y TCY = 1us.
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
PROCESSOR 18F57Q84
#include "bits_Configuracion.inc"   
#include <xc.inc>
#include "retardos.inc"
    
PSECT udata_acs
valor:	       DS  1
contador10:    DS  1 
contador5:     DS  1
valor1:        DS  1
valor2:        DS  1
valor3:        DS  1
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    salir1       ;no se producido la INT0
corrimiento_On:                ;si se produjo la INT0
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO   INICIO
salir1:
    RETFIE


PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSC   PIR6,0,0	; ¿Se ha producido la INT1?
    GOTO    parar
apagar_leds:
    BTFSC   PIR10,0,0	; ¿Se ha producido la INT2?
    BCF     PIR10,0,0   ;limpiamos el flag
    CLRF    LATC,1      ;apagamos leds
    SETF    valor3,0
salir2:
    RETFIE 
    

    
PSECT CODE   
Main:
    CALL    CONFI_OSC,1
    CALL    CONFI_PORT,1
    CALL    CONFI_PPS,1
    CALL    CONFI_INT,1
 
ON_OFF_PLACA:
    BANKSEL LATF
    BCF	    LATF,3,1	    ;apagamos led de la placa
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BSF	    LATF,3,1	    ;prendemos led de la placa
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    GOTO ON_OFF_PLACA
INICIO:
    MOVLW   0x05             
    MOVWF   contador5,0      
    MOVLW   0x00
    MOVWF   valor2,0
    MOVWF   valor3,0
    GOTO    Reload
Loop:
    BANKSEL PCLATU
    MOVLW   low highword(TABLE)
    MOVWF   PCLATU,1
    MOVLW   high(TABLE)
    MOVWF   PCLATH,1
    RLNCF   valor,0,0
    CALL    TABLE
    BTFSC   valor3,1,0        ;el bit1 del valor3 es 0?
    GOTO    salir1
    BTFSC   valor2,1,0        ;el valor del bit1 del valor2 es 0?
    GOTO    salir1
    MOVWF   LATC,0            ;movemos el valor de w al puerto c
    MOVWF   valor1,0
    CALL    Delay_250ms,1
    DECFSZ  contador10,1,0    ;decrementamos el contador10
    GOTO    continuar
    GOTO    apagar
continuar:
    INCF    valor,1,0        ;incrementamos el valor 
    GOTO    Loop

apagar:
    DECFSZ  contador5,1,0
    GOTO    Reload
    GOTO    salir1
Reload:
    BSF  LATF,3,1
    MOVLW   0x0A	
    MOVWF   contador10,0
    MOVLW   0x00	
    MOVWF   valor,0	     
    GOTO    Loop

parar:
    BCF   PIR6,0,0    ;limpiamos el flag
    MOVF  valor1,0,0  ;movemos el valor1 a W
    MOVWF LATC,1      
    SETF  valor2,0
    GOTO  salir2
   
TABLE:
    ADDWF   PCL,1,0
    RETLW   10000001B	; valor 0
    RETLW   01000010B	; valor 1
    RETLW   00100100B	; valor 2
    RETLW   00011000B	; valor 3
    RETLW   00000000B	; valor 4
    RETLW   00011000B	; valor 5
    RETLW   00100100B	; valor 6
    RETLW   01000010B	; valor 7
    RETLW   10000001B	; valor 8
    RETLW   00000000B	; valor 9
    
    
CONFI_OSC: 
    ;configuracion del oscilador
    BANKSEL OSCCON1
    MOVLW   0x60	;selecccionamos el bloque del oscilador interno con un div:1
    MOVWF   OSCCON1,1
    MOVLW   0x02	;seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
CONFI_PORT:
    ;Configuracion del led
    BANKSEL PORTF   
    CLRF    PORTF,1	;PORTF = 0
    BSF     LATF,3,1	;LATF = 0 -- Leds apagado
    CLRF    ANSELF,1	;ANSELF = 0 -- Digital
    BCF     TRISF,3,1   ;EL RF3 COMO SALIDA
    BSF     TRISF,2,1   ;ACTIVAMOS EL RF2 COMO ENTRADA
    BSF	    WPUF,2,1	;Activo la reistencia Pull-Up EN RF2
    
    ;Configuracion de butom
    BANKSEL PORTA
    CLRF    PORTA,1	;PORTA=0
    CLRF    ANSELA,1	;ANSELA = 0 -- Digital
    BSF	    TRISA,3,1	;TRISA = 1 --> entrada
    BSF	    WPUA,3,1	;Activo la reistencia Pull-Up EN RA3
    
    
    ;Configuracion de PORTC
    BANKSEL PORTC   
    CLRF    PORTC,1	;PORTC = 0
    CLRF    LATC,1	;LATC = 0 -- Leds apagado
    CLRF    ANSELC,1	;ANSELC = 0 -- Digital
    CLRF    TRISC,1    ;CONFIGURAMOS EL PUERTO C COMO SALIDA
    
    ;CONFIGURAR EL PUERTO B
    BANKSEL PORTB
    BSF     PORTB,4,1       ;PORTB=0
    BCF     ANSELB,4,1      ;PORTB COMO DIGITAL
    BSF     TRISB,4,1     ; CONFIGURAMOS COMO ENTRADA RB4
    BSF     WPUB,4,1      ; Activamos la resistencia PULLUP EN RB4
    RETURN 
    
CONFI_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3  
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C 
    MOVWF   INT1PPS,1   ; INT1 --> RB4 
    ;Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1   ; INT2--> RF2 
    RETURN
    
CONFI_INT:
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- habilitar prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 1 -- INT1 de ALTA prioridad
    BSF	IPR10,0,1    ;IPR10<INT2IP> = 1 -- INT2 de ALTA prioridad
     ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext
   
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT1IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT1IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT2EDG> = 0 -- INT2 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT2IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT2IE> = 1 -- habilitamos la interrupcion ext2
    
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
     
    END resetVect



