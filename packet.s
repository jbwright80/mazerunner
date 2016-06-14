
.include "m644pa.inc"

.data

packet_buffer:
    .byte 0, 0, 0, 0, 0, 0, 0, 0

packet_index:
    .byte 0
    
.text

; Packet Insertion
; handling incoming bytes from the USART:
; first check to see if the receive timer is running
; if it isn't, start it, reset index to 0, and insert byte
; if it is, check to see if it has expired.
;     if the timer has expired, reset index to 0, insert byte
;     otherwise, get the index, and insert byte
;

packet_insert:
    ret
