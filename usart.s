
.include "m644pa.inc"

.text

;
; USART0 Receive complete vector handler
;
vect_USART0_RX:

    ; A character has been received, check the state of the timer0 module
    
    reti


;
; USART0 Initialization
;

usart_init:

    ; Set baud rate to 9600
    ldi r16, 0
    ldi r17, 7
    sts UBRR0H, r16
    sts UBRR0L, r17
    
    ; Enable transmitter & receiver, enable RX Complete interrupt
    ldi r17, (1 << TXEN0) | (1 << RXEN0) | (1 << RXCIE0)
    sts UCSR0B, r17
    
    ; Set frame format: 8 data bits, 1 stop bit, no parity.
    ldi r17, (1 << UCSZ01) | (1 << UCSZ00)
    sts UCSR0C, r17
    
    ret

;
; USART Transmit packet routine
;

usart_send_packet:
    ldi r16, 8                               ; 8 bytes to send
    ldi r26, lo8(packet_buffer)        ; set index register to the packet buffer
    ldi r27, hi8(packet_buffer)
    
usart_wait_until_ready:                      ; loop until Data Register Empty flag is set
    lds r17, UCSR0A                          ; while clear, data transmission is already in progress
    sbrs r17, UDRE0
    rjmp usart_wait_until_ready
    
    dec r16
    cpi r16, 0
    brne usart_continue
    ret
    
usart_continue:

    ld r18, X+                               ; read next byte in buffer    
    sts UDR0, r18                            ; store to USART data register (initiates transmit)
    rjmp usart_wait_until_ready
    

;
; getc - block and wait for a character, result placed in r16 
;
usart_getc:
    
    lds r16, UCSR0A    
    sbrs r16, RXC0
    rjmp usart_getc
    lds r16, UDR0

    ret    
    
    
    