#	Alexander N. Chin 	| ANC200008
#	CS 2340.002		| Karen Mazidi
#	Bitmap Project
#	Draw Macro Sheet
#############################################
.eqv		width 		256
.eqv		height 		128
.eqv		xOffset		28
.eqv		yOffset		114
.eqv		staticPointer	0x10010000
.eqv		baseColor	0xee0000
.eqv		selectedColor	0x00ffff
.eqv 		scanColor	0x00ff00

#draw pixel given coordinate and color
.macro draw_pixel (%x, %y, %colorHex)
		#save to stack
		subi	$sp, $sp, 12
		sw	$s3, ($sp)
		sw	$t0, 4($sp)
		sw	$t1, 8($sp)
		
		#coordinate = static pointer +4*(x + y*width)
		li	$s3, staticPointer
		mul	$t1, %y, width
		add	$t1, $t1, %x
		sll	$t1, $t1, 2
		add	$t0, $t1, $s3
		sw	%colorHex, ($t0)
		
		#restore from stack
		lw	$s3, ($sp)
		lw	$t0, 4($sp)
		lw	$t1, 8($sp)
		addi	$sp, $sp, 12
.end_macro

#draw colomn at x 
.macro draw_col (%x, %height, %color)
		#save to stack
		subi	$sp, $sp, 16
		sw	$s7, ($sp)
		sw	$t2, 4($sp)
		sw	$t3, 8($sp)
		sw	$t4, 12($sp)		
		
		#align x
		addi	$s7, %x, xOffset
		li	$t3, 0
		li	$t4, yOffset
drawColLoop:
		bge	$t3, %height, drawColLoopExit
		sub	$t2, $t4, $t3
		draw_pixel($s7, $t2, %color)
		addi	$t3, $t3, 1
		j	drawColLoop
drawColLoopExit:

		#restore from stack
		lw	$s7, ($sp)
		lw	$t2, 4($sp)
		lw	$t3, 8($sp)
		lw	$t4, 12($sp)
		addi	$sp, $sp, 16
.end_macro

#draw every column in array
.macro draw_all_col (%array,%black)
		#save to stack
		subi	$sp, $sp, 20
		sw	$t5, ($sp)
		sw	$t7, 4($sp)
		sw	$t8, 8($sp)	
		sw	$t9, 12($sp)
		sw	%array, 16($sp)

		li	$t5, 0		
drawAllColLoop:
		lw	$t7, (%array)		#object pointer
		beq	$t7, $0, drawAllColLoopExit
		lw	$t7, (%array)		#object pointer (do it again bc it changes for some reason)
		lw	$t9, ($t7)			#height
		bne	%black, $0, isblack
		lw	$t8, 4($t7)		#color
		j 	isblackExit
isblack:
		move $t8, $0
isblackExit:
		draw_col($t5, $t9, $t8)
		addi	%array, %array, 4
		addi	$t5, $t5, 2
		j	drawAllColLoop
drawAllColLoopExit:

		#restore from stack
		lw	$t5, ($sp)
		lw	$t7, 4($sp)
		lw	$t8, 8($sp)	
		lw	$t9, 12($sp)
		lw	%array, 16($sp)
		addi	$sp, $sp, 20
.end_macro

		 
