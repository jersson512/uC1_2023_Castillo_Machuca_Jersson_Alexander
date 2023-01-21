;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
; 
;AUTOR: Jersson Alexander Castillo Machuca
;DATE:  11/01/2023
;PRACTICA:  P1-display_7 seg
;DESCRIPCION: Este codigo permite la visualizacion de numeros en un display
	; 7 seg, numeros del 0 al 9 de forma ascendente y cuando presionas el
	;boton se visualiza las letras del A al F.
	; Trabajamos con una Frecuencia de 4MHz y TCY = 1us.
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
#include "bits_cconfigj.inc"
#include <xc.inc>
#include "retardosj.inc"
    
PSECT resetVect, class=code, reloc=2
resetVect: 
    goto Main

PSECT code
Main:
    CALL confi_osc2,1
    CALL confi_port2,1
boton:
    BTFSC   PORTA,3,0      ; boton presionado?
    goto    valores_numeros ; si el boton no se presiono se ejecuta esta instru.
valores_letras:
 
  Letra_A:
    MOVLW   00001000B   ; cargamos el valor de A en binario
    MOVWF   0x500,a     ; cargamos el valor de w al registro 0x500
    BANKSEL PORTD
    MOVWF   PORTD,1      ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0      ; boton presionado?
    goto valores_numeros   ; si el boton no se presiono se ejecuta esta instru.
  Letra_B:
    MOVLW   00000011B     ; cargamos el valor de B en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1       ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0     ; boton presionado?
    goto    valores_numeros ; si el boton no se presiono se ejecuta esta instru.
  Letra_C:
    MOVLW   01000110B    ; cargamos el valor de c en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1       ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0      ; boton presionado?
    goto    valores_numeros ; si el boton no se presiono se ejecuta esta instru.
  Letra_D:                  
    MOVLW   00100001B       ; cargamos el valor de D en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1       ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0     ; boton presionado?
    goto valores_numeros  ; si el boton no se presiono se ejecuta esta instru.
  Letra_E:
    MOVLW   00000110B     ; cargamos el valor de E en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1      ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0     ; boton presionado?
    goto valores_numeros  ; si el boton no se presiono se ejecuta esta instru.
  Letra_F:
    MOVLW   00001110B     ; cargamos el valor de F en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1        ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1 
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0     ; boton presionado?
    goto    valores_numeros ; si el boton no se presiono se ejecuta esta instru.
    goto    Letra_A  ;si el boton se presiono 
  
valores_numeros:
 
  Numero_0:
    MOVLW   11000000B    ; cargamos el valor de 0 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto valores_letras
  Numero_1:
    MOVLW   11111001B      ; cargamos el valor de 1 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1        ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0     ; boton presionado?
    goto valores_letras  ; si el boton no se presiono se ejecuta esta instru.
  Numero_2:  ;si el boton se presiono 
    MOVLW   10100100B        ; cargamos el valor de 2 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1       ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0     ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
  Numero_3:               ;si el boton se presiono 
    MOVLW   10110000B
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1         ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0    ; boton presionado?
    goto valores_letras  ; si el boton no se presiono se ejecuta esta instru.
  Numero_4:
    MOVLW   10011001B     ; cargamos el valor de 3 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0     ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
  Numero_5:               ;si el boton se presiono 
    MOVLW   10010010B     ; cargamos el valor de 5 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0     ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
  Numero_6:               ;si el boton se presiono 
    MOVLW   10000010B     ; cargamos el valor de 6 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
   BTFSS   PORTA,3,0      ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
  Numero_7:               ; si el boton se presiono se ejecuta esta instru.
    MOVLW   11111000B     ; cargamos el valor de 7 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0     ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
  Numero_8:               ; si el boton se presiono se ejecuta esta instru.
    MOVLW   10000000B     ; cargamos el valor de 8 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
   BTFSS   PORTA,3,0      ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
  Numero_9:               ; si el boton se presiono se ejecuta esta instru.
    MOVLW   10011000B     ; cargamos el valor de 9 en binario
    MOVWF   0x500,a
    BANKSEL PORTD
    MOVWF   PORTD,1      ; movemos el valor de w al puerto D
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0     ; boton presionado?
    goto valores_letras   ; si el boton no se presiono se ejecuta esta instru.
    goto    Numero_0      ; si el boton se presiono se ejecuta esta instru.

    ;configuramos el oscilador interno de 4 Mhz
confi_osc2:  
    BANKSEL OSCCON1
    MOVLW   0x60 
    MOVWF   OSCCON1,1
    MOVLW   0x02 
    MOVWF   OSCFRQ,1
    RETURN
    
confi_port2:
    ; Conf. de puertos para los leds de corrimiento
    BANKSEL PORTD   
    CLRF    PORTD,1	;PORTC=0
    CLRF    LATD,1	;LATC=1, Leds apagado
    CLRF    ANSELD,1	;ANSELC=0, Digital
    CLRF    TRISD,1     ;puerto  D como salidas
    ;confi button
    BANKSEL PORTA
    CLRF    PORTA,1	;
    CLRF    ANSELA,1	;ANSELA=0, Digital
    BSF	    TRISA,3,1	; TRISA=1 -> entrada
    BSF	    WPUA,3,1	;Activo la reistencia Pull-Up
    RETURN      
    
END resetVect
   




