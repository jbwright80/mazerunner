test_packet_receive:

    call test_is_report    

    jmp logic_process_packet_done
    
    

;2 blinks PASS
;1 blink FAIL

test_is_report:

    ; make sure its addressed to node 1; me.
    lds r16, packet_buffer + 1
    cpi r16, 1
    brne test_is_report_fail
    
    ; make sure the command byte is 128; 0x80
    lds r16, packet_buffer + 2
    cpi r16, 0x80
    brne test_is_report_fail
        
    ; Pass!
    call debug_500msOn
    call delay_500ms
    call debug_500msOn
    rjmp test_is_report_done
    
    ; Fail!
    test_is_report_fail:
    call debug_500msOn
    
    test_is_report_done:

    ret
