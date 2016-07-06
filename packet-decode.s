
.include "m644pa.inc"

.text

; If this is a reset packet from Controller, return 1 in r16, 0 otherwise
; Assuming packet is for master
decode_is_reset:
    lds r16, packet_buffer + 2
    cpi r16, 10
    brne decode_is_reset_not
    mov r16, r1
    ret    
decode_is_reset_not:
    mov r16, r0
    ret

; If this is a Gate select packet from Controller, return 1 in r16, 0 otherwise
; Assuming packet is for master
decode_is_gatesel:
    lds r16, packet_buffer + 2
    cpi r16, 11
    brne decode_is_gatesel_not
    mov r16, r1
    ret    
decode_is_gatesel_not:
    mov r16, r0
    ret

    
