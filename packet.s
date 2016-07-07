
.include "m644pa.inc"

.data

packet_index:
    .byte 0

packet_buffer:
    .byte 0, 0, 0, 0, 0, 0, 0, 0

.text

packet_init_buffer:
    push r16
    push r26
    push r27

    ldi r26, lo8(packet_buffer)
    ldi r27, hi8(packet_buffer)
    ldi r16, 8
packet_init_buffer_loop:
    ldi r25, 0x0
    st X+, r25
    dec r16
    brne packet_init_buffer_loop

    ; zero the packet index offset
    sts packet_index, r0

    pop r27
    pop r26
    pop r16
    ret


; Update the current packet buffer with a freshly calculated checksum.
packet_calc_checksum:
    push r16
    push r17
    push r18
    push r26
    push r27

    ldi r26, lo8(packet_buffer)
    ldi r27, hi8(packet_buffer)
    ldi r16, 7
    clr r17
packet_calc_checksum_loop:
    ld r18, X+
    add r17, r18
    dec r16
    brne packet_calc_checksum_loop
    neg r17 ; two's compliment
    st X, r17

    pop r27
    pop r26
    pop r18
    pop r17
    pop r16
    ret


; Packet Insertion
; handling incoming bytes from the USART: (placed in r16)
; first check to see if the receive timer is running
; if it isn't, start it, reset index to 0, and insert byte
; if it is, check to see if it has expired.
;     if the timer has expired, reset index to 0, insert byte
;     otherwise, get the index, and insert byte
;
; r16 incoming usart byte
; r17 timer flag
; r18 packet index offset

packet_insert:
    push r17
    push r18
    push r26
    push r27

    lds r18, packet_index

    ; when starting out at index 0, make sure the first byte is 0xAA.
    cp r18, r0
    brne packet_insert_start_skip
    cpi r16, 0xAA
    brne packet_insert_exit ; First byte of frame isn't 0xAA, ignore byte.
packet_insert_start_skip:

    ; write packet buffer address + offset to X register
    ldi r26, lo8(packet_buffer)
    ldi r27, hi8(packet_buffer)
    add r26, r18
    adc r27, r0
    st X, r16                 ; store byte
    inc r18                   ; increment offset
    cpi r18, 8                ; end of array
    brne packet_insert_cont

    ; *** Complete Packet ***
    clr r18                   ; roll index back to zero
    call packet_validate
    cp r16, r0
    brne packet_insert_cont   ; invalid packet, do nothing further.

    ; Determine what to do with the packet
    call logic_process_packet

packet_insert_cont:
    sts packet_index, r18

packet_insert_exit:
    pop r27
    pop r26
    pop r18
    pop r17
    ret







; Validate packet checksum; calculate and compare packet in buffer with existing checksum
; returns non-zero upon failure in r16
; r17 - summing reg
; r18 - temp byte from sram
; r19 - bytes to process (7)
packet_validate:
    push r17
    push r18
    push r19
    push r26
    push r27

    clr r17 ; clear the sum
    ldi r19, 7 ; 7 bytes to process
    ldi r26, lo8(packet_buffer) ; start summing at packet_buffer
    ldi r27, hi8(packet_buffer)

packet_validate_loop:
    ld r18, X+ ; load byte, inc pointer
    add r17, r18 ; add it to sum
    dec r19 ; next byte
    brne packet_validate_loop
    ; done

    ld r20, X+ ; next byte read is checksum
    neg r17 ; two's compliment
    cp r17, r20
    brne packet_validate_fail
    ; comparison matched, return success
    mov r16, r0
    rjmp packet_validate_exit

packet_validate_fail:
    mov r16, r1

packet_validate_exit:
    pop r27
    pop r26
    pop r19
    pop r18
    pop r17
    ret




;
; Transmit packet
;

packet_transmit:
    push r16
    push r17
    push r18
    push r26
    push r27

    ldi r16, 8                               ; 8 bytes to send
    ldi r26, lo8(packet_buffer)              ; set index register to the packet buffer
    ldi r27, hi8(packet_buffer)

packet_transmit_wait_until_ready:            ; loop until Data Register Empty flag is set
    lds r17, UCSR0A                          ; while clear, data transmission is already in progress
    sbrs r17, UDRE0
    rjmp packet_transmit_wait_until_ready

    ld r18, X+                               ; read next byte in buffer
    sts UDR0, r18                            ; store to USART data register (initiates transmit)
    dec r16
    brne packet_transmit_wait_until_ready

    pop r27
    pop r26
    pop r18
    pop r17
    pop r16
    ret


; Increment packet hop count
packet_inc_hop:
    push r16

    lds r16, packet_buffer + 6
    inc r16
    sts packet_buffer + 6, r16

    pop r16
    ret

; modify buffer to acknowledge reception and handling of packet addressed to master
packet_ack:
    ; Set index to Ack byte in packet buffer
    sts packet_buffer + 5, r1
    ret


; Modify buffer to negatively acknowledge reception and handling of packet addressed to master
packet_nak:
    push r16

    ldi r16, 1                   ; Node Number (Master)
    sbr r16, 0b10000000          ; MSB set for negative ack
    sts packet_buffer + 5, r16

    pop r16
    ret
