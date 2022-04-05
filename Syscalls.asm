#	Alexander N. Chin 	| ANC200008
#	CS 2340.002		| Karen Mazidi
#	Bitmap Project
#	Syscall Macro Sheet
#############################################

.eqv SyscallPrintInt 1		# $a0 -> output
.eqv SyscallPrintString 4	# $a0 -> output
.eqv SyscallAllocMemory 9	# Number of bytes -> $a0
.eqv SyscallExit 10			# Exit
.eqv SyscallRandomRg 42	# RNG ID -> $a0, upper bound -> $a1
.eqv SyscallMidiOut 31		# pitch -> $a0, duration -> $a1, instrument -> $a2, volume -> $a3
# Prints the string input
.macro PrintString (%str)
la $a0, %str
li $v0, SyscallPrintString
syscall
.end_macro

# Prints out the integer set of $a0
.macro PrintInt
li $v0, SyscallPrintInt
syscall
.end_macro 

# Exits Program
.macro Exit
li $v0, SyscallExit
syscall
.end_macro

# Reads input string
.macro ReadString(%buffer, %size)
la $a0, %buffer
li $a1, %size
li $v0, SyscallReadString 
syscall
.end_macro 

# Allocate memory in heap
.macro AllocateDMemory(%size)
li $a0, %size
li $v0, SyscallAllocMemory
syscall
.end_macro

# save to stack
.macro save_a0_v0
sw $a0, -4($sp)
sw $v0, -8($sp)
.end_macro

# restore from stack
.macro load_a0_v0
lw $a0, -4($sp)
lw $v0, -8($sp)
.end_macro

#############################################
# register safe syscalls
# $a0 & $v0 not changed

# pause for x ms
.macro pause(%time)
save_a0_v0
addi $a0, $zero, %time
li $v0, 32
syscall
load_a0_v0
.end_macro

#print(int)
.macro dprintint(%int)
save_a0_v0
addu $a0, $zero, %int
PrintInt
load_a0_v0
.end_macro 

#print(string address)
.macro dprintstrlabel(%strlabel)
save_a0_v0
PrintString(%strlabel)
load_a0_v0
.end_macro

#print string and string label
.macro dprints_label(%description, %strlabel)
dprints(%description)
dprints(" '")
dprintstrlabel(%strlabel)
dprints("'\n")
.end_macro

#generate random number 0-max 
#output in $a0
.macro random_int(%max)
li $v0, SyscallRandomRg
li $a1, %max
syscall
.end_macro

#play a sound based on inputed pitch
.macro play_sound(%pitch)
sw $a0, -4($sp)
sw $v0, -8($sp)
sw $a1, -12($sp)
sw $a2, -16($sp)
sw $a3, -20($sp)

li $v0, SyscallMidiOut
move $a0, %pitch
li $a1, 1000
li $a2, 0 		#synth lead
li $a3, 80	 	#volume
syscall

lw $a0, -4($sp)
lw $v0, -8($sp)
lw $a1, -12($sp)
lw $a2, -16($sp)
lw $a3, -20($sp)
.end_macro
