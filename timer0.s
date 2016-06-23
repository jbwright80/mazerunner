; The Timer 0 module is configured to run in 'Normal' mode where it will manage a flag and separate counter in memory.
; It is used as a timeout for incoming packets on the USART.
; The flag will have 3 states: 0=stopped, 1=running, 2=timeout.

; The timer is started when a character is received from the USART while in state=stopped.
; the timer will be set to state=running, and an index variable for an 8-byte buffer will be maintained.
; When started, the timer will count to ~133.3 msec (2x round-trip time for 8 bytes across 8 nodes at 9600 buad.)
; As each byte comes in, the index will be incremented and the buffer will be populated.
; When the 8th byte is received, the timer is set to state=stopped, and a call can be made to handle the complete packet. Ensure fault light is clear
; If the timeout period is allowed to elapse, the timer will be stopped and enter state=timeout. Turn on fault light
; If a byte comes in with state=timeout, the timer will be restarted, index=0, and that byte is placed at the beginning of the packet buffer.

.include "m644pa.inc"

; **** DATA ****
.data

; This counter will allow for a count of decimal value 30; representing ~133.3 msec
; The counter will increment upon overflow interrupt; @ 14.7456 Mhz with f/256
timer0_counter:
    .byte 0

; The timer flag for storing the state values.
timer0_flag:
    .byte 0

; **** TEXT ****
.text


; Initialize Timer0 peripheral, but do not start the timer.
timer0_init:
    ; Enable overflow interrupt
    ldi r16, (1 << TOIE0)
    sts TIMSK0, r16

    ; Mode 0: Normal Mode
    ldi r16, (0 << WGM01) | (0 << WGM00)
    out TCCR0A, r16
    ldi r16, (0 << WGM02) | (0 << CS02) | (0 << CS01) | (0 << CS00)  ; no clock source / timer0 off
    out TCCR0B, r16

    ; initialize sram
    sts timer0_counter, r0
    sts timer0_flag, r0

    ret

timer0_start:
    push r16

    ; clear counter variable and set flag=running
    sts timer0_counter, r0
    sts timer0_flag, r1

    ; start the counter, f/256
    ldi r16, (1 << CS02) | (0 << CS01) | (0 << CS00)
    out TCCR0B, r16

    pop r16
    ret

timer0_halt:
    ; Disable Timer0
    out TCCR0A, r0
    out TCCR0B, r0
    sts timer0_flag, r0 ; (stopped)

    ret


; *********************************
; *** Timer0 Overflow Interrupt ***
;

; r20: counter
; r21: flag

vect_TIMER0_OVF:

    cli ; disable global interrupts
    ; load in sram variables
    lds r20, timer0_counter
    lds r21, timer0_flag

    ; first check to see if we have hit 30 counts (~133.3 msec)
    ldi r16, 30
    cp r20, r16
    brne vect_TIMER0_OVF_keep_counting
        ; we have hit 30; timeout has occurred.
        ; stop the timer, reset counts to 0, set flag=timeout
        clr r20
        ldi r21, 2
        rcall timer0_halt ; stop timer0
        rjmp vect_TIMER0_OVF_done
    vect_TIMER0_OVF_keep_counting:
        ; we have not hit 30, keep counting
        inc r20

vect_TIMER0_OVF_done:

    ; store sram variables
    sts timer0_counter, r20
    sts timer0_flag, r21
    sei ; enable global interrupts again

    reti
