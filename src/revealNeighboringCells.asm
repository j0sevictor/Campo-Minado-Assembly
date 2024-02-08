.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	# Parâmetros:
	# 	a0 = endereço do board
	# 	a1 = linha
	# 	a2 = coluna
	# Contexto:
	# 	s0 = i
	# 	s1 = j
	# 	s2 = a1 (linha)
	# 	s3 = a2 (coluna)
	save_context
	
	move $s2, $a1
	move $s3, $a2
		
	addi $s0, $s2, -1 # int i = row - 1 ;
	
	i_for_inicio:
	addi $t0, $s2, 1 # $t0 = row + 1
	bgt $s0, $t0, i_for_fim
	
	addi $s1, $s3, -1 # int j = column - 1; 
	
	j_for_inicio:
	addi $t0, $s3, 1 # $t0 = column + 1
	bgt $s1, $t0, j_for_fim
	
	li $t1, SIZE
	blt $s0, 0, else
	bge $s0, $t1, else
	blt $s1, 0, else
	bge $s1, $t1, else
	
	# Carregando da heap o valor de board[i][j]
	sll $t0, $s0, 5
	sll $t1, $s1, 2
	add $t2, $t0, $t1
	add $t0, $t2, $a0
	lw $t1, 0 ($t0)
	bne $t1, -2, else 
	
	move $a1, $s0
	move $a2, $s1
	jal countAdjacentBombs
	
	sw $v0, 0($t0) # board[i][j] = x;
	
	bne $v0, $zero, else # if (x == 0)
	move $a1, $s0
	move $a2, $s1
	jal revealNeighboringCells
	
	else:
	addi $s1, $s1, 1
	j j_for_inicio
	j_for_fim:
	
	addi $s0, $s0, 1
	j i_for_inicio
	i_for_fim:
	
	restore_context
	jr $ra