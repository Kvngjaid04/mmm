.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_PIN1, 6    // wiringPi 26
.equ YLW_PIN1, 5    // wiringPi 27
.equ GRN_PIN1, 27   // wiringPi 28
.equ RED_PIN2, 3    // wiringPi 24
.equ GRN_PIN2, 21   // wiringPi 25
.equ STP_PIN, 29    // wiringPi 29 - STOP PIN
.equ PAUSE_S, 3     // pause in seconds
.equ FLASHING_DURATION, 5
.equ TIME_BEFORE_FLASHING, 10

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
    mov r0, #RED_PIN1
    mov r1, #RED_PIN1
    mov r2, #PAUSE_S
    bl action

    cmp r0, #1
    beq end_lp

    mov r0, #GRN_PIN1
    mov r1, #GRN_PIN1
    mov r2, #PAUSE_S
    bl action

    cmp r0, #1
    beq end_lp

    mov r0, #YLW_PIN1
    mov r1, #YLW_PIN1
    mov r2, #PAUSE_S
    bl action

    cmp r0, #1
    beq end_lp

    // Keep Red 2 always on
    mov r0, #RED_PIN2
    mov r1, #RED_PIN2
    bl action

    // Continue the loop
    bal lp

handle_stop_button:
    // Check if Red 2 is currently on
    mov r0, #RED_PIN2
    mov r1, #RED_PIN2
    bl isCurrentLEDRed2

    cmp r0, #1
    bne handle_yellow_stop

    // Transition Red 2 to Green 2
    mov r0, #RED_PIN2
    mov r1, #GRN_PIN2
    mov r2, #PAUSE_S
    bl action

    // Check if a certain period has passed
    mov r0, #0
    bl time
    cmp r0, #TIME_BEFORE_FLASHING
    blt handle_yellow_stop

    // Initiate flashing for Yellow 1 and Green 1
    mov r0, #YLW_PIN1
    mov r1, #GRN_PIN1
    mov r2, #FLASHING_DURATION
    bl flashingAction

    // Immediately initiate the default sequence
    bal lp

handle_yellow_stop:
    // Transition to Yellow 1 and then Red 1
    mov r0, #YLW_PIN1
    mov r1, #RED_PIN1
    mov r2, #PAUSE_S
    bl action

    // Continue the loop
    bal lp

flashingAction:
    push {r4, r5, lr}

flashing_loop:
    bl pinOn
    mov r0, #0
    bl time
    mov r4, r0

flashing_delay:
    mov r0, #0
    bl time
    sub r0, r0, r4
    cmp r0, #FLASHING_DURATION
    blt flashing_loop

    bl pinOff

    pop {r4, r5, pc}

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

isCurrentLEDRed2:
    push {lr}
    bl digitalRead
    cmp r0, #HIGH
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
