
delay_500ms:
    push r18
    push r19
    push r20

    ldi  r18, 38
    ldi  r19, 103
    ldi  r20, 245
delay_500ms_L1:
    dec  r20
    brne delay_500ms_L1
    dec  r19
    brne delay_500ms_L1
    dec  r18
    brne delay_500ms_L1
    nop

    pop r20
    pop r19
    pop r18
    ret
