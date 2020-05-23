#------------------------------------------------------------------------
# Created by:  Glenn, Rory
#              romglenn
#              26th November 2019 
#
# Assignment:  Lab 5: Subroutines
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
#
# Description: Library of subroutines used to convert an array of
#              numerical ASCII strings to ints, sort them, and print
#              them.
#
# Notes:       This file is intended to be run from the Lab 5 test file.
#------------------------------------------------------------------------

.text
j  exit_program                # prevents this file from running
                               # independently (do not remove)

#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print new line macro
.macro lab5_print_new_line
    addiu $v0 $zero   11
    addiu $a0 $zero   0xA
    syscall
.end_macro

#------------------------------------------------------------------------
# print string
.macro lab5_print_string(%str)
    .data
    string: .asciiz %str

    .text
    li  $v0 4
    la  $a0 string
    syscall
.end_macro

#------------------------------------------------------------------------
# add additional macros here

# Swap values
.macro SwapValues(%valOne, %valTwo)
xor %valOne, %valOne, %valTwo
xor %valTwo, %valOne, %valTwo
xor %valOne, %valOne, %valTwo
.end_macro
#------------------------------------------------------------------------

# print space
.macro PrintSpace
li $a0, 32
li $v0, 11
syscall
.end_macro


#------------------------------------------------------------------------
# main_function_lab5_19q4_fa_ce12:
#
# Calls print_str_array, str_to_int_array, sort_array,
# print_decimal_array.
#
# You may assume that the array of string pointers is terminated by a
# 32-bit zero value. You may also assume that the integer array is large
# enough to hold each converted integer value and is terminated by a
# 32-bit zero value
# 
# arguments:  $a0 - pointer to integer array
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - minimum element in array (32-bit int)
#             $v1 - maximum element in array (32-bit int)
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
#-----------------------------------------------------------------------

.text
main_function_lab5_19q4_fa_ce12: nop

    subi  $sp    $sp   16       # decrement stack pointer
    sw    $ra 12($sp)           # push return address to stack
    sw    $s0  8($sp)           # push save registers to stack
    sw    $s1  4($sp)
    sw    $s2   ($sp)
    
    move  $s0    $a0            # save ptr to int array
    move  $s1    $a1            # save ptr to string array
    
    move  $a0    $s1            # load subroutine arguments
    jal   get_array_length      # determine length of array
    move  $s2    $v0            # save array length
    
                                # print input header
                                 
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nInput string array\n")

                                
    add $a0, $zero, $s0		# number of program arguments
    add $a1, $zero, $s1		# ptr to string array
    jal   print_str_array         # print array of ASCII strings

    add $a2, $zero, $s0		# number of program arguments
    add $a1, $zero, $s1		# ptr to string array            
    jal str_to_int_array    	# convert string array to int array

                                
    add $a0, $zero, $s2		
    add $a1, $zero, $s0		
    jal   sort_array            # sort int array
                                # save min and max values from array

                                # print output header    
    lab5_print_new_line
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nSorted integer array\n")

                                
    add $a0, $zero, $s2		
    add $a1, $zero, $s0	
    jal   print_decimal_array   # print integer array as decimal

    lab5_print_new_line
            
    lw    $ra 12($sp)           # pop return address from stack
    lw    $s0  8($sp)           # pop save registers from stack
    lw    $s1  4($sp)
    lw    $s2   ($sp)
    addi  $sp    $sp   16       # increment stack pointer
    
    jr    $ra                   # return from subroutine
    
#-----------------------------------------------------------------------
# print_str_array	
#
# Prints array of ASCII inputs to screen.
#
# arguments:  $a0 - array length (optional)
# 
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# Definitions
# $t3 = size of array
# $t2 = loop counter
# $t1 = array address
#-----------------------------------------------------------------------

print_str_array: nop

    	# push on stack
   	 subi  $sp    $sp   16     		  # decrement stack pointer
   	 sw    $ra 12($sp)         		  # push return address to stack
   	 sw    $s0  8($sp)        		  # push save registers to stack
   	 sw    $s1  4($sp)
   	 sw    $s2   ($sp)


	la $t1, ($a1)			# get array address (MAKE SURE $a1 IS THE CORRECT ADDRESS!)
	li $t2, 0			# set loop counter

while:
	beq $t2, 3, exit 		# check for array end
	
	lw $a0, ($t1)			# print list element
	li $v0, 4
	syscall
	PrintSpace
	
	addi $t2, $t2, 1			# advance loop counter
	addi $t1, $t1, 4			# advance array pointer
	b while				# repeat the loop
	
   exit:
   
   	# pop off stack
   	lw    $ra 12($sp)         	  # pop return address from stack
   	lw    $s0  8($sp)         	  # pop save registers from stack
   	lw    $s1  4($sp)
   	lw    $s2   ($sp)
   	addi  $sp    $sp   16     	  # increment stack pointer
   
   	jr  $ra
   	
#-----------------------------------------------------------------------
# str_to_int_array
#
# Converts array of ASCII strings to array of integers in same order as
# input array. Strings will be in the following format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, with A - F
# capitalized
# 
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
#             $a2 - pointer to integer array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
# 
#-----------------------------------------------------------------------

.text
str_to_int_array: nop

	move $t3, $zero		# reset counter to 0
	
while1: nop
	
	subi $sp, $sp 4	 	# subtract stack pointer
	sw $ra, ($sp)		# push return address on stack
	
	beq $t3, 3, exit1	# if( count == 3 )
	lw $a0, ($a1)		# load the contents of $a1 in $a0
	jal str_to_int		# call str_to_int
	
	lw $ra ($sp)		# pop stack pointer
	add $sp, $sp, 4		# increment address
	
	addi $a1, $a1, 4		# increment pointer to next program argument
	addi $t3, $t3, 1		# count++
	
	sw $v0, ($a2)		# store the string that was just converted
	addi $a2, $a2, 4 	# increment pointer to next program argument
	b while1			# branch unconditionally
	
exit1: nop

	lw $ra, ($sp)
	add $sp, $sp, 4

   	jr  $ra

#-----------------------------------------------------------------------
# str_to_int	
#
# Converts ASCII string to integer. Strings will be in the following
# format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, capitalizing
# A - F.
# 
# argument:   $a0 - pointer to first character of ASCII string
#
# returns:    $v0 - integer conversion of input string
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
str_to_int: nop

        addi $v0, $zero, 0		# clear out the register
	move $t1, $zero			# set count = 0
	li $t7, 0x10000000		# 16^7
	addiu $a0, $a0, 2		# increment address by 2 (to point to the char after "0x") 
	
ConvertString: nop

	lb $t0, 0($a0)			# load the first char at $t1 (pointer to argument string)
	beq $t1, 8, EndLoop		# if($s7 == 0) then go to EndLoop
	ble $t0, '9' ZeroThroughNine 	# check if value is 0-9
	bgt $t0, '9' AthroughF		# check if value is A-F
	
ZeroThroughNine: nop

	subi $t0, $t0, '0'		# '1' - '0' = 1
	mul $t0, $t0, $t7 		# put index in correct base
	add $v0, $v0, $t0 		# store the value 
	div $t7, $t7, 16 		# (16^7 / 16) to reduce the base to 16^6
	addi $a0, $a0, 1 		# increment address of string arg by 1 (points to next char)
	addi $t1, $t1, 1 		# i++
	b ConvertString			# branch unconditionally
	
AthroughF: nop

	subi $t0, $t0, '7'		# 'A' - '7' = A
	mul $t0, $t0, $t7 		# put index in correct base
	add $v0, $v0, $t0 		# store the value 
	div $t7, $t7, 16 		# (16^7 / 16) to reduce the base to 16^6
	addi $a0, $a0, 1 		# increment address of string arg by 1 (points to next char)
	addi $t1, $t1, 1 		# i++
	b ConvertString			# branch inconditionally
	
EndLoop: nop

   	jr   $ra
    
#-----------------------------------------------------------------------
# sort_array
#
# Sorts an array of integers in ascending numerical order, with the
# minimum value at the lowest memory address. Assume integers are in
# 32-bit two's complement notation.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    $v0 - minimum element in array
#             $v1 - maximum element in array
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

				# The following code is NOT mine
				# THIS IS BUBBLE SORT FROM THE MIPS TEXTBOOK!
				# Section 9.3.1 Page 173
				
# Subproram: Bubble Sort
# Purpose: Sort data using a Bubble Sort algorithm
# Input Params: $a0 - array
# $a1 - array size
# Register conventions:
# $s0 - array base
# $s1 - array size
# $s2 - outer loop counter
# $s3 - inner loop counter

sort_array: nop


BubbleSort: nop

 	addi $sp, $sp, -20	 # save stack information
 	sw $ra, 0($sp)
 	sw $s0, 4($sp)		 # need to keep and restore save registers
 	sw $s1, 8($sp)
 	sw $s2, 12($sp)
 	sw $s3, 16($sp)

	SwapValues($a0, $a1)

 	move $s0, $a0
 	move $s1, $a1

 	addi $s2, $zero, 0	 #outer loop counter
 
OuterLoop: nop

	addi $t1, $s1, -1
 	slt $t0, $s2, $t1
 	beqz $t0, EndOuterLoop

 	addi $s3, $zero, 0	 #inner loop counter
 	
InnerLoop: nop

 	addi $t1, $s1, -1
 	sub $t1, $t1, $s2
 	slt $t0, $s3, $t1
 	beqz $t0, EndInnerLoop

 	sll $t4, $s3, 2		 # load data[j]. Note offset is 4 bytes
 	add $t5, $s0, $t4
 	lw $t2, 0($t5)

 	addi $t6, $t5, 4		 # load data[j+1]
 	lw $t3, 0($t6)

 	sgt $t0, $t2, $t3
 	beqz $t0, NotGreater
 	move $a0, $s0
 	move $a1, $s3
 	addi $t0, $s3, 1
 	move $a2, $t0
 	jal Swap			 # t5 is &data[j], t6 is &data[j=1]

NotGreater: nop

 	addi $s3, $s3, 1
 	b InnerLoop
 	
EndInnerLoop: nop

 	addi $s2, $s2, 1
 	b OuterLoop
 	
EndOuterLoop: nop

 	lw $ra, 0($sp)		 #restore stack information
 	lw $s0, 4($sp)
 	lw $s1, 8($sp)
 	lw $s2, 12($sp)
 	lw $s3, 16($sp)
 	addi $sp, $sp 20
 	
 	jr $ra
 	
# Subprogram: swap
# Purpose: to swap values in an array of integers
# Input parameters: $a0 - the array containing elements to swap
# $a1 - index of element 1
# $a2 - index of elelemnt 2
# Side Effects: Array is changed to swap element 1 and 2

Swap:
 	sll $t0, $a1, 2		 # calcualate address of element 1
 	add $t0, $a0, $t0
 	sll $t1, $a2, 2		 # calculate address of element 2
 	add $t1, $a0, $t1
 	lw $t2, 0($t0)		 #swap elements
 	lw $t3, 0($t1)
 	sw $t2, 0($t1)
 	sw $t3, 0($t0)

 	jr $ra

#-----------------------------------------------------------------------
# print_decimal_array
#
# Prints integer input array in decimal, with spaces in between each
# element.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal_array: nop

	addi $t3, $zero, 0 	# reset counter
	addi $v0, $zero, 0 	# reset $v0
	
while3: nop
	
	subi $sp, $sp 4	 	# subtract stack pointer
	sw $ra, ($sp)		# push return address on stack
	
	beq $t3, 3, exit3	# if( count == 3 )
	
	lw $a0, ($a1)		# load the contents of $a1 in $a0
	jal print_decimal	# call print_decimal
	
	PrintSpace
	
	lw $ra ($sp)		# pop off stack
	add $sp, $sp, 4		# increment stack pointer
	
	addi $a1, $a1, 4		# increment pointer to next program argument
	addi $t3, $t3, 1		# count++
	
	b while3			# branch unconditionally
	
exit3: nop

	lw $ra, ($sp)		# pop stack pointer
	add $sp, $sp, 4		# increment stack pointer
	
    	jr   $ra
    
#-----------------------------------------------------------------------
# print_decimal
#
# Prints integer in decimal representation.
#
# arguments:  $a0 - integer to print
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - char buffer
# $t1 - buffer pointer
# $t2 - negative flag
# $t3 - divisor
#-----------------------------------------------------------------------
.data
printDBuffer: .space 12

.text
print_decimal: nop

	# this entire process starts at the least significant digit
	# and moves left to the most significant digit

	# 1. Get address of the buffer
	# 2. point at the end of the buffer
	# 3. store zero in $t0
	# 4. check if it is negative
	# 5. flip the sign
	
	# start loop:
	# 	6. divide by 10 in the loop
	# 	7. decrement the pointer
	# 	8. store char
	# 	9. load negative sign
	# 	10. decrement the pointer
	# 	11. store the char
	
	addi $v0, $zero, 0		# reset $v0 to 0

	addi $t0, $zero, 0 		# count = 0
	la $t1, printDBuffer		# get address of buffer
	addiu $t1, $t1, 11		# start at the right hand side of the array
	sb $t0, 0($t1)			# store zero
	andi $t2, $a0, 0x80000000		# negative test
	beq $t2, $zero, while2		# if ( $t2 == 0 )
	subu $a0, $zero, $a0		# flip sign
	
while2: nop

	div $a0, $a0, 10			# step to the next number
	mflo $a0				# store the least significant bit
	mfhi $t0				# store the most significant bit
	addiu $t0, $t0, 48		# 2 + '0' = '2'
	addiu $t1, $t1, -1		# decrement pointer to move to the next character in the argument
	sb $t0, 0($t1)			# store the new character
	bne $a0, $zero, while2 		# if ( $a0 == 0 )
	beq $t2, $zero, exit2		# if ( $t2 == 0 )
	
	li $t0, 45			# load negative sign '-'
	addiu $t1, $t1, -1		# decrement pointer
	sb $t0, 0($t1)			# store character
	
exit2: nop
	
	li $v0, 4			# move 4 into $v0
	move $a0, $t1			# $a0 = $t1
	syscall
	
    jr   $ra

#-----------------------------------------------------------------------
# exit_program (given)
#
# Exits program.
#
# arguments:  n/a
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $v0: syscall
#-----------------------------------------------------------------------

.text
exit_program: nop
   
    addiu   $v0  $zero  10      # exit program cleanly
    syscall
    
#-----------------------------------------------------------------------
# OPTIONAL SUBROUTINES
#-----------------------------------------------------------------------
# You are permitted to delete these comments.

#-----------------------------------------------------------------------
# get_array_length (optional)
# 
# Determines number of elements in array.
#
# argument:   $a0 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - array length
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
get_array_length: nop

	# iterate throught the array
	# count the element
	# check if the address is zero
	# if true then you have reached the end of the array
	# if false then you have not reached the end
	
	#move  $a1    $s0
	#move  $a0    $s1            # load subroutine arguments
	
#get_array_length_loop: nop

	#beq $a0, 0, exit_get_array_length
	
	#addi $a0, $a0, 1		# increment pointer to next element in array
	#addi $t0, $t0, 1		# count++
	#b get_array_length_loop
	
#exit_get_array_length: nop


    	addiu   $v0  $zero  3       # replace with /code to determine array length    	
    	jr      $ra
    
#-----------------------------------------------------------------------
# save_to_int_array (optional)
# 
# Saves a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to save
#             $a1 - address of int array
#             $a2 - index to save to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------
    
