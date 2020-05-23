Rory Glenn
romglenn
Fall 2019
Lab2

-----------
DESCRIPTION

-

In this lab, the user will select the data source and the addresses of the read and write register.
There is a simple data path with a register file, and an ALU which processes that information.
Each processor contains a register file that holds the register used in the program execution. 
The value saved to a destination register will come from one of two sources, the keypad user input, or the output of the ALU.
The ALU in this system is a 4-bit adder that take two of the register values as inputs.

The inputs of the program are as follows: Clear, Update Register, Read Register 1 Address, Read Register 2 Address, Write Address, Keypad.
The outputs of the program are as follows: Register # Value, Keypad Output, ALU Input 1, ALU Input 2, ALU Output

-----------
FILES

-

Lab2.lgi 
- 
This files contains the MultiMedia Logic project

-----------
INSTRUCTIONS

- 

This program is intended to be run using the MultiMedia Logic software. 
Once loaded, 
1. Select simulate. 
2. Press Clear Registers to reset all register values to 0
3. Select the following inputs to store the number 7 to register 3:

Store Select:            0
Keypad:                  7
Read Register Address 1: x
Read register Address 2: x
Write Register Address:  3

4. Press Update Register to save the keypad input to the destination register

5. Select the following inputs to store the number 4 to register 1:

Store Select:            0
Keypad:                  4
Read Register Address 1: x
Read Register Address 2: x
Write Register Address:  1

6. Press Update Register to save the keypad input to the destination register.

7. Select the following to store the sum of registers 1 and 3 to register 0:



Store Select:            1
Keypad:                  x
Read Register Address 1: 1
Read Register Address 2: 3
Write Register Address:  0

8. Press Update Register to save the ALU output to the destination register.

