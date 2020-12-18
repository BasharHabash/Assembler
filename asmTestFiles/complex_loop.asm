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
addi 100,R2
addi 28,R2
addi 3,R3
lshi 14,R3
addi 100,R4
addi 28,R4
add R3,R4
stor R4,R2
loop: load R5,R3
add R0,R15
cmpi 117,R5
jne loop
addi 1, R4
stor R4,R2
addi 40,R4
stor R4,R2
addi 1,R4
stor R4,R2
nothing: add R0, R15
juc nothing
