##########################################################################
# Created by:  Glenn, Rory
#              romglenn
#              8 November 2019
#
# Assignment:  Lab 4: Sorting Floats
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: The program will accept three program arguments in IEEE 754
#		point format. These numbers will be numerically sorted in 
#		ascending order, then printed to the screen in order in 
#		floating point format and decimal format.
#		
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################
#
#
# 				Pseudocode
# Part A:
#	1. Load the first argument parameter
# 	   print the first argument
#
#	2. Load the second argument parameter
#	   print second argument parameter
#	
#	3. Load the third argument parameter
#	   print second argument parameter
#
# Part B:
#	1. Parse ASCII string for a numeric character and convert to integer
#	2. Store the parsed integer in memory
#	3. Print values from register to screen

.data

args:		.asciiz "Program arguments:\n"
sortedVals: 	.asciiz "Sorted values (IEEE 754 single precision floating point format):\n"
sortedValsDeci: .asciiz "Sorted values (decimal):\n"
newLine: 	.ascii "\n"

.macro SwapFloatValues(%float1, %float2)
mov.s $f5, %float1
mov.s %float1, %float2
mov.s %float2, $f5
.end_macro

.macro SwapValues(%valOne, %valTwo)
xor %valOne, %valOne, %valTwo
xor %valTwo, %valOne, %valTwo
xor %valOne, %valOne, %valTwo
.end_macro

.macro PrintSpace
# Print space
li $a0, 32
li $v0, 11
syscall
.end_macro

.macro PrintNewLine
# Print newline
li $v0, 4
la $a0, newLine
syscall
.end_macro

.macro IntToFloat(%intReg, %fpReg)
	mtc1 	 %intReg, %fpReg 	# Puts integer into FP register
	li $v0, 34			# print integer in hex
	mov.s $f12, %fpReg		# load floating point into printable register
	syscall

.end_macro


.macro FloatToInt(%intReg, %fpReg)
	cvt.w.s %fpReg, %fpReg 		# convert float to int
	mfc1 	%intReg, %fpReg		# puts into integer register
.end_macro

.macro ConvertStringToInt(%intReg, %fpReg)
# DEFINTIONS:
# $s7: loop counter
# $s6: constructed value
# $t7: placement value for construction
# %intReg: the register holding the program argument address
# $t0 = char storage

	move $s7, $zero	# set count = 0
	move $s6, $zero # reset storage of final number to 0
	li $t7, 268435456 # 16^7
	addi %intReg, %intReg, 2 # increment address by 2 (to point to the char after "0x") 
	
ConvertString: nop
	lb $t0, 0(%intReg) # load the first char at $t1 (pointer to argument string)
	beq $s7, 8, EndLoop
	ble $t0, '9' ZeroThroughNine #check if value is 0-9
	bgt $t0, '9' AthroughF
	nop
	
ZeroThroughNine: nop
	subi $t0, $t0, '0'
	mul $t0, $t0, $t7 # put index in correct base
	add $s6, $s6, $t0 # store the value 
	div $t7, $t7, 16 # (16^7 / 16) to reduce the base to 16^6
	addi %intReg, %intReg, 1 # increment address of string arg by 1 (points to next char)
	addi $s7, $s7, 1 # i++
	b ConvertString
	
AthroughF: nop
	subi $t0, $t0, '7'
	mul $t0, $t0, $t7 # put index in correct base
	add $s6, $s6, $t0 # store the value 
	div $t7, $t7, 16 # (16^7 / 16) to reduce the base to 16^6
	addi %intReg, %intReg, 1 # increment address of string arg by 1 (points to next char)
	addi $s7, $s7, 1 # i++
	b ConvertString
	
EndLoop: nop
	mtc1 $s6, %fpReg 

.end_macro

.text

#Part A

# Print args
li $v0, 4
la $a0, args
syscall

# Print first program arg
lw $a0, 0($a1)
li $v0, 4
lw $s1, 0($a1)
syscall
li $v0, 11

PrintSpace

# Print second program arg
lw $a0, 4($a1)
li $v0, 4
lw $s2, 4($a1)
syscall
li $v0, 11

PrintSpace

# Print third program arg
lw $a0, 8($a1)
li $v0, 4
lw $s3, 8($a1)
syscall
li $v0, 11

PrintNewLine

PrintNewLine

# Print sortedVals
li $v0, 4
la $a0, sortedVals
syscall

ConvertStringToInt($s1, $f0)
ConvertStringToInt($s2, $f1)
ConvertStringToInt($s3, $f2)

# move fp reg values to int values 
mfc1 $t0, $f0
mfc1 $t1, $f1
mfc1 $t2, $f2
			# Compare all floating point values

# if(f0 <= f1) 
c.le.s $f0, $f1
bc1t skip1
SwapValues($t0, $t1)
SwapFloatValues($f0, $f1)


skip1: nop

# if(f0 <= f2)
c.le.s $f0, $f2
bc1t skip2
SwapValues($t0, $t2)
SwapFloatValues($f0, $f2)


skip2: nop

# if(f1 <= f2)
c.le.s $f1, $f2		
bc1t skip3
SwapValues($t1, $t2)
SwapFloatValues($f1, $f2)

skip3: nop

li $v0, 34
la $a0, ($t0)
syscall

PrintSpace

li $v0, 34
la $a0, ($t1)
syscall

PrintSpace

li $v0, 34
la $a0, ($t2)
syscall

PrintNewLine
PrintNewLine

			#Print sorted values
# Print args
li $v0, 4
la $a0, sortedValsDeci
syscall

mov.s $f12, $f0
li $v0, 2
syscall

PrintSpace

mov.s $f12, $f1
li $v0, 2
syscall

PrintSpace

mov.s $f12, $f2
li $v0, 2
syscall

li $v0, 10
syscall
