
; Mapping:
; CH1 -> PC0
; CH2 -> PC1
; CH3 -> PC2
; CH4 -> PC3
; CH5 -> PC4
; CH6 -> PC5
; CH7 -> PC6
; CH8 -> PC7

; All of port C has been reserved for digital input
input_init:
    out DDRC, r0
    ret


; Read the input board, channels 1 & 2 and return the result in r16
input_read_switches:
    in r16, PINC
    com r16
    andi r16, 0b00000011
    ret
