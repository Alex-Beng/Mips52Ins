# Test File for 7 Instruction, include:
# ADDU/SUBU/LW/SW/ORI/BEQ/JAL
################################################################
### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0

.text
begin:
	addi $t1, $0, -17
	addi $t2, $0, 3
	sb $t1, 0($0)
	sb $t1, 4($0)
	sh $t1, 0($0)
	sh $t1, 4($0)
	sw $t1, 8($0)
	
	lb $t1, 0($0)
	lb $t1, 4($0)	
	lbu $t1, 0($0)
	lbu $t1, 4($0)
	lh $t1, 0($0)
	lhu $t1, 4($0)
	lw $t1, 0($0)
	lw $t1, 4($0)
	
	
	div $t1, $t2
	mfhi $1
	mflo $1
	mthi $0
	mthi $t1
	mtlo $0
	mtlo $t2
	addi $t1, $0, 17
	addi $t2, $0, -3
	div $t1, $t2
	addi $t1, $0, -17
	addi $t2, $0, -3
	div $t1, $t2
	addi $t1, $0, 17
	addi $t2, $0, 3
	div $t1, $t2
	
	divu $t1, $t2
	mult $t1, $t2
	multu $t1, $t2
	
	ori $1, $0, 0x2
	j yya
	ori $2, $0, 0x2
yya:
	jal yyaa
	sllv $7, $2, $1
	
yyaa:
	ori $2, $0, 0x3000
	addi $2, $2, 0x24
	
	
	jr $2
	srl  $7, $2, 4 
	srav $7, $2, $1
	subi $2, $2, 0x24
	jalr $2
	
	
	bltz $3, ya
	#beq $1, $2, loo2
	# bgtz $1, yaya

	blez $0, yaya
ya: 
	bgezal $3, ya
	# bgez $1, loo2
yaya:
	blez $1, ya
	#bgtz $0, yaya
loo2:
	bgez $3, ya	
	bne $1, $2, loo2
	bne $1, $0, loo2
	
	
	sll $7, $2, 4 
	
	sra  $7, $2, 4 
	srlv $7, $2, $1
	
	
	lui $2, 100
	xori $7, $2, 100
	ori $2, $0, 0x1234
	ori $3, $0, 0x3456
	xor $1, $2, $3
	or $7, $2, $3
	nor $7, $2, $3
	addi $1, $0, 0x2
	and $1, $2, $3
	
	ori $9, $0, 0x1234
	addi $7, $0, -0x1234
	
	sltiu $1, $0, -0x111
	sltiu $1, $0, 0x111
	sltu $1, $7, $9
	slt $1, $7, $9
	  
	slt $1, $2, $3
	slt $1, $3, $2
	slt $1, $9, $2
	
	sub $9, $2, $3
	
	add $7, $0, $2
	add $7, $1, $2
	addiu $7, $0, 100
	addi $7, $0, 0
	ori $29, $0, 12
	
	add $7, $9, $9
	sw  $7, 8($0)
	addu $4, $2, $3
	subu $6, $3, $4
	
	
	sw $2, 0($0)
	sw $3, 4($0)
	sw $4, 4($29)
	lw $5, 0($0)
	beq $2, $5, _lb2
	_lb1:
	lw $3, 4($29)
	_lb2:
	lw $5, 4($0)
	beq $3, $5, _lb1
	jal F_Test_JAL		# $31 change
	# Never return
	
F_Test_JAL:
	subu $6, $6, $2
	sw $6, -4($29)
	_loop:
	beq $3, $4, _loop
	# Never return back
	
