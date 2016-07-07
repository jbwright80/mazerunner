
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

    call input_read_switches ; value of switches in r16
    cpi r16, 0
    brne logic_process_switches_manual
    ; automatic mode
    rjmp logic_process_switches_done


    logic_process_switches_manual:
    ; determine which gates to shut

    ; Left Gate
    logic_process_switches_check1:
    cpi r16, 1
    brne logic_process_switches_check2
    ; Left gate selected, close middle and right gate
    call dc_fire1
    call delay_50ms
    call dc_fire2
    rjmp logic_process_switches_done

    ; Middle Gate
    logic_process_switches_check2:
    cpi r16, 2
    brne logic_process_switches_check3
    ; Middle gate selected, close left and right gate
    call dc_fire0
    call delay_50ms
    call dc_fire2
    rjmp logic_process_switches_done

    ; Right Gate
    logic_process_switches_check3:
    cpi r16, 3
    brne logic_process_switches_done
    ; Right gate selected, close left and middle gate
    call dc_fire0
    call delay_50ms
    call dc_fire1

    logic_process_switches_done:

    pop r16
    ret


logic_process_packet:
    call debug_led_on
    ret
