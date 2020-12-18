
# Modified by: Bashar AlHabash & Paul Brown
#
# Fibn.s - compute the nth Fibonacci number
#	
# C-code that this assembly code came from
#
# int fibn(void)
# {
#  int n = 8;		/* Compute nth Fibonacci number */
#  int f1 = 1, f2 = -1	/* last two Fibonacci numbers   */
#  
#  while (n != 0) {	/* count down to n = 0          */
#    f1 = f1 + f2;
#    f2 = f1 - f2;
#     n = n - 1;
#   }
#   return f1;
#  }
#
#
# Register usage: $3=n, $4=f1, $5=f2
# return value written to address 128 for fib(0), 129 for fib(1), 130 for fib(2), ... 141 for fib(13)
#
# Then the program goes in an infinite loop reading switch values from address 255 in memory	
# and writing the result of what the LED should display in the same address.

	
movi 0,R0
movi 0,R1
movi 0,R2
movi 0,R3
movi 0,R4
movi 0,R5
movi 0,R6
movi 0,R7
movi 0,R8
movi 0,R9
movi 0,R10
movi 0,R11
movi 0,R12
movi 0,R13
movi 0,R14
movi 0,R15



jump: addi 2,R2
addi 3,R3
lshi 14,R3
add R3,R2
addi 100,R4
addi 77, R4
stor R4,R2

addi 10,R5
addi 3,R6
lshi 14,R6
add R6,R5
addi 49,R7
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5


addi 40,R5
add R6,R5
stor R7,R5

cmp R13, R14
jeq jump

