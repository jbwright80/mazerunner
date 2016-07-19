
.text

; Read the 2 switches and determine if we're in manual mode or not. If in Automatic mode, we wait for the gate select packet from the controller.
; Manual mode is assumed when the value of the switches is greater than zero, and the gate to be left open is determined as follows:
; SW2  SW1
; OFF  OFF   Automatic mode
; OFF   ON   Left Gate
;  ON  OFF   Middle Gate
;  ON   ON   Right Gate

logic_process_switches:
    push r16
    push r17

    call input_read_switches ; value of switches in r16
    mov r17, r16 ; make a copy of the switch value for later
    cpi r16, 0
    brne logic_process_switches_manual
    ; automatic mode
    rjmp logic_process_switches_skip


    logic_process_switches_manual:
    ; determine which gates to shut

    ; Left Gate
    logic_process_switches_check1:
    cpi r16, 1
    brne logic_process_switches_check2
    ; Left gate selected, close middle and right gate
    call dc_fire1
    call dc_fire2
    rjmp logic_process_switches_done

    ; Middle Gate
    logic_process_switches_check2:
    cpi r16, 2
    brne logic_process_switches_check3
    ; Middle gate selected, close left and right gate
    call dc_fire0
    call dc_fire2
    rjmp logic_process_switches_done

    ; Right Gate
    logic_process_switches_check3:
    cpi r16, 3
    brne logic_process_switches_done
    ; Right gate selected, close left and middle gate
    call dc_fire0
    call dc_fire1

    logic_process_switches_done:

    ; Gates have been set, send reset packet and all start
    ldi r16, 0
    call inject_reset
    call delay_200ms

    call inject_freq_select ; r17 containing switch value from earlier
    call delay_200ms

    call inject_all_start

    logic_process_switches_skip:

    pop r17
    pop r16
    ret


; In this routine we examine an incoming packet and decide what to do about it
logic_process_packet:
    push r16
    push r17

    ; ****
    ; Check if this is a reset packet from the Controller
    ; ****
    lds r16, packet_buffer + 2
    cpi r16, 0x10
    brne logic_process_packet_is_gate_select

    ; reset packet received from controller:
    ; set address to global, command to reset, reset hop count, re-send then reset
    ldi r16, 0
    sts packet_buffer + 2, r16        ; (Command byte)
    sts packet_buffer + 1, r16        ; (Address)
    sts packet_buffer + 6, r16        ; (Hop Count)
    call packet_calc_checksum
    call packet_transmit

    ;jmp vect_RESET
    rjmp logic_process_packet_done


    ; ****
    ; Check if this is a gate & frequency select packet
    ; ****
logic_process_packet_is_gate_select:
    lds r16, packet_buffer + 2
    cpi r16, 0x11
    brne logic_process_packet_is_cart_negotiation


    ; First determine which frequency to use, and inform nodes 4 & 5
    lds r17, packet_buffer + 3 ; get gate selection from arg1 and save for later
    lds r16, packet_buffer + 4 ; get frequency selection from arg2
    sts packet_buffer + 3, r16 ; put frequency selection in arg1
    sts packet_buffer + 4, r0  ; clear arg2
    ldi r16, 0x04                     ; Select "Configure Frequency" command
    sts packet_buffer + 2, r16        ; (Command byte)
    ldi r16, 0                        ; Reset hop count
    sts packet_buffer + 6, r16        ; (Hop Count)
    ldi r16, 4                        ; Address node #4
    sts packet_buffer + 1, r16        ; (Address)
    call packet_calc_checksum
    call packet_transmit

    ldi r16, 5                        ; Modify packet to also address node #5
    sts packet_buffer + 1, r16        ; (Address)
    call packet_calc_checksum
    call packet_transmit

    ; Modify packet to send an "All Start" to everyone
    sts packet_buffer + 1, r0         ; Broadcast address in Address byte
    ldi r16, 2                        ; "All Start" command byte
    sts packet_buffer + 2, r16        ;
    sts packet_buffer + 3, r0         ; Clear arg1
    call packet_calc_checksum
    call packet_transmit


    ; Finally, determine which gates to close
    ; Fire if left gate bit set
    sbrc r17, 0
    call dc_fire0
    ; Fire if middle gate bit set
    sbrc r17, 1
    call dc_fire1
    ; Fire if right gate bit set
    sbrc r17, 2
    call dc_fire2

    rjmp logic_process_packet_done


logic_process_packet_is_cart_negotiation:
    lds r16, packet_buffer + 2
    cpi r16, 0x80
    brne logic_process_packet_done

    ; We've received a cart negotiation packet: first confirm reception by incrementing hop count, and send it along
    call packet_inc_hop
    call packet_calc_checksum
    call packet_transmit

    ; Now lets examine what to do with it.

    ; First check if the packet received is from node 2, if successful, fire solenoid, else do nothing
    ; Node number is given in arg1, status in arg2
    lds r16, packet_buffer + 3
    cpi r16, 2
    brne logic_process_packet_is_cart_negotiation_check_node3
    ; It's node 2, was this a successful exchange?
    lds r16, packet_buffer + 4
    sbrc r16, 0
    call dc_fire3 ; if status 1, fire solenoid 3
    rjmp logic_process_packet_done ; all done

    ; Wasnt node 2, lets see if it was node 3.
    logic_process_packet_is_cart_negotiation_check_node3:
    lds r16, packet_buffer + 3
    cpi r16, 3
    brne logic_process_packet_is_cart_negotiation_check_last3
    ; It's node 3, was this a successful exchange?
    lds r16, packet_buffer + 4
    sbrc r16, 0
    call dc_fire4 ; if status 1, fire solenoid 4
    rjmp logic_process_packet_done ; all done


    ; Wasn't node 3, lets see if it was one of the last 3 receivers (6, 7 & 8)
    logic_process_packet_is_cart_negotiation_check_last3:
    cpi r16, 6
    breq logic_process_packet_is_cart_negotiation_check_last3_true
    cpi r16, 7
    breq logic_process_packet_is_cart_negotiation_check_last3_true
    cpi r16, 8
    breq logic_process_packet_is_cart_negotiation_check_last3_true
    ; nope, wasnt one of the last 3, move on.
    rjmp logic_process_packet_is_cart_negotiation_check_last3_false
    logic_process_packet_is_cart_negotiation_check_last3_true:
    ; Response from one of the last 3 receivers: send an all stop; we're done.
    call inject_all_stop
    rjmp logic_process_packet_done ; all done

    logic_process_packet_is_cart_negotiation_check_last3_false:
    ; We move on to any further packet processing.

    ; ...

    ; Done packet processing.

logic_process_packet_done:
    pop r17
    pop r16
    ret
