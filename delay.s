
delay_500ms:
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
    ret
    