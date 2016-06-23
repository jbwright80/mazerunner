.include "m644pa.inc"

.text

vectors:
jmp vect_RESET       ; vect_RESET          ; External Pin, Power-on Reset, Brown-out Reset,
jmp vect_UNDEFINED   ; vect_INT0           ; External Interrupt Request 0
jmp vect_UNDEFINED   ; vect_INT1           ; External Interrupt Request 1
jmp vect_UNDEFINED   ; vect_INT2           ; External Interrupt Request 2
jmp vect_UNDEFINED   ; vect_PCINT0         ; Pin Change Interrupt Request 0
jmp vect_UNDEFINED   ; vect_PCINT1         ; Pin Change Interrupt Request 1
jmp vect_UNDEFINED   ; vect_PCINT2         ; Pin Change Interrupt Request 2
jmp vect_UNDEFINED   ; vect_PCINT3         ; Pin Change Interrupt Request 3
jmp vect_UNDEFINED   ; vect_WDT            ; Watchdog Time-out Interrupt
jmp vect_UNDEFINED   ; vect_TIMER2_COMPA   ; Timer/Counter2 Compare Match A
jmp vect_UNDEFINED   ; vect_TIMER2_COMPB   ; Timer/Counter2 Compare Match B
jmp vect_UNDEFINED   ; vect_TIMER2_OVF     ; Timer/Counter2 Overflow
jmp vect_UNDEFINED   ; vect_TIMER1_CAPT    ; Timer/Counter1 Capture Event
jmp vect_UNDEFINED   ; vect_TIMER1_COMPA   ; Timer/Counter1 Compare Match A
jmp vect_UNDEFINED   ; vect_TIMER1_COMPB   ; Timer/Counter1 Compare Match B
jmp vect_UNDEFINED   ; vect_TIMER1_OVF     ; Timer/Counter1 Overflow
jmp vect_UNDEFINED   ; vect_TIMER0_COMPA   ; Timer/Counter0 Compare Match A
jmp vect_UNDEFINED   ; vect_TIMER0_COMPB   ; Timer/Counter0 Compare match B
jmp vect_TIMER0_OVF  ; vect_TIMER0_OVF     ; Timer/Counter0 Overflow
jmp vect_UNDEFINED   ; vect_SPI_STC        ; SPI Serial Transfer Complete
jmp vect_USART0_RX   ; vect_USART0_RX      ; USART0 Rx Complete
jmp vect_UNDEFINED   ; vect_USART0_UDRE    ; USART0 Data Register Empty
jmp vect_UNDEFINED   ; vect_USART0_TX      ; USART0 Tx Complete
jmp vect_UNDEFINED   ; vect_ANALOG_COMP    ; Analog Comparator
jmp vect_UNDEFINED   ; vect_ADC            ; ADC Conversion Complete
jmp vect_UNDEFINED   ; vect_EE_READY       ; EEPROM Ready
jmp vect_UNDEFINED   ; vect_TWI            ; 2-wire Serial Interface
jmp vect_UNDEFINED   ; vect_SPM_READY      ; Store Program Memory Ready

vect_UNDEFINED:
    reti

vect_RESET:

; global defaults
    clr r0         ; r0 will always contain 0
    mov r1, r0
    inc r1         ; r1 will always contain 1

; clear CPU status register
    out SREG, r0

; setup stack pointer
    ldi r16, lo8(RAMEND)
    out SPL, r16
    ldi r16, hi8(RAMEND)
    out SPH, r16


main:
    ; use bit 0 of port c as led output
    ; led starts out as being off
    out DDRC, r1
    out PORTC, r0

    call usart_init
    call timer0_init
    call packet_init_buffer
    call usart_ack

    ; Enable global interrupts after everything is initialized
    sei


main_loop:
    rjmp main_loop
