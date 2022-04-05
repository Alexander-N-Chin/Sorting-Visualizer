#	Alexander N. Chin 	| ANC200008
#	CS 2340.002		| Karen Mazidi
#	Bitmap Project
#	Quicksort Macro Sheet
#############################################

#swap two cols given object address pointers
.macro swap(%a, %b)
		#save to stack
		subi	$sp, $sp, 36
		sw	$t5, ($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)	
		sw	$s2, 12($sp)	
		sw	$s3, 16($sp)	
		sw	$t6, 20($sp)
		sw	$t7, 24($sp)
		sw	$s4, 28($sp)	
		sw	$s5, 32($sp)
		
		#address to object pointer
		lw	$s3, (%a)
		lw	$s5, (%b)

		li	$s0, selectedColor
		lw	$k0, ($s3)		#load height of i
		lw	$s2, 4($s3)	#load color of i
		lw	$s4, 8($s3)	#load x of i
		sll	$s4, $s4, 1
		lw	$t5, ($s5)		#load height of j
		lw	$t6, 4($s5)	#load color of j
		lw	$t7, 8($s5)	#load x of j	
		sll	$t7, $t7, 1	
		
		#select and black out columns
		draw_col($s4, $k0, $s0)
		draw_col($t7, $t5, $s0)
		pause(10)
		draw_col($s4, $k0, $0)
		draw_col($t7, $t5, $0)
		
		#swap
		sw	$t5, ($s3)		#swap height of i
		sw	$t6, 4($s3)	#swap color of i
		sw	$k0, ($s5)		#swap height of j
		sw	$s2, 4($s5)	#swap color of j
		draw_col($s4, $t5, $t6)
		draw_col($t7, $k0, $s2)
		
		#restore from stack
		lw	$t5, ($sp)
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)	
		lw	$s2, 12($sp)	
		lw	$s3, 16($sp)	
		lw	$t6, 20($sp)
		lw	$t7, 24($sp)
		lw	$s4, 28($sp)
		lw	$s5, 32($sp)
		addi	$sp, $sp, 36
.end_macro

		
.macro partition(%start, %end)
		#save to stack
		subi	$sp, $sp, 36
		sw	$t0, ($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)	
		sw	$s2, 12($sp)	
		sw	$s3, 16($sp)	
		sw	$t1, 20($sp)
		sw	$t5, 24($sp)
		sw	$t3, 28($sp)
		sw	$t4, 32($sp)
		
		#pivot = A[end]
		lw	$t0, (%end)
		lw	$s0, ($t0)
		
		#temp pivot index i
		subi	$s1, %start, 4
		
		#for j = lo to hi-1
		move $t0, %start
		subi	$t1, %end, 4	
partitionLoop:
		bgt	$t0, $t1, partitionLoopExit
		lw	$t5, ($t0)		#load height of j
		lw	$t5, ($t5)
		
		#if A[j] <= pivot, move i forward
		addi	$v1, $v1, 1 	#increment comparison counter
		bgt 	$t5, $s0, pivotMoveElse
		addi	$s1, $s1, 4	#move i forward
		swap($s1, $t0)
pivotMoveElse:
		addi $t0, $t0, 4
		j	partitionLoop	
partitionLoopExit:
		addi	$s1, $s1, 4	#move i forward
		swap($s1,%end)
		move $v0, $s1
		
		#restore from stack
		lw	$t0, ($sp)
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)	
		lw	$s2, 12($sp)	
		lw	$s3, 16($sp)	
		lw	$t1, 20($sp)
		lw	$t5, 24($sp)
		lw	$t3, 28($sp)
		lw	$t4, 32($sp)
		addi	$sp, $sp, 36
.end_macro 
