#!/bin/bash

avr-as -mmcu=atmega644a -o master.o main.s usart.s timer0.s packet.s inject.s logic.s packet-decode.s input.s dc.s delay.s debug.s test.s && \
avr-ld -mavr5 -Tlinker.x -o master.elf master.o && \
avr-objcopy -O ihex master.elf master.hex && \
avr-objdump -d master.elf > master.list
