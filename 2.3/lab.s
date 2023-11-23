	.equ	SWI_Print, 0x05
	.equ	SWI_Exit,  0x18
	
.data
	str:			.zero 256
	new_str:		.zero 256
	operands:
				.word	0, 0, 0

	
.globl _start


@ prints: Output a null-terminated ASCII string to the standard output stream
@
@ Usage:
@    prints(r0)
@ Input parameter:
@    r0: the address of a null-terminated ASCII string
@ Result:
@    None, but the string is written to standard output (the console)
prints:
	stmfd	sp!, {r0,r1,lr}
	ldr	r1, =operands
	str	r0, [r1,#4]
	bl	strlen
	str	r0, [r1,#8]
	mov	r0, #0x0
	str	r0, [r1]
	mov	r0, #0x05
	swi	0x123456
	ldmfd	sp!, {r0,r1,pc}

@ fgets: read an ASCII text line from an input stream (a text file
@        opened for input or standard input)
@
@ Usage:
@    r0 = fgets(r0, r1, r2)
@ Input parameters:
@    r0: the address of a buffer to receive the input line
@    r1: the size of the buffer (which needs to accommodate a
@        terminating null byte)
@    r2: the handle for a text file opened for input or 0 if input
@        should be read from stdin
@ Result:
@    r0: the address of the buffer if some characters were read,
@        or 0 if no characters were read due to EOF or error.
@        One text line including a terminating linefeed character
@        is read into the buffer, if the buffer is large enough.
@        Otherwise the buffer holds size-1 characters and a null byte.
@        Note: the line stored in the buffer will have only a linefeed
@        (\n) line ending, even if the input source has a DOS line
@        ending (a \r\n pair).
fgets:	stmfd	sp!, {r1-r4,lr}
	ldr	r3, =operands
	str	r2, [r3]	@ specify input stream
	mov	r2, r0
	mov	r4, r1
	mov	r0, #1
	str	r0, [r3,#8]	@ to read one character
	mov	r1, r3
	mov	r3, r2
1:	sub	r4, r4, #1
	ble	3f		@ jump if buffer has been filled
	str	r3, [r1,#4]
2:	mov	r0, #0x06	@ read operation
	swi	0x123456
	cmp	r0, #0
	bne	4f		@ branch if read failed
	ldrb	r0, [r3]
	cmp	r0, #'\r'	@ ignore \r char (result is a Unix line)
	beq	2b
	add	r3, r3, #1
	cmp	r0, #'\n'
	bne	1b
3:	mov	r0, #0
	strb	r0, [r3]
	mov	r0, r2		@ set success result
	ldmfd	sp!, {r1-r4,pc}
4:	cmp	r4, r2
	bne	3b		@ some chars were read, so return them
	mov	r0, #0		@ set failure code
	strb	r0, [r2]	@ put empty string in the buffer
	ldmfd	sp!, {r1-r4,pc}

@ strlen: compute length of a null-terminated ASCII string
@
@ Usage:
@    r0 = strlen(r0)
@ Input parameter:
@    r0: the address of a null-terminated ASCII string
@ Result:
@    r0: the length of the string (excluding the null byte at the end)
strlen:
	stmfd	sp!, {r1-r3,lr}
	mov	r1, #0
	mov	r3, r0
1:	ldrb	r2, [r3], #1
	cmp	r2, #0
	bne	1b
	sub	r0, r3, r0
	ldmfd	sp!, {r1-r3,pc}


convert_to_lowercase:
	stmfd	sp!, {r0-r2,lr}
	ldr 	r1, =str	@ r1 - original string
	ldr 	r2, =new_str	@ r2 - new string
	char_loop_convert_to_lowercase:
		ldrb r0, [r1], #1  @ load char and r1 = r1 + 1 from r0
		cmp  r0, #0  @ if end string 
		beq  stop_convert_to_lowercase
		cmp  r0, #65  @ if char in [65, 90]
		blt  save_char_convert_to_lowercase
		cmp  r0, #90
		bgt  save_char_convert_to_lowercase
		add r0, r0, #32  @ low cast char
		save_char_convert_to_lowercase:
			strb r0, [r2], #1  @ store rigister byte save new char and r2 = r2 + 1
			b char_loop_convert_to_lowercase
	stop_convert_to_lowercase:
	mov  r0, #0  @ end sybol
	strb r0, [r2], #1
	ldmfd	sp!, {r0-r2,pc}	


remove_first_word:
	stmfd	sp!, {r0-r3,lr}
	ldr 	r1, =str	@ r1 - original string
	ldr 	r2, =new_str	@ r2 - new string
	mov  r3, #0		@ r3 - drop first flag
	remove_spaces_before_word:
		ldrb r0, [r1], #1  @ load byte and r1 = r1 + 1 from r0
		cmp  r0, #32  @ if char is space
		beq  remove_spaces_before_word
	char_loop_remove_first_word:
		ldrb r0, [r1], #1  @ load byte and r1 = r1 + 1 from r0
		cmp  r0, #0  @ if end string
		beq  stop_remove_first_word
		cmp  r3, #1  @ if r3 == 1 - save char
		beq  save_char_remove_first_word
		cmp  r0, #32  @ else if char is space
		moveq r3, #1  @ flag disabled
		beq  remove_spaces_after_word
		b char_loop_remove_first_word
		remove_spaces_after_word:
			ldrb r0, [r1], #1
			cmp  r0, #32  @ if char is space
			beq  remove_spaces_after_word
		save_char_remove_first_word:
			strb r0, [r2], #1  @ save new char and r2 = r2 + 1 
			b char_loop_remove_first_word
	stop_remove_first_word:
	mov  r0, #0  @ end sybol
	strb r0, [r2]
	ldmfd	sp!, {r0-r3,pc}	


_start:
	ldr r0, =str  @ in register read word of adress =str
	mov r1, #256
	mov r2, #0
	bl fgets

	bl remove_first_word
	ldr r0, =new_str
	bl prints

	bl convert_to_lowercase
	ldr r0, =new_str
	bl prints		
	
	exit:
	mov  r0, #SWI_Exit
	mov	r1, #0
	swi	0x123456