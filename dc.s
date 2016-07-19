

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
    call delay_50ms

    pop r16
    ret

dc_fire1:
    push r16

    in r16, PORTB
    ori r16, 0b00000100
    out PORTB, r16
    call delay_500ms
    andi r16, 0b11111011
    out PORTB, r16
    call delay_50ms

    pop r16
    ret

dc_fire2:
    push r16

    in r16, PORTB
    ori r16, 0b00001000
    out PORTB, r16
    call delay_500ms
    andi r16, 0b11110111
    out PORTB, r16
    call delay_50ms

    pop r16
    ret

dc_fire3:
    push r16

    in r16, PORTB
    ori r16, 0b00010000
    out PORTB, r16
    call delay_500ms
    andi r16, 0b11101111
    out PORTB, r16
    call delay_50ms

    pop r16
    ret

dc_fire4:
    push r16

    in r16, PORTB
    ori r16, 0b00010000
    out PORTB, r16
    call delay_500ms
    andi r16, 0b11101111
    out PORTB, r16
    call delay_50ms

    pop r16
    ret

dc_fire5:
    push r16

    in r16, PORTB
    ori r16, 0b00100000
    out PORTB, r16
    call delay_500ms
    andi r16, 0b11011111
    out PORTB, r16
    call delay_50ms

    pop r16
    ret

dc_fire6:
    push r16

    in r16, PORTB
    ori r16, 0b01000000
    out PORTB, r16
    call delay_500ms
    andi r16, 0b10111111
    out PORTB, r16
    call delay_50ms

    pop r16
    ret

dc_fire7:
    push r16

    in r16, PORTB
    ori r16, 0b10000000
    out PORTB, r16
    call delay_500ms
    andi r16, 0b01111111
    out PORTB, r16
    call delay_50ms

    pop r16
    ret
