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
cmp R0,R0
jal R2, square
or R0,R0
key: or R0, R0
	movi 0, R10
	movi 0, R12
	movi 0, R13
	movi 0, R14
	movi 0, R15
	addi 3, R10
	lshi 14, R10
	load R11, R10
	addi 117, R13
	addi 116, R14	
	addi 107, R15
	addi 114, R12 
	cmp R11, R12
	jeq stick
	cmp R11, R13
	jeq tblock
	cmp R11, R14
	jeq sblock
	cmp R11, R15
	jeq lblock
	cmpi 0, R0
	juc key
square: or R0,R0
	movi 0, R5
	movi 0, R6
	movi 0, R7
    addi 100,R5
    addi 105,R5
    addi 40, R5
    addi 3,R6
    lshi 14,R6
    add R6,R5
    addi 100,R7
    addi 60,R7
    stor R5,R7
    addi 1,R5
	stor R5,R7
    addi 40,R5
    stor R5,R7
    subi 1,R5
    stor R5,R7
	cmp R0, R1
	juc R2
stick: or R0,R0
	movi 0, R5
	movi 0, R6
	movi 0, R7
	addi 8, R5
	addi 100, R5
	addi 100, R5
	addi 100, R5
	addi 100, R5
	addi 100, R5
	addi 100, R5
	addi 3,R6
    lshi 14,R6
	add R6,R5
	addi 100, R7
	addi 92, R7
	stor R5,R7
	addi 1,R5
	stor R5,R7
	addi 1,R5
	stor R5,R7
	addi 1,R5
	stor R5,R7
	stor R5,R7
	cmp R0, R1
	juc key
tblock: or R0,R0
		movi 0, R5
		movi 0, R6
		movi 0, R7
		addi 9, R5
		addi 100, R5
		addi 100, R5
		addi 3,R6
        lshi 14,R6
		add R6,R5
		addi 108, R7
		addi 100, R7
		stor R5,R7
		addi 40, R5
		stor R5,R7
		subi 1, R5
		stor R5,R7
		addi 2, R5
		stor R5,R7
		stor R5,R7
		cmp R0, R1
		juc key
sblock: or R0,R0
		movi 0, R5
		movi 0, R6
		movi 0, R7
		addi 13, R5
		addi 100, R5
		addi 100, R5
		addi 100, R5
		addi 100, R5
		addi 3,R6
        lshi 14,R6
		add R6,R5
		addi 124, R7
		addi 100, R7
		stor R5,R7
		addi 1, R5
		stor R5,R7
		addi 40, R5
		stor R5,R7
		addi 1, R5
		stor R5,R7
		stor R5,R7
		cmp R0, R1
		juc key
lblock: or R0,R0
		movi 0, R5
		movi 0, R6
		movi 0, R7
		addi 3, R5
		addi 100, R5
		addi 100, R5
		addi 100, R5
		addi 100, R5
		addi 100, R5
		addi 100, R5
		addi 3,R6
        lshi 14,R6
		add R6,R5
		addi 126, R7
		addi 50, R7
		stor R5,R7
		addi 40,R5
		stor R5,R7
		addi 40,R5
		stor R5,R7
		addi 40,R5
		stor R5,R7
		addi 1,R5
		stor R5,R7
		cmp R0, R1
		juc key	
nothing: add R0, R15
juc nothing

