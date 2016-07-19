
.include "m644pa.inc"

.text


; Is the packet addressed to the master? r16=1 if true, 0 otherwise
decode_is_for_me:
    lds r16, packet_buffer + 1
    cpi r16, 1
    brne decode_is_for_me_not
    ret
decode_is_for_me_not:
    clr r16
    ret


; Has incoming packet exceeded max hop count? r16=1 if true, 0 otherwise
decode_check_max_hopcount:
    lds r16, packet_buffer + 6
    subi r16, 8 ; Eight active nodes in ring
    brsh decode_check_max_hopcount_true
    clr r16
    ret
decode_check_max_hopcount_true:
    mov r16, r1
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

    
