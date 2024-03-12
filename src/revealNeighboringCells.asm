.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	# Parï¿½metros:
	# 	a0 = endereï¿½o do board
	# 	a2 = linha
	# 	a3 = coluna
	# Contexto:
	# 	s0 = i
	# 	s1 = j
	# 	s2 = a2 (linha)
	# 	s3 = a3 (coluna)
	#	s5 = a0
	save_context
	
	move $s5, $a0 
	move $s2, $a2
	move $s3, $a3
		
	addi $s0, $s2, -1 # int i = row - 1 ;
	
	i_for_inicio:
	addi $t0, $s2, 1 # $t0 = row + 1
	bgt $s0, $t0, i_for_fim # i < row + 1
	# Condicionais para o caso da posição i estar fora do tabuleiro
	blt $s0, $zero, continue_i
	bge $s0, SIZE, i_for_fim
	
	addi $s1, $s3, -1 # int j = column - 1; 
	
	j_for_inicio:
	addi $t0, $s3, 1 # $t0 = column + 1
	bgt $s1, $t0, j_for_fim # j < column + 1
	# Condicionais para o caso da posição j estar fora do tabuleiro
	blt $s1, $zero, continue_j
	bge $s1, SIZE, j_for_fim
	
	# if (i >= 0 && i < SIZE && j >= 0 && j < SIZE && board[i][j] == -2)
	li $t1, SIZE
	blt $s0, 0, continue_j
	bge $s0, $t1, continue_j
	blt $s1, 0, continue_j
	bge $s1, $t1, continue_j
	
	# Carregando da heap o valor de board[i][j]
	sll $t0, $s0, 5
	sll $t1, $s1, 2
	add $t2, $t0, $t1
	add $s4, $t2, $s5 # s4 = endereï¿½o do board
	lw $t1, 0 ($s4) # t1 = board[i][j]
	bne $t1, -2, continue_j  # (board[i][j] == -2)
	
	move $a0, $s5
	move $a2, $s0
	move $a3, $s1
	jal countAdjacentBombs
	
	sw $v0, 0($s4) # board[i][j] = x;
	
	bne $v0, $zero, continue_j # if (x == 0)
	move $a0, $s5
	move $a2, $s0
	move $a3, $s1
	jal revealNeighboringCells
	
	continue_j:
	addi $s1, $s1, 1
	j j_for_inicio
	j_for_fim:
	
	continue_i:
	addi $s0, $s0, 1
	j i_for_inicio
	i_for_fim:
	
	restore_context
	jr $ra
