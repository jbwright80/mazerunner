#!/bin/bash

avr-as -mmcu=atmega644a -o master.o main.s usart.s timer0.s packet.s packet-decode.s delay.s && \
avr-ld -mavr5 -Tlinker.x -o master.elf master.o && \
avr-objcopy -O ihex master.elf master.hex && \
avr-objdump -d master.elf > master.list
