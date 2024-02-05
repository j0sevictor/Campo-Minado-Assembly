.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	# a0 = endereço do board
	# a1 = linha
	# a2 = coluna
	save_context
	
	addi $sp, $sp, -12
	sw $a1, 0 ($sp)
	sw $a2, 4 ($sp)
	sw $ra, 8 ($sp)
		
	move $s0, $a1
	addi $s0, -1 # int i = row - 1 ;
	
	i_for_inicio:
	move $t0, $a1
	addi $t0, 1 # $t0 = row + 1
	bgt $s0, $t0, i_for_fim
	
	move $s1, $a2
	addi $s1, -1 # int j = column - 1; 
	
	j_for_inicio:
	move $t0, $a2
	addi $t0, 1 # $t0 = column + 1
	bgt $s1, $t0, j_for_fim
	
	li $t1, SIZE
	blt $s0, 0, else
	bge $s0, $t1, else
	blt $s1, 0, else
	bge $s1, $t1, else
	sll $t0, $s0, 5
	sll $t1, $s1, 2
	add $t2, $t0, $t1
	add $t0, $t2, $a0
	lw $t1, 0 ($t0)
	bne $t1, -2, else 
	
	move $a1, $s0
	move $a2, $s1
	jal countAdjacentBombs
	lw $a1, 0 ($sp)
	lw $a2, 4 ($sp)
	lw $ra, 8 ($sp)
	sw $v0, $t0
	
	bne $v0, $zero, else
	
	
	
	else:
	addi $s1, 1
	j j_for_inicio
	j_for_fim:
	
	addi $s0, 1
	j i_for_inicio
	i_for_fim:
	
	restore_context
	jr $ra

recursao:
	