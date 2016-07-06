
debug_init:
    push r16

    in r16, DDRB
    ori r16, 0b00000001
    out DDRB, r16
    in r16, PORTB
    andi r16, 0b11111110
    out PORTB, r16

    pop r16
    ret
    

debug_led_on:
    push r16
    
    in r16, PORTB
    ori r16, 0b00000001
    out PORTB, r16

    pop r16
    ret

debug_led_off:
    push r16
    
    in r16, PORTB
    andi r16, 0b11111110
    out PORTB, r16

    pop r16
    ret

