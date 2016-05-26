; assembler definitions for the ATMega644A

; Device signature
.equ SIGNATURE_0, 0x1e
.equ SIGNATURE_1, 0x96
.equ SIGNATURE_2, 0x09


.equ UDR1, 0xce
.equ UBRR1H, 0xcd
.equ UBRR1L, 0xcc

.equ UCSR1C, 0xca ; USART1 Control and Status Register C
; UCSZ11/UDORD0 and UCPHA0/UCPOL1 share same bit space,
; but carry different meaning depending on SPI mode
.equ UMSEL11, 7
.equ UMSEL10, 6
.equ UPM11, 5
.equ UPM10, 4
.equ USBS1, 3
.equ UCSZ11, 2
.equ UDORD0, 2
.equ UCSZ10, 1
.equ UCPHA0, 1
.equ UCPOL1, 0

.equ UCSR1B, 0xc9 ; USART1 Control and Status Register B
.equ RXCIE1, 7
.equ UCSR1B, 6
.equ UDRIE1, 5
.equ RXEN1, 4
.equ TXEN1, 3
.equ UCSZ12, 2
.equ RXB81, 1
.equ TXB81, 0

.equ UCSR1A, 0xc8 ; USART1 Control and Status Register A
.equ RXC1, 7
.equ TXC1, 6
.equ UDRE1, 5
.equ FE1, 4
.equ DOR1, 3
.equ UPE1, 2
.equ U2X1, 1
.equ MPCM1, 0

.equ UDR0, 0xc6
.equ UBRR0H, 0xc5
.equ UBRR0L, 0xc4

.equ UCSR0C, 0xc2 ; Same as UCSR1C
.equ UCSR0B, 0xc1 ; Same as UCSR1B
.equ UCSR0A, 0xc0 ; Same as UCSR1A

.equ TWAMR, 0xbd ; TWI (Slave) Address Mask Register
.equ TWAM6, 7
.equ TWAM5, 6
.equ TWAM4, 5
.equ TWAM3, 4
.equ TWAM2, 3
.equ TWAM1, 2
.equ TWAM0, 1

.equ TWCR, 0xbc ; TWCR - TWI Control Register
.equ TWINT, 7
.equ TWEA, 6
.equ TWSTA, 5
.equ TWSTO, 4
.equ TWWC, 3
.equ TWEN, 2
.equ TWIE, 0

.equ TWDR, 0xbb

.equ TWAR, 0xba ; TWI (Slave) Address Register
.equ TWA6, 7
.equ TWA5, 6
.equ TWA4, 5
.equ TWA3, 4
.equ TWA2, 3
.equ TWA1, 2
.equ TWA0, 1
.equ TWGCE, 0

.equ TWSR, 0xb9 ; TWI - Status Register
.equ TWS7, 7
.equ TWS6, 6
.equ TWS5, 5
.equ TWS4, 4
.equ TWS3, 3
.equ TWPS1, 2
.equ TWPS0, 0

.equ TWBR, 0xb8

.equ ASSR, 0xb6 ; ASSR – Asynchronous Status Register
.equ EXCLK, 6
.equ AS2, 5
.equ TCN2UB, 4
.equ OCR2AUB, 3
.equ OCR2BUB, 2
.equ TCR2AUB, 1
.equ TCR2BUB, 0

.equ OCR2B, 0xb4
.equ OCR2A, 0xb3
.equ TCNT2, 0xb2

.equ TCCR2B, 0xb1 ; TCCR2B – Timer/Counter 2 Control Register B
.equ FOC2A, 7
.equ FOC2B, 6
.equ WGM22, 3
.equ CS22, 2
.equ CS21, 1
.equ CS20, 0

TCCR2A, 0xb0 ; TCCR2A – Timer/Counter Control Register A
.equ COM2A1, 7
.equ COM2A0, 6
.equ COM2B1, 5
.equ COM2B0, 4
.equ WGM21, 1
.equ WGM20, 0

.equ OCR3BH, 0x9B
.equ OCR3BL, 0x9A
.equ OCR3AH, 0x99
.equ OCR3AL, 0x98
.equ ICR3H, 0x97
.equ ICR3L, 0x96
.equ TCNT3H, 0x95
.equ TCNT3L, 0x94

.equ TCCR3C, 0x92 ; Timer/Counter 3 Control Register C
.equ FOC3A, 7
.equ FOC3B, 6

.equ TCCR3B, 0x91 ; Timer/Counter 3 Control Register B
.equ ICNC3, 7
.equ ICES3, 6
.equ WGM33, 4
.equ WGM32, 3
.equ CS32, 2
.equ CS31, 1
.equ CS30, 0

.equ TCCR3A, 0x90 ; Timer/Counter 3 Control Register A
.equ COM3A1, 7
.equ COM3A0, 6
.equ COM3B1, 5
.equ COM3B0, 4
.equ WGM31, 1
.equ WGM30, 0


.equ OCR1BH, 0x8b
.equ OCR1BL, 0x8a
.equ OCR1AH, 0x89
.equ OCR1AL, 0x88
.equ ICR1H, 0x87
.equ ICR1L, 0x86
.equ TCNT1H, 0x85
.equ TCNT1L, 0x84


.equ TCCR1C, 0x82
.equ TCCR1B, 0x81
.equ TCCR1A, 0x80
.equ DIDR1, 0x7f
.equ DIDR0, 0x7e

.equ ADMUX, 0x7c
.equ ADCSRB, 0x7b
.equ ADCSRA, 0x7a
.equ ADCH, 0x79
.equ ADCL, 0x78

.equ PCMSK3, 0x73

.equ TIMSK3, 0x71
.equ TIMSK2, 0x70
.equ TIMSK1, 0x6f
.equ TIMSK0, 0x6e
.equ PCMSK2, 0x6d
.equ PCMSK1, 0x6c
.equ PCMSK0, 0x6b

.equ EICRA, 0x69
.equ PCICR, 0x68
.equ OSCCAL, 0x66

.equ PRR, 0x64

.equ CLKPR, 0x61
.equ WDTCSR, 0x60


; I/O Specific registers

.equ SREG, 0x3f
.equ SPH, 0x3e
.equ SPL, 0x3d

.equ SPMCSR, 0x37

.equ MCUCR, 0x35
.equ MCUSR, 0x34
.equ SMCR, 0x33

.equ OCDR, 0x31
.equ ACSR, 0x30

.equ SPDR, 0x2e
.equ SPSR, 0x2d
.equ SPCR, 0x2c

.equ GPIOR2, 0x2b
.equ GPIOR1, 0x2a

.equ OCR0B, 0x28
.equ OCR0A, 0x27
.equ TCNT0, 0x26
.equ TCCR0B, 0x25
.equ TCCR0A, 0x24
.equ GTCCR, 0x23

.equ EEARH, 0x22
.equ EEARL, 0x21
.equ EEDR, 0x20
.equ EECR, 0x1f

.equ GPIOR0, 0x1e

.equ EIMSK, 0x1d

.equ EIFR, 0x1c
.equ PCIFR, 0x1b

.equ TIFR3, 0x18
.equ TIFR2, 0x17
.equ TIFR1, 0x16
.equ TIFR0, 0x15

.equ PORTD, 0x0B
.equ DDRD, 0x0A
.equ PIND, 0x09
.equ PORTC, 0x08
.equ DDRC, 0x07
.equ PINC, 0x06
.equ PORTB, 0x05
.equ DDRB, 0x04
.equ PINB, 0x03
.equ PORTA, 0x02
.equ DDRA, 0x01
.equ PINA, 0x00
