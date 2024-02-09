.include "macros.asm"

.globl play

play:
	save_context
	move $s0, $a2 #Iniciamos s0 com a posi��o do board
	move $s1, $a0
	move $s2, $a1
	
 #a0 linha
 #a1 coluna
 #v0 retorno(creio eu)
 #s0 inicio do board
 
  # Calcular posi��o no tabuleiro
  mul $t1, $a0, SIZE  # linha * Tamanho
  add $t2, $t1, $a1   # (linha * Tamanho) + coluna
  sll $t3, $t2, 2     # Multiplique por 4 pra conseguir o tamanho exato
  add $t4, $s0, $t3   # Calcula a posi��o no tabuleiro
  lw $t5, 0($t4)      # Carrega o valor da posi��o na vari�vel t5
  move $s6, $t4
  
  beq $t5, -1, equal_to_minus_one #O valor d� igual a -1 ou n�o
  beq $t5, -2, equal_to_minuts_two #O valor d� igual a -2 ou n�o, se for diferente de -1 ou -2, a fun��o devolve 1 em v0
  li $v0, 1
  restore_context
  jr $ra  
  
  equal_to_minuts_two:
  	move $a0, $s0
  	move $a2, $s1
  	move $a3, $s2
  	jal countAdjacentBombs #CountAdjacentBombs retorna um valor em v0
 	sw $v0, 0($s6)
  	beqz $v0, no_bombs
    	li $v0, 1
  	restore_context
  	jr $ra  
  	
  no_bombs:
  	move $a0, $s0
  	move $a2, $s2
  	move $a3, $s3
	jal revealNeighboringCells
	li $v0, 1
  	restore_context
  	jr $ra  

    
  equal_to_minus_one:
  	li $v0, 0
  	restore_context
  	jr $ra
	
	
#    int play(int board[][SIZE], int row, int column) {
#        // Performs the move
#        if (board[row][column] == -1) {
#            return 0; // Player hit a bomb, game over
#        }
#        if (board[row][column] == -2) {
#            int x = countAdjacentBombs(board, row, column); // Marks as revealed
#            board[row][column] = x;
#            if (!x)
#                revealAdjacentCells(board, row, column); // Reveals adjacent cells
#        }
#        return 1; // Game continues
#    }

 
