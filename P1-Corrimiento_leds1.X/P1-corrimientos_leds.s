;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
; 
;AUTOR: Jersson Alexander Castillo Machuca
;DATE:  11/01/2023
;PRACTICA:  P1-corrimiento_leds
;DESCRIPCION: Este codigo permite el corrimiento de leds conectados al puerto C, con
	;un retardo de 500 ms en un numero de corrimientos pares
	;y un retardo de 250ms en un numero de corrimientos impares.
	;El corrimiento inicia cuando se presiona el pulsador de la placa
	;una vez y se captura cuando se vuelve a presionar, la cual trabajamos
	;con una Frecuencia de 4MHz y TCY = 1us.
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
PROCESSOR 18F57Q84
#include "bits_configuracion.inc"
#include <xc.inc>
#include "retardos.inc"

PSECT resetVect, class=code, reloc=2
resetVect: 
    GOTO Main

PSECT code
Main:
  CALL confi_osc,1
  CALL confi_port,1 
 OPEN:
    BTFSC   PORTA,3,0; boton presionado?
    GOTO    APAGADO_INICIAL  ; si el boton no se presiono se ejecuta esta instru.
  Leds_on_pares: ;si el boton se presiono se ejecuta esta instruccion
    BCF     LATE,0,1   ;apagamos leds que señala el corrimiento impar
    MOVLW   1
    MOVWF   0X502,a
   LOPP:
    ;BANKSEL 0X5h
    RLNCF   0x502,f,a
    MOVF    0X502,w,a
    BANKSEL PORTC      
    MOVWF   PORTC,1        ; movemos el valor de w al puerto c
    BSF     LATE,1,1       ; prendemos el led que señala el corrimiento par
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0      ; boton presionado?
    GOTO    Continua_par   ; si el boton no se presiono
    GOTO    PARE_1         ; si el boton se presiono
   Continua_par:
    BTFSC   0x502,7,0      ; verifica si el bit 7 del registro 0x502 es 0?
    GOTO    Led_on_impar   ; si el bit 7 del registro 0x502 es 1
    RLNCF   0x502,f,a      ; si el bit 7 del registro 0x502 es 0,empieza a rotar
    MOVF    0X502,w,a
    ;BTFSC   PORTA,3,0; si preionamos PORA=0
    GOTO    LOPP
    ;GOTO    PARE_1
    
  Led_on_impar:
    BCF     LATE,1,1   ;apagamos el leds que señala el corrimiento par
    MOVLW   1
    MOVWF   0X502,a
   LOPP2:
    BANKSEL PORTC
    MOVWF   PORTC,1   ; movemos el valor de w al puerto c
    BSF     LATE,0,1  ;prendemos el led que señala el corrimento impar
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0; boton presionado?
    GOTO    Continua_impar   ;si no se presiono
    GOTO    PARE_2           ; si se presiono
   Continua_impar:
    BTFSC   0x502,6,0     ; verifica si el bit 6 del registro 0x502 es 0?
    GOTO    Leds_on_pares ; si el bit 6 del registro 0x502 es 1
    RLNCF   0x502,f,a     ; si el bit 6 del registro 0x502 es 0,rota izquierda
    RLNCF   0x502,f,a     ;rota a la izquierda los bits del registro
    MOVF    0X502,w,a     ;movemos el valor del registro al w
    ;BTFSC   PORTA,3,0; si preionamos PORA=0
    GOTO    LOPP2
    ;GOTO    PARE_2
    
APAGADO_INICIAL:
    CLRF    PORTC,1
    GOTO    OPEN
    
PARE_1:
   RETARDO:
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
   CAPTURA:
    MOVF    0X502,w,a
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,1,1
    BTFSC   PORTA,3,0     ;boton presionado?
    GOTO    CAPTURA       ; si el boton no se presiono ejecuta esta instruccion
    GOTO    Continua_par  ; si el boton se presiono ejecuta esta instruccion
   
PARE_2:
   RETARDO2:
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
   CAPTURA2: 
    MOVF    0X502,w,a
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,0,1
    BTFSC   PORTA,3,0   ;boton presionado?
    GOTO    CAPTURA2      ;si el boton no se presiono ejecuta esta instruccion
    GOTO    Continua_impar ;si el boton se presiono ejecuta esta instruccion
    
;configuramos el oscilador interno de 4 Mhz
confi_osc:          
    BANKSEL OSCCON1
    MOVLW   0x60 
    MOVWF   OSCCON1,1
    MOVLW   0x02 
    MOVWF   OSCFRQ,1
    RETURN
    
confi_port:
    ; Conf. de puertos para los leds de corrimiento
    BANKSEL PORTC   
    CLRF    PORTC,1	;PORTC=0
    CLRF    LATC,1	;LATC=0, Leds apagado
    CLRF    ANSELC,1	;ANSELC=0, Digital
    CLRF    TRISC,1	;Todos salidas 
    ; Conf. de leds para visualizar cuando se da el corrimiento par o impar.
    BANKSEL PORTE   
    CLRF    PORTE,1	;PORTC=0
    BCF     LATE,0,1	;LATC=1, Leds apagado
    BCF     LATE,1,1
    CLRF    ANSELE,1	;ANSELC=0, Digital
    CLRF    TRISE,1	;Todos salidas 
    ;confi butom
    BANKSEL PORTA
    CLRF    PORTA,1	;
    CLRF    ANSELA,1	;ANSELA=0, Digital
    BSF	    TRISA,3,1	; TRISA=1 -> entrada
    BSF	    WPUA,3,1	;Activo la reistencia Pull-Up
    return
    END resetVect






