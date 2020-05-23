##########################################################################
# Created by:  Glenn, Rory
#              romglenn
#              8 November 2019
#
# Assignment:  Lab 3: ASCII Forest 
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: This program prints trees to the screen based on 
#		user input for the number of trees and the
#		size of trees.
# 
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

.data

numberOfTrees: .asciiz "Enter the number of trees to print (must be greater than 0): "
sizeOfTrees:   .asciiz "Enter the size of one tree (must be greater than 1): "
errorMessage:  .asciiz "Invalid entry!\n"
newLine:       .asciiz "\n"

.text

# 4 - Print String
# 5 - Read Integer
# 8 - Read String
# 10 - Exit Program cleanly
# 11 - Print Character

prompt1: nop

#prompt the user to enter the number of trees
li $v0, 4 #print string
la $a0, numberOfTrees
syscall 

#get the number of trees
li $v0, 5 # read integer
syscall

move $t0, $v0
move $s0, $v0 
ble  $t0, 0, errorMessagePrompt1
b prompt2
nop

errorMessagePrompt1: nop
	li $v0, 4
	la $a0, errorMessage
	syscall #tell the operating system to do something
	b prompt1
	nop

prompt2: nop

#prompt the user to enter the size of one tree
li $v0, 4
la $a0, sizeOfTrees #print sizeOfTrees message
syscall

#get the size of one tree
li $v0, 5
syscall

move $t1, $v0
move $s1, $v0
ble $t1, 1, errorMessagePrompt2
b whileTop
nop

errorMessagePrompt2: nop
	li $v0, 4
	la $a0, errorMessage
	syscall
	b prompt2
	nop
	
#---------------------------------------------------------------

whileTop: nop
		ble $t0, 0, reset1
		
		#print out everything below
		li $v0, 11
		
		#space
		li $a0, 32
		syscall
	
		#forward slash
		li $a0, 47
		syscall
	
		#backslash
		li $a0, 92
		syscall	
	
		#space
		li $a0, 32
		syscall
	
		#space
		li $a0, 32
		syscall
	
		#space
		li $a0, 32
		syscall
		
		# i--
		subi $t0, $t0, 1
		j whileTop 
	
#---------------------------------------------------------------
reset1:
li $v0, 4
la $a0, newLine
syscall
move $t0, $s0
move $t1, $s1
subi $t1, $t1, 1
j whileMiddle

whileMiddle: nop
		# $t0 = numberOfTrees
		# $t1 = sizeOfTrees
		
		# while(numberOfTrees > 0)
		ble $t0, 0, innerWhileMiddle
		
		# if(sizeOfTrees > 0)
		ble $t1, 0, reset2
		
		#print out everything below
		li $v0, 11
		
		#forward slash
		li $a0, 47
		syscall
	
		#space
		li $a0, 32
		syscall
	
		#space
		li $a0, 32
		syscall
		
		#backslash
		li $a0, 92
		syscall 
		
		#space
		li $a0, 32
		syscall
		
		#space
		li $a0, 32
		syscall
		
		# numberOfTrees--;
		subi $t0, $t0, 1

		j whileMiddle
		
		# 2nd loop
		innerWhileMiddle: nop
			#while(sizeOfTrees > 0)
			ble $t1, 0, reset2 #exit condition
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			# reset numberofTrees back to original value
			move $t0, $s0
			
			# sizeOfTrees--;
			subi $t1, $t1, 1
			
			j whileMiddle
	
#---------------------------------------------------------------
reset2:
move $t0, $s0
move $t1, $s1
j whileLower

whileLower: nop
		# while(numberOfTrees > 0)
		ble $t0, 0, reset3
		li $v0, 11
	
		#dash
		li $a0, 45
		syscall
	
		#dash
		li $a0, 45
		syscall
	
		#dash
		li $a0, 45
		syscall
	
		#dash
		li $a0, 45
		syscall
	
		#space
		li $a0, 32
		syscall
	
		#space
		li $a0, 32
		syscall
		
		li $v0, 4
		la $a0, newLine
		
		# numberOfTrees--;
		subi $t0, $t0, 1
		
		j whileLower 
	
#---------------------------------------------------------------

reset3:
li $v0, 4
la $a0, newLine
syscall
move $t0, $s0
move $t1, $s1
# add 2 to register $t2
addi $t2, $t2, 2	
# size/2
div $t1, $t2	
# move quotient to register $t1
mflo $t1

j whileTrunk

whileTrunk: nop
		#while(numberOfTrees > 0)
		ble $t0, 0, innerWhileTrunk
		
		#if(sizeOfTrees > 0)
		ble $t1, 0, exit
		
		li $v0, 11
	
		#space 
		li $a0, 32
		syscall
	
		# straight up line
		li $a0, 124
		syscall
	
		# straight up line
		li $a0, 124
		syscall
	
		#space 
		li $a0, 32
		syscall
	
		#space 
		li $a0, 32
		syscall
		
		#space
		li $a0, 32
		syscall

		
		# numberOfTrees--;
		subi $t0, $t0, 1
		
		j whileTrunk
		
		innerWhileTrunk: nop
			#if(sizeOfTrees > 0)
			ble $t1, 0, exit #exit condition
			
			#print out everything below
			#li $v0, 11
			
			#print newline
			li $v0, 4
			la $a0, newLine
			syscall
			
			move $t0, $s0
			
			# sizeOfTrees--;
			subi $t1, $t1, 1
			
			j whileTrunk
		
#---------------------------------------------------------------
exit: nop
		li $v0, 10
		syscall

	
