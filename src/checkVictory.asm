.include "macros.asm"

.globl checkVictory

checkVictory:
# your code here
	# Contexto
	# s0 = count
	# s1 = i
	# s2 = j
	# s3 = SIZE (8)
	# s4 = endereço do board
	save_context
	move $s4, $a0 
	
	li $s0, 0 # int count = 0;
	li $s1, 0 # int i = 0;
	li $s3, SIZE
	
	begin_for_i:
	bge $s1, $s3, end_for_i # i < SIZE
	
	li $s2, 0 # int j = 0;
		
	begin_for_j:
	bge $s2, $s3, end_for_j # j < SIZE
	
	# Carregar o valor board[i][j] na memória $t1
	sll $t0, $s1, 5
	sll $t1, $s2, 2
	add $t2, $t0, $t1
	add $t0, $t2, $s4
	lw $t1, 0 ($t0)
	
	# if (board[i][j] >= 0) count++;
	blt $t1, $zero, not_count
	addi $s0, $s0, 1
	not_count:
		
	addi $s2, $s2, 1 # j++
	j begin_for_j 
	end_for_j:
	  
	addi $s1, $s1, 1 # i++
	j begin_for_i
	end_for_i:
	
	li $t0, SIZE
	li $t1, BOMB_COUNT
	mul $t0, $t0, $t0 # t0 = SIZE^2
	sub $t0, $t0, $t1 # t0 = SIZE^2 - BOMB_COUNT
	
	# if (count < SIZE^2 - BOMB_COUNT) return 0
	bge $s0, $t0, victory
	li $v0, 0
	j end
	
	# return 1
	victory:
	li $v0, 1
	
	end:
	restore_context
	jr $ra
