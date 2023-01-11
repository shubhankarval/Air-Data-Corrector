#***************************************
#
# Name: Shubhankar Valimbe
# Email:skvalimb@buffalo.edu
# Computer OS: Windows
# Course: CSE 341
# Assignment:
# Summary of Assignment Purpose: Encode or decode input using hamming code.
# Date of Initial Creation: 10/15/21
# 
# Input/Stored Value Requirements: User input mode stored in $s1, and integer stored in $s0
#
# Values Stored/Returned: Output returned in $s0 (0 if two or more errors found)
#
#***************************************

.data 0x10000000
prompt: .asciiz "Enter mode: (0 for encode, 1 for decode)\n"
enc: .asciiz "Enter interger: (only upto 2047)\n"
dec: .asciiz "Enter interger: (only upto 65535)\n"
error1: .asciiz "Two or more errors present in the data, hence cannot be corrected."
error2: .asciiz "One error found and corrected."
error3: .asciiz "No errors found."


.text
.globl main

main:
	lui $a0, 0x1000      # $a0 = 0x1000 0000
	addi $v0, $0, 4      # $v0 = 4 
	syscall              # print string 

	addi $v0, $0, 5      # $v0 = 5
	syscall              # read int 
	addi $s1, $v0, 0     #$s1 = $v0
	blez $s1, encode     #go to encode if $s1<0
	j decode	     #go to decode

encode:
	addi $a0, $0, 0
	lui $a0, 0x1000      # $a0 = 0x1000 0000
	ori $a0, $a0, 0x002a # $a0 = 0x1000 002a

	addi $v0, $0, 4      # $v0 = 4 
	syscall              # print string

	addi $v0, $0, 5      # $v0 = 5
	syscall              # read int 
	addi $s0, $v0, 0     #$s0 = $v0

encode_begin:
	
	addi $t0, $0, 0       #t0 = 0
	andi $t1, $s0, 0x6D5  #$t1 stores data bits for calculatig P1
	andi $t2, $s0, 0x5B3  #$t2 stores data bits for calculatig P2
	andi $t3, $s0, 0x38F  #$t3 stores data bits for calculatig P3
	andi $t4, $s0, 0x7F   #$t4 stores data bits for calculatig P4
	addi $t5, $s0, 0      #t5 = s0 
	addi $t7, $0, 2       #t7 = 2

#calculating parity bit 1
p1:
	blez $t1, p1_end      #if t1<=0, go to p1_end
	andi, $t6, $t1, 1     # t6 = t1 & 1
	srl $t1, $t1, 1		#t1 = t1>>1
	bgtz $t6, p1_add
	j p1
	or $0, $0, $0
	
p1_add: 
	addi $t0, $t0, 1 
	j p1
	or $0, $0, $0

p1_end:
	div $t0, $t7
	mfhi $t1       #t1 holds parity bit 1 
	addi $t0, $0, 0

#calculating parity bit 2
p2:
	blez $t2, p2_end
	andi, $t6, $t2, 1
	srl $t2, $t2, 1
	bgtz $t6, p2_add
	j p2
	or $0, $0, $0

p2_add: 
	addi $t0, $t0, 1 
	j p2
	or $0, $0, $0

p2_end:
	div $t0, $t7
	mfhi $t2       #t1 holds parity bit 2
	addi $t0, $0, 0

#calculating parity bit 3
p3:
	blez $t3, p3_end
	andi, $t6, $t3, 1
	srl $t3, $t3, 1
	bgtz $t6, p3_add
	j p3
	or $0, $0, $0	

p3_add: 
	addi $t0, $t0, 1 
	j p3
	or $0, $0, $0

p3_end:
	div $t0, $t7
	mfhi $t3      #t1 holds parity bit 2
	addi $t0, $0, 0

#calculating parity bit 4
p4:
	blez $t4, p4_end
	andi, $t6, $t4, 1
	srl $t4, $t4, 1
	bgtz $t6, p4_add
	j p4
	or $0, $0, $0	

p4_add: 
	addi $t0, $t0, 1 
	j p4
	or $0, $0, $0

p4_end:
	div $t0, $t7
	mfhi $t4      #t1 holds parity bit 2
	addi $t0, $0, 0

parity_end:

	sll $t1, $t1, 12
	add, $s0, $s0, $t1	#inserting p1
	sll $t2, $t2, 11
	add, $s0, $s0, $t2	#inserting p2
	
	sll $t3, $t3, 10
	andi $t6, $s0, 0x3FF
	andi $t7, $s0, 0x1C00
	sll $t7, $t7, 1
	add $s0, $t7, $t3
	add $s0, $s0, $t6      #inserting p3

	sll $t4, $t4, 7
	andi $t6, $s0, 0x7F
	andi $t7, $s0, 0x3F80
	sll $t7, $t7, 1
	add $s0, $t7, $t4
	add $s0, $s0, $t6      #inserting p3

	addi $t1, $s0, 0
	addi $t7, $0, 2
	addi $t0, $0, 0

#calculating parity bit 0
p0:
	blez $t1, p0_end
	andi, $t6, $t1, 1
	srl $t1, $t1, 1
	bgtz $t6, p0_add
	j p0
	or $0, $0, $0	

p0_add: 
	addi $t0, $t0, 1 
	j p0
	or $0, $0, $0

p0_end:
	div $t0, $t7
	mfhi $t1      #t1 holds parity bit 0
	
encode_end:
	sll $t1, $t1, 15
	add $s0, $s0, $t1	#encoded number saved in s0
	bgtz $s1, p1_decode
	jr $ra
	or $0, $0, $0

decode: 
	addi $a0, $0, 0
	lui $a0, 0x1000      # $a0 = 0x1000 0000
	ori $a0, $a0, 0x004c

	addi $v0, $0, 4      # $v0 = 4 
	syscall              # print string

	addi $v0, $0, 5      # $v0 = 5
	syscall              # read int 
	addi $s2, $v0, 0     #s2 holds encoded number
	
	andi $t1, $s2, 0x7F
	andi $t2, $s2, 0x700
	srl $t2, $t2, 1
	andi $t3, $s2, 0x1000
	srl $t3, $t3, 2
	add $s0, $t1, $t2
	add $s0, $s0, $t3
	
	j encode_begin

p1_decode:
	andi $t6, $s0, 0x4000
	andi $t7, $s2, 0x4000
	bne $t6, $t7, p1_bne
	addi $t1, $0, 0
	j p2_decode
	
p1_bne:
	addi $t1, $0, 1

p2_decode:
	andi $t6, $s0, 0x2000
	andi $t7, $s2, 0x2000
	bne $t6, $t7, p2_bne
	addi $t2, $0, 0
	j p3_decode
	
p2_bne:
	addi $t2, $0, 1

p3_decode:
	andi $t6, $s0, 0x800
	andi $t7, $s2, 0x800
	bne $t6, $t7, p3_bne
	addi $t3, $0, 0
	j p4_decode
	
p3_bne:
	addi $t3, $0, 1

p4_decode:
	andi $t6, $s0, 0x80
	andi $t7, $s2, 0x80
	bne $t6, $t7, p4_bne
	addi $t4, $0, 0
	j check
	
p4_bne:
	addi $t4, $0, 1

check:
	sll $t4, $t4, 3
	sll $t3, $t3, 2
	sll $t2, $t2, 1
	add $t5, $t1, $t2
	add $t5, $t5, $t3
	add $t5, $t5, $t4
	blez $t5, no_error
	addi $t1, $0, 0x4000
	addi $t2, $0, 1
	j loop

no_error:
	andi $s6, $s0, 0x8000
	andi $s7, $s2, 0x8000
	beq $s6, $s7, decode_no_error

	addi $a0, $0, 0
	lui $a0, 0x1000      # $a0 = 0x1000 0000
	ori $a0, $a0, 0x006f

	addi $v0, $0, 4      # $v0 = 4 
	syscall              # print string

	addi $s0, $s0, 0
	jr $ra
	or $0, $0, $0

loop:	
	beq $t5, $t2, correct
	srl $t1, $t1, 1
	addi $t5, $t5, -1
	j loop

correct:
	xor $s2, $s2, $t1

decode_end:
	andi $t1, $s2, 0x7F
	andi $t2, $s2, 0x700
	srl $t2, $t2, 1
	andi $t3, $s2, 0x1000
	srl $t3, $t3, 2
	add $s0, $t1, $t2
	add $s0, $s0, $t3
	
	addi $a0, $0, 0
	lui $a0, 0x1000      # $a0 = 0x1000 0000
	ori $a0, $a0, 0x00b2

	addi $v0, $0, 4      # $v0 = 4 
	syscall              # print string

	jr $ra
	or $0, $0, $0
	
decode_no_error:

	andi $t1, $s2, 0x7F
	andi $t2, $s2, 0x700
	srl $t2, $t2, 1
	andi $t3, $s2, 0x1000
	srl $t3, $t3, 2
	add $s0, $t1, $t2
	add $s0, $s0, $t3

	addi $a0, $0, 0
	lui $a0, 0x1000      # $a0 = 0x1000 0000
	ori $a0, $a0, 0x00d1

	addi $v0, $0, 4      # $v0 = 4 
	syscall              # print string

	jr $ra
	or $0, $0, $0	
