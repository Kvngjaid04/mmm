.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_PIN1, 6 // wiringPi 66
.equ YLW_PIN1, 5 // wiringPi 5
.equ GRN_PIN1, 27 // wiringPi 27
.equ RED_PIN2, 23 // wiringPi 23
.equ GRN_PIN2, 21 // wiringPi 21

.equ BTN_PIN, 29 // wiringPi 29 - BUTTON PIN
.equ PAUSE_S, 4 // pause in seconds

.align 4
.section .rodata
out_s: .asciz "%d, r4=%d, r5=%d\n"

.align 4
.text
.global main
main:
push {lr}
bl wiringPiSetup

mov r0, #STP_PIN
bl setPinInput

mov r0, #RED_PIN1
bl setPinOutput

mov r0, #YLW_PIN1
bl setPinOutput

mov r0, #GRN_PIN1
bl setPinOutput

mov r0, #RED_PIN2
bl setPinOutput

mov r0, #GRN_PIN2
bl setPinOutput

lp:

bl readStopButton
cmp r0, #HIGH        
beq pedestrian_active

mov r0, #GRN_PIN1
mov r1, #YLW_PIN1
mov r2, #PAUSE_S
bl action

cmp r0, #1
beq end_lp

mov r0, #YLW_PIN1
mov r1, #RED_PIN1
mov r2, #PAUSE_S
bl action

cmp r0, #1
beq end_lp

mov r0, #RED_PIN2
mov r1, #GRN_PIN2
mov r2, #PAUSE_S
bl action

mov r0, #GRN_PIN2
mov r1, #RED_PIN2
mov r2, #PAUSE_S
bl action

mov r0, #RED_PIN1
mov r1, #GRN_PIN1
mov r2, #PAUSE_S
bl action

bal lp
end_lp:
mov r0, #RED_PIN1
bl pinOff

mov r0, #YLW_PIN1
bl pinOff

mov r0, #RED_PIN2
bl pinOff

mov r0, #GRN_PIN1
bl pinOff

mov r0, #0
pop {pc}

setPinInput:
push {lr}
mov r1, #INPUT
bl pinMode
pop {pc}

setPinOutput:
push {lr}
mov r1, #OUTPUT
bl pinMode
pop {pc}

pinOn:
push {lr}
mov r1, #HIGH
bl digitalWrite
pop {pc}

pinOff:
push {lr}
mov r1, #LOW
bl digitalWrite
pop {pc}

readStopButton:
push {lr}
mov r0, #BTN_PIN
bl digitalRead
pop {pc}

action:
push {r4, r5, lr}

mov r4, r1
mov r5, r2

bl pinOff
mov r0, r4
bl pinOn

mov r0, #0
bl time
mov r4, r0

do_whl:
bl readStopButton
cmp r0, #HIGH
beq action_done
mov r0, #0
bl time

sub r0, r0, r4

cmp r0, r5
blt do_whl
mov r0, #0

action_done:
pop {r4,r5,pc}

pedestrian_active:        // Pedestrian active sequence
        mov r0, #RED_PIN2
        mov r1, #GRN_PIN2
        mov r2, #PAUSE_S
        bl action

        mov r0, #GRN_PIN2
        mov r1, #RED_PIN2
        mov r2, #PAUSE_S
        bl action

        bal lp
