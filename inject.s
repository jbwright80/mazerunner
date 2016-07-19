
; Address in r16
inject_reset:
    push r17
    call packet_new    
    
    ; Address
    sts packet_buffer+1, r16
    
    ; Reset
    ldi r17, 0
    sts packet_buffer+2, r17
    
    call packet_calc_checksum
    call packet_transmit
    
    pop r17
    ret


; Address in r16
inject_all_stop:
    push r17
    call packet_new    
    
    ; Address
    sts packet_buffer+1, r16
    
    ; All stop command
    ldi r17, 1
    sts packet_buffer+2, r17
    
    call packet_calc_checksum
    call packet_transmit
    
    pop r17
    ret


; Address in r16
inject_all_start:
    push r17
    call packet_new    
    
    ; Address
    sts packet_buffer+1, r16
    
    ; All start command
    ldi r17, 2
    sts packet_buffer+2, r17
    
    call packet_calc_checksum
    call packet_transmit
    
    pop r17
    ret


    
; Address in r16
inject_hurray:
    push r17
    call packet_new
    
    ; Address
    sts packet_buffer+1, r16
    
    ; Hurray!
    ldi r17, 3
    sts packet_buffer+2, r17
    
    call packet_calc_checksum
    call packet_transmit

    pop r17
    ret


    
; Address in r16
; Frequency value in r17
inject_freq_select:
    push r18    
    call packet_new    
    
    ; Address
    sts packet_buffer+1, r16
    
    ; Frequency Select
    ldi r18, 3
    sts packet_buffer+2, r18
    
    ; Argument - Frequency selection
    sts packet_buffer+3, r17
    
    call packet_calc_checksum
    call packet_transmit

    pop r18
    ret

