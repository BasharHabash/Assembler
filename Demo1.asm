# Created by: Bashar Al-Habash, Kolby Silim & Paul Brown
# This the demo that we showed on Friday the 7th, 2019

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
main:	cmpi 0, R0
		jeq stick	


moveDown: or R0, R0
		  movi 0, R3
		  addi 100, R3
		  addi 28, R3
		  stor R4, R3
		  addi 1, R4
		  stor R4, R3
		  addi 1, R4
		  stor R4, R3
		  addi 1, R4
		  stor R4, R3
		  addi 37,R4
		  cmpi 0, R0
		  juc R2

stick:  or R0, R0
		addi 3,R6
        lshi 14,R6
		addi 100,R4
        addi 110,R4
		add R6,R4
		
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0	
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0,R0
		cmpi 0, R0
		jal R2,moveDown
		or R0, R0


		
 
 square: movi 0, R5
		movi 0, R6
		movi 0, R7
		movi 0, R12
		addi 100,R5
        addi 105,R5
		addi 40, R5
        addi 3,R6
        lshi 14,R6
        add R6,R5
        addi 100,R7
		addi 60,R7
        stor R5,R7

        addi 100,R12
        addi 106,R12
		addi 40 R12
        add R6,R12
        stor R12,R7

        addi 40,R5
        stor R5,R7

        addi 40,R12
        stor R12,R7

		addi 40,R5
        stor R5,R7

        addi 40,R12
        stor R12,R7

		or R0,R0
		or R0,R0
        or R0,R0
		or R0,R0
		or R0,R0
		or R0,R0
		or R0,R0
		or R0,R0
		
sblock: movi 0, R5
		movi 0, R6
		movi 0, R7
		movi 0, R12
		addi 100,R5
        addi 105,R5
		addi 120, R5
        addi 3,R6
        lshi 14,R6
        add R6,R5
        addi 100,R7
		addi 44,R7
        stor R5,R7

		addi 100,R12
        addi 106,R12
		addi 120, R12
        add R6,R12
        stor R12,R7
		
        addi 40,R12
        stor R12,R7
		
		addi 1, R12
		stor R12, R7

		addi 40,R12
        stor R12,R7
		
		addi 1, R12
		stor R12, R7
		
		or R0,R0
		or R0,R0
        or R0,R0
		or R0,R0
		or R0,R0
		or R0,R0
		or R0,R0
		or R0,R0

tblock: movi 0, R5
		movi 0, R6
		movi 0, R7
		movi 0, R12
        addi 3,R6
        lshi 14,R6
        addi 100,R7
		addi 76,R7

		addi 120,R12
        addi 125,R12
		addi 120, R12
		addi 120, R12
        add R6,R12
        stor R12,R7
		
        addi 1,R12
        stor R12,R7
		
		addi 1, R12
		stor R12, R7

		addi 1,R12
        stor R12,R7

		addi 100,R5
        addi 106,R5
		addi 120, R5
		addi 120, R5
        add R6,R5
        stor R5,R7

		addi 0, R5,
		stor R5, R7

key:	or R0, R0
		movi 0, R10
		movi 0, R11
		movi 0, R9
		addi 3, R10
		lshi 14, R10
		load R11, R10
		addi 0, R9
		add R6, R9
		or R0, R0
		addi 30, R9
		stor R9, R11
		addi 2, R9
		stor R9, R11
		addi 77, R9
		addi 1, R9
		stor R9, R11
		addi 0, R9
		stor R9, R11
		addi 1, R9
		stor R9, R11
		addi 0, R9
		stor R9, R11
		addi 1, R9
		stor R9, R11
		addi 1, R9
		stor R9, R11
		addi 1, R9
		stor R9, R11
		addi 37, R9
		stor R9, R11
		addi 4, R9
		stor R9, R11
		addi 1, R9
		stor R9, R11
		cmpi 0, R0
		juc key
		
loop: 	cmp R13, R14
		or R0, R0
		juc loop