
.include "m644pa.inc"

.text

;
; USART1 Receive complete vector handler
;
; Receive Complete RXC1 flag (in UCSRnA) is high when unread data is present in the receive buffer.
;

vect_USART1_RX:

    ; A character has been received, place it in r16 and call packet handling routine
    lds r16, UDR1
    call packet_insert

    reti

;
; USART Initialization
;

usart_init:

    ; Set baud rate to 9600
    ldi r16, 0
    ldi r17, 95
    sts UBRR0H, r16
    sts UBRR0L, r17
    sts UBRR1H, r16
    sts UBRR1L, r17

    ; Enable transmitter & receiver for USART0
    ldi r17, (1 << TXEN0) | (1 << RXEN0) | (1 << RXCIE0)
    sts UCSR0B, r17
    ; Enable transmitter & receiver, enable RX Complete interrupt for USART1
    ldi r17, (1 << TXEN1) | (1 << RXEN1) | (1 << RXCIE1)
    sts UCSR1B, r17

    ; Set frame format: 8 data bits, 1 stop bit, no parity.
    ldi r17, (1 << UCSZ11) | (1 << UCSZ10)
    sts UCSR0C, r17
    sts UCSR1C, r17

    ret




;
; getc - block and wait for a character, result placed in r16
;
usart_getc:

    lds r16, UCSR1A
    sbrs r16, RXC1
    rjmp usart_getc
    lds r16, UDR1

    ret


;
; putc - wait until USART available, then output raw character in r16
;
usart_putc:
    push r17

usart_putc_wait:
    lds r17, UCSR1A       ; while clear, data transmission is already in progress
    sbrs r17, UDRE1
    rjmp usart_putc_wait
    sts UDR1, r16         ; store to USART data register (initiates transmit)

    pop r17
    ret

usart_ack:
    ldi r16, 0x41 ; A
    rcall usart_putc
    ldi r16, 0x63 ; c
    rcall usart_putc
    ldi r16, 0x6b ; k
    rcall usart_putc
    ldi r16, 0x0d
    rcall usart_putc
    ldi r16, 0x0a
    rcall usart_putc
    ret

usart_nak:
    ldi r16, 0x4e ; N
    rcall usart_putc
    ldi r16, 0x61 ; a
    rcall usart_putc
    ldi r16, 0x6b ; k
    rcall usart_putc
    ldi r16, 0x0d
    rcall usart_putc
    ldi r16, 0x0a
    rcall usart_putc
    ret
