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

resetsquare: or R0, R0
	movi 0, R11
	movi 0, R10
	addi 3, R10
	lshi 14, R10
	load R11, R10
	or R0, R0
	cmpi 1, R11
	jne resetsquare


keysquare: or R0, R0
	movi 0, R10
	addi 3, R10
	lshi 14, R10
	load R11, R10
	or  R0, R0
	cmpi 20, R2
	jeq stick
	or  R0, R0
	cmpi 2, R11
	jeq movesquaredown
	or  R0, R0
	cmpi 1, R3
	jeq skip
	or  R0, R0
	cmpi 3, R11
	jeq movesquareleft
skip: or  R0, R0
	cmpi 10, R4
	jeq keysquare
	or  R0, R0
	cmpi 4, R11
	jeq movesquareright
	or R0, R0
	cmpi 0, R0
	juc keysquare

movesquaredown: or R0,R0
			movi 0, R7
			movi 0, R8
			addi 100,R7
			addi 60,R7
			addi 112,R8
			subi 40, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8
			addi 1, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8
			addi 79, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7
			addi 1, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7
			subi 1, R5
			or R0, R0
			addi 1, R2
			cmpi 0, R0
			juc resetsquare

movesquareright: or R0,R0
			movi 0, R7
			movi 0, R8
			addi 100,R7
			addi 60,R7
			addi 112,R8

			subi 40, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			addi 2, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			addi 38, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8
			
			addi 2, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			subi 1, R5
			addi 1, R3
			addi 1, R4
			or R0, R0
			cmpi 0, R0
			juc resetsquare

movesquareleft: or R0,R0
			movi 0, R7
			movi 0, R8
			addi 100,R7
			addi 60,R7
			addi 112,R8

			subi 39, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			subi 2, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			addi 40, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			addi 2, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8
			
			subi 2, R5
			subi 1, R3
			subi 1, R4
			or R0, R0
			cmpi 0, R0
			juc resetsquare

square: or R0,R0
	movi 0, R5
	movi 0, R6
	movi 0, R7
	movi 2, R2
	movi 5, R3
	movi 6, R4
    addi 100,R5
    addi 109,R5
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
	addi 0, R5
	stor R5,R7
	cmp R0, R0
	juc keysquare

stick: or R0,R0
	movi 0, R5
	movi 0, R6
	movi 0, R7
	movi 1, R2
	movi 4, R3
	movi 7, R4
	addi 100, R5
	addi 108, R5
	addi 3,R6
    lshi 14,R6
	add R6,R5
	addi 100, R7
	addi 92, R7

	stor R5,R7
	addi 0, R7
	stor R5,R7
	addi 1,R5
	stor R5,R7
	addi 0,R5
	stor R5,R7
	addi 1,R5
	stor R5,R7
	addi 0,R5
	stor R5,R7
	addi 1,R5
	stor R5,R7
	addi 0,R5
	stor R5,R7
	cmp R0, R0
	juc keystick

resetstick: or R0, R0
	movi 0, R11
	movi 0, R10
	addi 3, R10
	lshi 14, R10
	load R11, R10
	or R0, R0
	cmpi 1, R11
	jne resetstick


keystick: or R0, R0
	movi 0, R10
	addi 3, R10
	lshi 14, R10
	load R11, R10
	or  R0, R0
	cmpi 20, R2
	jeq square
	or  R0, R0
	cmpi 2, R11
	jeq movestickdown
	or  R0, R0
	cmpi 1, R3
	jeq skip2
	or  R0, R0
	cmpi 3, R11
	jeq movestickleft
skip2: or  R0, R0
	cmpi 10, R4
	jeq keystick
	or  R0, R0
	cmpi 4, R11
	jeq movestickright
	or R0, R0
	cmpi 0, R0
	juc keystick

movestickdown: or R0,R0
			movi 0, R7
			movi 0, R8
			addi 100,R7
			addi 92,R7
			addi 112,R8

			addi 37, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			addi 1, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			addi 1, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			addi 1, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			subi 43, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			addi 1, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			addi 1, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			addi 1, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			addi 41, R5
			or R0, R0
			addi 1, R2
			cmpi 0, R0
			juc resetstick

movestickright: or R0,R0
			movi 0, R7
			movi 0, R8
			addi 100,R7
			addi 92,R7
			addi 112,R8

			addi 1, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7

			subi 4, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			addi 4, R5
			addi 1, R3
			addi 1, R4
			or R0, R0
			cmpi 0, R0
			juc resetstick

movestickleft: or R0,R0
			movi 0, R7
			movi 0, R8
			addi 100,R7
			addi 92,R7
			addi 112,R8

			addi 1, R5
			stor R5, R8
			addi 0, R5
			stor R5, R8

			subi 4, R5
			stor R5, R7
			addi 0, R5
			stor R5, R7
			
			addi 3, R5
			subi 1, R3
			subi 1, R4
			or R0, R0
			cmpi 0, R0
			juc resetstick

key: or R0, R0

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

