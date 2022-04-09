#	Alexander N. Chin 	| ANC200008
#	CS 2340.002		| Karen Mazidi
#	Bitmap Project
#	Main file
#############################################
#	Instructions:
#	connect bitmap:
#		Unit:		4X4
#		Display:	1024X512
#		Base address for display: 0x10010000 (static data)
#	connect keyboard:
#		use the following keys to traverse the visualizer:
#		1: bubble sort
#		2: insertion sort
#		3: selection sort
#		4: quick sort
#		0: exit
#		all other keys will be ignored
#############################################
.include 	"Syscalls.asm"
.include	"Draw.asm"
.include	"Sort.asm"
.include	"Quicksort.asm"

#constants
.eqv		arrSize		100
.eqv		maxSize		100
.eqv		ObjSpace	12		#height, color, x
	
.data
welcomeMsg:			.asciiz 		"Hello! Welcome to my sorting algorithm visualizer.\n"
					.align		2
displayInstructions:	.asciiz 		"\nIf you haven't already, make sure to open the bitmap display,\nset the unit width and height to 4 pixels and the display width and height to 1024 and 512 pixels respectively,\nleave the base address for display at the default (0x10010000(static data)),\nand click the \"connect to MIPS\" button in the bottom right.\n"			
					.align		2
keyboardInstructions:	.asciiz		"\nAlso, make sure to open the Keyboard and Display MMO Simulator in and connect it to MIPS just like you did for the bitmap display. \nThe bottom text box is where you will be typing your inputs to control which algorithm you want to visualize.\n"			
					.align		2
GeneralInstructions:	.asciiz		"\nPress the following keys to play its associated sorting algorithm visualization:\n1: Bubble Sort\n2: Insertion Sort\n3: Selection Sort\n4: Quick Sort\n...\n0: Exit\n\n"			
					.align		2
insertionSortSwaps:	.asciiz 		"\nnumber of comparisons to execute insertion sort over an array of 100 elements: "
					.align		2
bubbleSortSwaps:		.asciiz 		"\nnumber of comparisons to execute bubble sort over an array of 100 elements: "
					.align		2
SelectionSortSwaps:	.asciiz 		"\nnumber of comparisons to execute selection sort over an array of 100 elements: "
					.align		2
quickSortSwaps:		.asciiz 		"\nnumber of comparisons to execute quick sort over an array of 100 elements: "
					.align		2
array:				.space		400 		#4 * 100
					.align		2

.text
main:

		li	$a0, arrSize
		jal	GenerateArray
		
		#draw initial array
		la	$a0, array
		draw_all_col ($a0, $0)
		
		#print welcome and instruction messages
		dprintstrlabel(welcomeMsg)
		dprintstrlabel(displayInstructions)
		dprintstrlabel(keyboardInstructions)
		dprintstrlabel(GeneralInstructions)
		
mainLoop:
	lw $t0, 0xffff0000  			#stores keyboard input
    	beq $t0, 0, mainLoop   		#If no input, keep displaying
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 48, exit			# input 0
	beq	$s1, 49, bubbleSort 	# input 1
	beq	$s1, 50, insertionSort 	# input 2
	beq	$s1, 51, selectionSort  	# input 3
	beq	$s1, 52, quickSort		# input 4
	# invalid input, ignore
	j	mainLoop

exit:
		Exit
bubbleSort:
		#reset bitmap
		la	$a0, array
		randomize ($a0)			
		#bubble sort
		la	$a0, array
		bubble_sort ($a0)
		#camparison messages
		dprintstrlabel(bubbleSortSwaps)
		dprintint($v1)
		la	$a0, array
		#play sound sweep
		sweep($a0)
		j	mainLoop
insertionSort:
		#reset bitmap
		la	$a0, array
		randomize ($a0)
		#insertion sort
		la	$a0, array
		insertion_sort ($a0)
		#camparison messages
		dprintstrlabel(insertionSortSwaps)
		dprintint($v1)
		la	$a0, array
		#play sound sweep
		sweep($a0)
		j	mainLoop
selectionSort:
		#reset bitmap
		la	$a0, array
		randomize ($a0)
		#selection sort
		la	$a0, array
		selection_sort ($a0)
		#camparison messages
		dprintstrlabel(SelectionSortSwaps)
		dprintint($v1)
		la	$a0, array
		#play sound sweep
		sweep($a0)
		j	mainLoop
quickSort:
		#reset bitmap
		la	$a0, array
		randomize ($a0)
		#quick sort
		la	$a0, array
		move $a1, $v1
		li	$v1, 0
		jal	quick_sort
		#camparison messages
		dprintstrlabel(quickSortSwaps)
		dprintint($v1)		
		la	$a0, array
		#play sound sweep
		sweep($a0)		
		j 	mainLoop
		
#generate array of object pointers		
#$a0 = size
GenerateArray:
		#save to stack
		subi	$sp, $sp, 12
		sw	$a0, ($sp)
		sw	$a1, 4($sp)
		sw	$ra, 8($sp)
		
		#initialize variables before loop
		li	$t0, 0		#i = 0
		la	$t1, array
		move $s1, $a0
GenerateArrayLoop:
		bge	$t0, $s1, GenerateArrayLoopExit
		AllocateDMemory(ObjSpace)
		sw	$v0, ($t1)				#save new object pointer into array space
		move $s0, $v0
		random_int(maxSize)		#generate random number between 0-100 in $a0
		addi	$a0, $a0, 1			#min = 1
		sw	$a0, ($s0)				#save as height
		sll	$a0, $a0, 1
		addi	$a0, $a0, baseColor	#offset height to be used as color
		sw	$a0, 4($s0)			#save color
		sw	$t0, 8($s0)			#save x val
		#increment pointers	
		addi	$t1, $t1, 4
		addi	$t0, $t0, 1
		j	GenerateArrayLoop
GenerateArrayLoopExit:
		#restore from stack
		lw	$a0, ($sp)
		lw	$a1, 4($sp)
		lw	$ra, 8($sp)
		addi	$sp, $sp, 12
		jr	$ra
		
#quick sort the array by breaking it down into partitions via a pivot
#input: $a0 -> start address, $a1 -> end address  
#output: $v1 -> comparisons
quick_sort:
		#save to stack
		subi	$sp, $sp, 12
		sw	$ra, ($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		
		#base case: 
		bge	$a0, $a1, quick_sortDone
		la	$s2, array
		blt	$a0, $s2, quick_sortDone
		
		#save start and end
		move $s0, $a0
		move $s1, $a1
		#partition array based on pivot=last element 
		partition($a0, $a1)
		move $a1, $v0			#save address of pivot
		
		#quicksort (start, index-1)
		subi	$a1, $a1, 4		#pivot-1
		move $a0, $s0
		jal	quick_sort		
		
		#quicksort (index+1, end)
		addi	$a0, $a1, 8
		move $a1, $s1
		jal	quick_sort	
		
quick_sortDone:
		#restore from stack
		lw	$ra, ($sp)
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		addi	$sp, $sp, 12
		jr	$ra

		
