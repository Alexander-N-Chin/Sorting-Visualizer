#	Alexander N. Chin 	| ANC200008
#	CS 2340.002		| Karen Mazidi
#	Bitmap Project
#	Sorting Macro Sheet
#############################################
#sweep through array once and play sound
.macro sweep (%array)
		#save to stack 
		subi	$sp, $sp, 24
		sw	$a0, ($sp)
		sw	$a1, 4($sp)
		sw	$t1, 8($sp)
		sw	$t2, 12($sp)
		sw	$a2, 16($sp)
		sw	$s3, 20($sp)
		
		li	$s0, selectedColor
		move $t1, %array		
sweepLoop:
		lw	$t2, ($t1)				#load object pointer
		ble	$t2, $0, sweepLoopExit
		lw	$a0, ($t2)				#load height
		lw	$a1, 4($t2)			#load color
		lw	$a2, 8($t2)			#load x
		sll	$a2, $a2, 1
		draw_col($a2, $a0, $s0)		#select
		play_sound($a0)
		pause(65)
		draw_col($a2, $a0, $a1)		#deselect
		addi	$t1, $t1, 4
		j	sweepLoop
sweepLoopExit:
		
		#restore from stack 
		lw	$a0, ($sp)
		lw	$a1, 4($sp)
		lw	$t1, 8($sp)
		lw	$t2, 12($sp)
		lw	$a2, 16($sp)
		lw	$s3, 20($sp)
		addi	$sp, $sp, 24
.end_macro

.macro randomize (%array)
		#save to stack 
		subi	$sp, $sp, 16
		sw	$a0, ($sp)
		sw	$a1, 4($sp)
		sw	$t1, 8($sp)
		sw	$t2, 12($sp)
		
		#erase current array
		la	$a0, array
		li	$a1, 1
		draw_all_col ($a0, $a1)
		
		move $t1, %array		
randomizeLoop:
		lw	$t2, ($t1)				#load object pointer
		ble	$t2, $0, randomizeLoopExit
		random_int(100)			#generate random number between 0-100 in $a0
		addi	$a0, $a0, 1			#min = 1
		sw	$a0, ($t2)				#save new height
		sll	$a0, $a0, 1
		addi	$a0, $a0, baseColor
		sw	$a0, 4($t2)			#save new color
		move $v1, $t1 
		addi	$t1, $t1, 4
		j	randomizeLoop
randomizeLoopExit:
		la	$a0, array
		draw_all_col ($a0, $0)
		
		#restore from stack 
		lw	$a0, ($sp)
		lw	$a1, 4($sp)
		lw	$t1, 8($sp)
		lw	$t2, 12($sp)
		addi	$sp, $sp, 16
.end_macro		

#insertion sort 
#input: array address register
#output: number of swaps in $v1
.macro insertion_sort(%array)
		#save to stack 
		subi	$sp, $sp, 80
		sw	$s0, ($sp)
		sw	$s1, 4($sp)
		sw	$t0, 8($sp)
		sw	$t1, 12($sp)
		sw	$t2, 16($sp)
		sw	$t3, 20($sp)
		sw	$t4, 24($sp)
		sw	$t5, 28($sp)
		sw	$t6, 32($sp)
		sw	$t7, 36($sp)
		sw	$t8, 40($sp)
		sw	$t9, 44($sp)
		sw	$s2, 48($sp)
		sw	$s3, 52($sp)
		sw	$s4, 56($sp)
		sw	$s5, 60($sp)
		sw	$s6, 64($sp)
		sw	$s7, 68($sp)
		sw	$a2, 72($sp)
		sw	$a3, 76($sp)
		
		#initialize variables before loop
		li	$v1, 0			#swap counter
		li	$t1, 1			#i = 1
		li	$a3, selectedColor	#selected color
		move $s1, %array
		addi	$s1, $s1, 4	
InsSortOuterLoop:	
		move $t2, $t1			#i = j
		move $s2, $s1
		lw	$t3, ($s1)			#load array pointer
		ble	$t3, $0, InsSortOuterLoopExit	#while i < length
		lw	$t5, 8($t3)		#load x	
		sll	$t5, $t5, 1
		lw	$a2, ($t3)			#load height
		draw_col($t5, $a2, $a3)
InsSortInnerLoop:	
		lw	$t6, ($s2)			#load array pointer of j
		lw	$t7, ($t6)			#load height of j
		lw	$s0, 4($t6)		#load color of j
		lw	$t8, 8($t6)		#load x of j
		sll	$t8, $t8, 1
		ble	$t2, $0, InsSortInnerLoopExit		#while j > 0
		subi	$s6, $s2, 4
		lw	$s7, ($s6)			#load array pointer of j-1
		lw	$s3,	($s7)		#load height of j-1
		lw	$s5, 4($s7)		#load color of j-1
		lw	$s4, 8($s7)		#load x of j-1
		sll	$s4, $s4, 1
		
		addi	$v1, $v1, 1		#increment swap counter
		ble	$s3, $t7, InsSortInnerLoopExit	#while  A[j] < A[j-1]
			
		#select and black out A[j-1] and A[j]
		draw_col($t8, $t7, $a3)
		draw_col($s4, $s3, $a3)
		pause(7)
		draw_col($t8, $t7, $0)
		draw_col($s4, $s3, $0)
			
		#swap A[j-1] and A[j]
		sw	$s3, ($t6)
		sw	$t7,	($s7)
		sw	$s5, 4($t6)
		sw	$s0, 4($s7)
		draw_col($s4, $t7, $s0)
		draw_col($t8, $s3, $s5)
		subi	$s2, $s2, 4		
		subi	$t2, $t2, 1		#j = j - 1
		j	InsSortInnerLoop
InsSortInnerLoopExit:	
		addi	$t1, $t1, 1		#i = i + 1
		addi	$s1, $s1, 4
		j	InsSortOuterLoop
InsSortOuterLoopExit:	
		move $a0, %array
		draw_all_col ($a0, $0)
			
		#restore from stack
		lw	$s0, ($sp)
		lw	$s1, 4($sp)
		lw	$t0, 8($sp)
		lw	$t1, 12($sp)
		lw	$t2, 16($sp)
		lw	$t3, 20($sp)
		lw	$t4, 24($sp)
		lw	$t5, 28($sp)
		lw	$t6, 32($sp)
		lw	$t7, 36($sp)
		lw	$t8, 40($sp)
		lw	$t9, 44($sp)
		lw	$s2, 48($sp)
		lw	$s3, 52($sp)
		lw	$s4, 56($sp)
		lw	$s5, 60($sp)
		lw	$s6, 64($sp)
		lw	$s7, 68($sp)
		lw	$a2, 72($sp)
		lw	$a3, 76($sp)	
		addi	$sp, $sp, 80
.end_macro
		
#bubble sort implementation
#input: array address register
#output: number of swaps stored in $v1
.macro bubble_sort (%array)
		#save to stack
		subi	$sp, $sp, 48
		sw	$s0, ($sp)
		sw	$s1, 4($sp)
		sw	$t0, 8($sp)
		sw	$t1, 12($sp)
		sw	$t2, 16($sp)
		sw	$t3, 20($sp)
		sw	$t4, 24($sp)
		sw	$t5, 28($sp)
		sw	$t6, 32($sp)
		sw	$t7, 36($sp)
		sw	$t8, 40($sp)
		sw	$t9, 44($sp)
		
		#initialize variables before loop
		li	$v1, 0			#number of swaps
		li	$t9, selectedColor	#selected color
bubbleSortOuterLoop:
		beq	$t1, $0, bubbleSortOuterLoopExit
		li	$t1, 0			#swapped = false
		li	$t4, 0			#i = 0
		move $s1, %array		
bubbleSortInnerLoop:
		lw	$t2, ($s1)			#object pointer i
		lw	$t3, 4($s1)		#object pointer i+1
		ble	$t3, $0, bubbleSortInnerLoopExit
		lw	$t5, ($t2)			#load height of i
		lw	$t6, ($t3)			#load height of i + 1
		lw	$s0, 4($t2)		#load color of i
		lw	$s2, 4($t3)		#load color of i + 1
		lw	$t7, 8($t2)		#load x of i
		lw	$t8, 8($t3)		#load x of i + 1
		sll	$t7, $t7, 1		#multiply by two to get spacing
		sll	$t8, $t8, 1
		
		addi	$v1, $v1, 1		#increment comparison counter
		ble	$t5, $t6, else
		#black out previous line
		draw_col($t7, $t5, $t9)	#redraw current colomns in different color
		draw_col($t8, $t6, $t9)
		pause(5)
		draw_col($t7, $t5, $0)	#black out previous colomns
		draw_col($t8, $t6, $0)
		
		#swap
		sw	$t6, ($t2)			#swap height values
		sw	$t5, ($t3)
		sw	$s2, 4($t2)		#swap colors
		sw	$s0, 4($t3)
		draw_col($t7, $t6, $s2)	#draw new cols
		draw_col($t8, $t5, $s0)
		li	$t1, 1			#swapped = true
else:
		addi	$s1, $s1, 4
		addi	$t4, $t4, 1
		j	bubbleSortInnerLoop
bubbleSortInnerLoopExit:
		j	bubbleSortOuterLoop
bubbleSortOuterLoopExit:	

		#restore from stack
		lw	$s0, ($sp)
		lw	$s1, 4($sp)
		lw	$t0, 8($sp)
		lw	$t1, 12($sp)
		lw	$t2, 16($sp)
		lw	$t3, 20($sp)
		lw	$t4, 24($sp)
		lw	$t5, 28($sp)
		lw	$t6, 32($sp)
		lw	$t7, 36($sp)
		lw	$t8, 40($sp)
		lw	$t9, 44($sp)	
		addi	$sp, $sp, 48
.end_macro

#selection sort
#input: array address register
#output: number of swaps in $v1
.macro selection_sort (%array)
		#save to stack
		subi	$sp, $sp, 68
		sw	$t0, ($sp)
		sw	$t1, 4($sp)
		sw	$t2, 8($sp)
		sw	$t3, 12($sp)
		sw	$t4, 16($sp)
		sw	$t5, 20($sp)
		sw	$t6, 24($sp)
		sw	$t7, 28($sp)
		sw	$t8, 32($sp)
		sw	$t9, 36($sp)
		sw	$s0, 40($sp)
		sw	$s1, 44($sp)
		sw	$s2, 48($sp)
		sw	$a0, 52($sp)
		sw	$a1, 56($sp)
		sw	$a2, 60($sp)
		sw	$a3, 64($sp)

		#initialize variables before loop
		li	$v1, 0			#swap counter
		li	$t1, 0			#i = 0
		li	$s0, selectedColor	#selected color
		move $s1, %array
		li	$a0, maxSize
		li	$k0, scanColor
SelSortOuterLoop:
		lw	$t2, ($s1)			#load object pointer i
		lw	$t3, 4($s1)		#load object pointer i + 1
		addi	$s2, $s1, 4		#j = i + 1	
		ble	$t3, $0, SelSortOuterLoopExit
		
		#load i
		lw	$a1, ($t2)			#load height of i
		lw	$a2, 4($t2)		#load color of i
		lw	$a3, 8($t2)		#load x of i
		sll	$a3, $a3 1
		#select i
		move $t6, $a1
		move $t7, $a2
		move $t8, $a3
		#save as first scanner
		move $s4, $t6
		move $k1, $t7
		move $s6, $t8
SelSortInnerLoop:	
		lw	$t4, ($s2)
		ble	$t4, $0, SelSortInnerLoopExit
		lw	$t0, ($t4)			#load height of j
		lw	$t5, 4($t4)		#load color of j
		lw	$t9, 8($t4)		#load x of j
		sll	$t9, $t9, 1
		move $s4, $t0
		move $k1, $t5
		move $s6, $t9
		draw_col($s6, $s4, $k0)	#color new scanner
		addi	$v1, $v1, 1		#increment comparison counter
		pause(5)
		bge	$t0, $t6, minExit
		draw_col($t8, $t6, $t7)	#recolor old min
		draw_col($a3, $a1, $s0) #draw i again
		
		#change min to j
		move $t6, $t0			
		move $t7, $t5
		move $t8, $t9
		move $s5, $t4	
		draw_col($t8, $t6, $s0) 
minExit:
		addi	$s2, $s2, 4
		draw_col($s6, $s4, $k1)	#recolor old scanner
		draw_col($t8, $t6, $s0) 	#reselect min
		j	SelSortInnerLoop 
SelSortInnerLoopExit:
		#clear min and i col
		draw_col($a3, $a0, $0)
		draw_col($t8, $a0, $0)
		
		#swap i and min			
		sw	$t6, ($t2)			#load height of i
		sw	$t7, 4($t2)		#load color of i
		sw	$a1, ($s5)			#load height of j
		sw	$a2, 4($s5)		#load color of j
		draw_col($t8, $a1, $a2)
		draw_col($a3, $t6, $t7)			
		addi	$s1, $s1, 4
		j	SelSortOuterLoop		
SelSortOuterLoopExit:	

		#restore from stack
		lw	$t0, ($sp)
		lw	$t1, 4($sp)
		lw	$t2, 8($sp)
		lw	$t3, 12($sp)
		lw	$t4, 16($sp)
		lw	$t5, 20($sp)
		lw	$t6, 24($sp)
		lw	$t7, 28($sp)
		lw	$t8, 32($sp)
		lw	$t9, 36($sp)
		lw	$s0, 40($sp)
		lw	$s1, 44($sp)
		lw	$s2, 48($sp)
		lw	$a0, 52($sp)
		lw	$a1, 56($sp)
		lw	$a2, 60($sp)
		lw	$a3, 64($sp)	
		addi	$sp, $sp, 68
.end_macro



