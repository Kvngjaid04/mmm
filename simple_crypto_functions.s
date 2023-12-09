.global encrypt
.global decrypt

.text
.align 4
/// function: encrypt
/// input: R0 - address of message array
///	   R1 - length of message array
///	   R2 - address of key array
///	   R3 - length of key array
/// return: no return values, just the message encrypted
///
.align 4
encrypt:
	push { R4, R5, R6, R7, LR } // step #1_en - Save R4,R5,R6,R7, and LR
	mov R4, #0  // step #2_en - Set register R4 to 0
	mov R5, #0// step #3_en - Set register R5 to 0
EN_WHL_R5_LT_R1:
	cmp R5, R1 // step #4_en - compare R5 and R1 in this order of the registers
	bge EN_END_WHL_R5_LT_R1 // step #5_en - if R5 greater than or equal to R1, branch to EN_END_WHL_R5_LT_R1
	ldrb R6, [R0, R5] // step #6_en - load byte into register R6, the contents of R0[R5]
	ldrb R7, [R2, R4] // step #7_en - load byte into register R7, the contents of R2[R4]
	eor R6, R6, R7 // step #8_en - exclusive or R6 and R7, storing result in R6
	and R7, R5, #255 // step #9_en - use bitwise AND with R5 and #255 to cast R5's value as char instead of int, store in R7
	add R6, R6, R7 // step #10_en - add R6 and R7, storing result in R6
	strb R6, [R0, R5] // step #11_en - store byte in R6 to R0[R5]
	add R4, R4, #1 // step #12_en - increment R4 by one
EN_IF_R4_GE_R3:
	cmp R4, R3 // step #13_en - compare R4 and R3 in this order of the registers
	movge R4, #0 // step #14_en - do conditional execution, move if greater than or equal, into R4 the value #0
	add R5, R5, #1 // step #15_en - increment R5 by one
	b EN_WHL_R5_LT_R1 // step #16_en - branch (or branch ALways) back to EN_WHL_R5_LT_R1 label
EN_END_WHL_R5_LT_R1:
	pop { R4, R5, R6, R7, PC } // step #17_en - restore the registers R4,R5,R6,R7, and PC; in the order of registers given

//////////////////////////////////////////////////////////////////////////////////////////////
/// end of encrypt function //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/// function: decrypt
/// input: R0 - address of encrypted message array
///	   R1 - length of encrypted message array
///	   R2 - address of key array
///	   R3 - length of key array
/// return: no return values, just the message decrypted
///
.align 4
decrypt:
	push { R4, R5, R6, R7, LR } // step #1_de - Save R4,R5,R6,R7, and LR
	mov R4, #0 // step #2_de - Set register R4 to 0
	mov R5, #0 // step #3_de - Set register R5 to 0
DE_WHL_R5_LT_R1:
	cmp R5, R1 // step #4_de - compare R5 and R1 in this order of the registers
	bge DE_END_WHL_R5_LT_R1 // step #5_de - if R5 greater than or equal to R1, branch to DE_END_WHL_R5_LT_R1
	ldrb R6, [R0, R5] // step #6_de - load byte into register R6, the contents of R0[R5]
	and R7, R5, #255 // step #7_de - use bitwise AND with R5 and #255 to cast R5's value as char instead of int, store in R7
	sub R6, R6, R7 // step #8_de - subtract R6 and R7, storing result in R6
	ldrb R7, [R2, R4] // step #9_de - load byte into register R7, the contents of R2[R4]
	eor R6, R6, R7 // step #10_de - exclusive or R6 and R7, storing result in R6
	strb R6, [R0, R5] // step #11_de - store byte in R6 to R0[R5]
	add R4, R4, #1 // step #12_de - increment R4 by one
DE_IF_R4_GE_R3:
	cmp R4, R3  // step #13_de - compare R4 and R3 in this order of the registers
	movge R4, #0 // step #14_de - do conditional execution, move if greater than or equal, into R4 the value #0
	add R5, R5, #1 // step #15_de - increment R5 by one
	b DE_WHL_R5_LT_R1// step #16_de - branch (or branch ALways) back to DE_WHL_R5_LT_R1 label
DE_END_WHL_R5_LT_R1:
	pop { R4, R5, R6, R7, PC } // step #17_en - restore the registers R4,R5,R6,R7, and PC; in the order of registers given

//////////////////////////////////////////////////////////////////////////////////////////////
/// end of decrypt function //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
