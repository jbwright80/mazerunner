

; Setup DC output ports on board for solenoids

; Port mappings:
;
; DC0 -> PB1
; DC1 -> PB2
; DC2 -> PB3
; DC3 -> PB4
; DC4 -> PD4
; DC5 -> PD5
; DC6 -> PD6
; DC7 -> PD7

dc_init:
    push r16

    ldi r16, 0b00011110
    out DDRB, r16
    out PORTB, r0
    ldi r16, 0b11110000
    out DDRD, r16
    out PORTD, r0

    pop r16
    ret

dc_fire0:
    push r16

    in r16, PORTB
    ori r16, 0b00000010
    out PORTB, r16
    call delay_500ms
    andi r16, 0b11111101
    out PORTB, r16

    pop r16
    ret

