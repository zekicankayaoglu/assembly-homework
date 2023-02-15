.data
	myArray: .space 400
	msg1: .asciiz "Input length of array (2<=n<=100): "
	msg2: .asciiz "Input k (1<=k<=100): "
	msg3: .asciiz "Input array elements one by one (2<=arr[i]<=100): " 
	errorMsg: .asciiz "Please enter valid number: "
	newLine: .asciiz "\n"
	p: .asciiz "(" 
	comma: .asciiz ","
	q: .asciiz ")"
.text
	
	firstError: #if first input is invalid comes back and takes it again
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 5
	syscall
	add $t0, $v0,$zero # t0 keeps n
	add $s4, $zero, 2 #2<=n
	#checking array number is it valid or invalid
	slt $s3, $t0, $s4
	bne $s3, $zero, error1
	add $s4, $zero, 100 #n<=100
	slt $s3, $s4, $t0
	bne $s3, $zero, error1
	
	secondError:#if second input is invalid comes back and takes it again
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 5
	syscall
	#checking k input is it valid or invalid
	add $t1, $v0,$zero # t1 keeps k
	add $s4, $zero, 1 # 1<=k
	slt $s3, $t1, $s4
	bne $s3, $zero, error2
	add $s4, $zero, 100 # k<=100
	slt $s3, $s4, $t1
	bne $s3, $zero, error2
	
	li $v0, 4
	la $a0, msg3
	syscall
	
	add $t2, $zero, $zero # t2 : i
	sll $s0, $t0, 2
	
	jal while #goes first loop for taking array elements
	addi $t2, $zero, -4
	jal while1	#goes other loop to check elements to find pairs

	j exit #ends program
	while:
		beq $t2, $s0, jump #continues until the last element of array
		thirdError: #if invalid input is entered, wants input again
		li $v0, 5
		syscall
		add $s2, $v0, $zero #checking array elements inputs are they valid or invalid
		add $s4, $zero, 1
		slt $s3, $s2, $s4
		bne $s3, $zero, error3
		add $s4, $zero, 100
		slt $s3, $s4, $s2
		bne $s3, $zero, error3
		
		sw $s2, myArray($t2) #filling array with the elements
			add $t2, $t2, 4	
		j while 

	while1:
		add $t2, $t2, 4 #continues until the last element of array  t2:i
		beq $t2, $s0, exit #if array ends, then loop ends
		add $t3, $t2, 4
		j while2		
		
	while2:
		#this loop finds arr[t2] and arr[t3] and adds them then checks division to k	
		beq $t3,$s0,while1 #  t3:j
		lw $t5, myArray($t2)
		lw $t6, myArray($t3)
		add $t4, $t5, $t6
		div $t4, $t1
		mfhi $s1
		add $t4, $zero, 0
		add $t3, $t3, 4
		beq $s1, $zero, equal #if they divide k goes to eqaul and print them
		back: #comes back again and continues
		j while2		
	
	equal: #prints the pairs
	
		li $v0, 4
		la $a0, p
		syscall
		
		li $v0, 1
		move $a0, $t5
		syscall
		
		li $v0, 4
		la $a0, comma
		syscall
		
		li $v0, 1
		move $a0, $t6
		syscall
		
		li $v0, 4
		la $a0, q
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
		j back
	
	exit:#ends the program
		li $v0, 10
		syscall
	
	jump:#program continues where it left
		jr $ra
		
	error1:#prints error message and goes back
		li $v0, 4
		la $a0, errorMsg
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j firstError
	
	error2:#prints error message and goes back
		li $v0, 4
		la $a0, errorMsg
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j secondError
		
	error3:#prints error message and goes back
		li $v0, 4
		la $a0, errorMsg
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j thirdError
