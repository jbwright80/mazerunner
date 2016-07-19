
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


debug_5blips:
    push r16

    ldi r16, 5
debug_5blips_loop:
    call debug_led_on
    call delay_50ms
    call debug_led_off
    call delay_50ms
    dec r16
    brne debug_5blips_loop

    pop r16
    ret


debug_500msOn:
    call debug_led_on
    call delay_500ms
    call debug_led_off
    ret


debug_check_brownout:
    push r16

    in r16, MCUSR
    sbrs r16, EXTRF
    jmp debug_brownout_fault

    pop r16
    ret

debug_brownout_fault:
    cli
debug_brownout_fault_loop:
    call delay_500ms
    call debug_led_on
    call delay_500ms
    call debug_led_off
    rjmp debug_brownout_fault_loop

