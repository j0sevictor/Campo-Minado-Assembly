.include "macros.asm"

.data
	msg_row:  		.asciiz "Enter the row for the move: "
 	msg_column:  	.asciiz "Enter the column for the move: "
 	msg_win:  		.asciiz "Congratulations! You won!\n"
 	msg_lose:  		.asciiz "Oh no! You hit a bomb! Game over.\n"
	msg_invalid:  .asciiz "Invalid move. Please try again.\n"

.globl main 	 	
.text

main:
  addi $sp, $sp, -256 	# board; sp = sp - 256
  li $s1, 1	      				# int gameActive = 1; s1 = 1
  move $s0, $sp #s0 = sp - 256 // espa�o do board
  move $a0, $s0 #a0 = s0 // salva o local de memoria do inicio do board na variavel a0
  
  jal inicialializeBoard # initializeBoard(board);
  move $a0, $s0 #a0 = s0 // 	
  jal plantBombs 				 # placeBombs(board);
  
  begin_while:					 # while (gameActive) {
  beqz $s1, end_while #Se s1, que nesse caso � 1, � igual a 0, encerra o jogo
  move $a0, $s0 #a0 recupera a posi��o do board na memoria 
  li $a1, 0 #a1 = 0 
  jal printBoard				 # printBoard(board,0); // Shows the board without bombs
  
  la $a0, msg_row		
  li $v0, 4							# printf("Enter the row for the move: ");
  syscall
  
  li $v0, 5  						# scanf("%d", &row);
  syscall
  move $s2, $v0 #move para s2 o valor de v0
  
  la $a0, msg_column
  li $v0, 4 						# printf("Enter the column for the move: ");
  syscall
  
  li $v0, 5 						# scanf("%d", &column);

  syscall
  move $s3, $v0 
  				#Fim da recep��o dos valores linha coluna, s2 linha, s3 coluna
  li $t0, SIZE			#t0 = 8 == SIZE
  blt $s2, $zero, else_invalid	#if (row >= 0 && row < SIZE && column >= 0 && column < SIZE) {
  bge $s2, $t0, else_invalid		
  blt $s3, $zero, else_invalid
  bge $s3, $t0, else_invalid
  				#Fim da checagem se linha e coluna (s2 e s3) s�o valores vi�veis
 # addi $sp, $sp, -4		#sp = sp - 4 
 # sw $s0, 0 ($sp)		#s0, posi��o do tabuleiro, recebe o valor de 0 + sp na memoria
  move $a0, $s2			#a0 = s2, a0 � a linha
  move $a1, $s3			#a1 = s3, a1 recebe a coluna
  move $a2, $s0
  jal play
  #addi $sp, $sp, 4
  bne $v0, $zero, else_if_main 	# if (!play(board, row, column)) {
    li $s1, 0										# gameActive = 0;
  la $a0, msg_lose							# printf("Oh no! You hit a bomb! Game over.\n");
  li $v0, 4
  syscall
  j end_if_main
  
 else_if_main:
 	move $a0, $s0
  jal checkVictory							# else if (checkVictory(board)) {
  beq $v0, $zero, end_if_main
  la $a0, msg_win								# printf("Congratulations! You won!\n");
  li $v0, 4
  syscall
  li $s1, 0											# gameActive = 0; // Game ends
  j end_if_main 
  else_invalid:		
  la $a0, msg_invalid						# printf("Invalid move. Please try again.\n");
  li $v0, 4
  syscall
  end_if_main:
  j begin_while
  end_while:
  move $a0, $s0 
  li $a1, 1
  jal printBoard								# printBoard(board,1);
  li $v0, 10
  syscall

