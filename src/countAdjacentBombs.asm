.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context
	move $s0, $a0                                           #Testando para 3x3
	move $s2, $a2 #posicao linha				#s2 = 3
	move $s3, $a3 #posicao coluna				#s3 = 3
	li $t0, -1 #iniciando contador i 
	li $t1, -1 #iniciando contador j 
	li $v0, 0 #iniciando variável de retorno
	
	

 loop_i:
  	bge $t0, 2, end_loop_i					#se t0 == 2, finaliza o programa
 	add $t2, $s2, $t0 # i = linha + contador t0		#t2 = 3 + t0, primeira rodada = 2, segunda = 3, terceira = 4 
 	blt $t2, $zero, next_i_step				#se t2 < 0, proxima parte do loop
 	bge $t2, SIZE, end_loop_i				# se t2 == 8, finaliza o loop (nao tem mais linhas)
 	
 	loop_j:
 	 	bge $t1, 2, end_loop_j				#se t1 == 2, finaliza loop j (proximo loop i)
 		add $t3, $s3, $t1 # j = coluna + contador t1	#t3 = 3 + t1, primeira rodada = 2 , segunda = 3, terceira = 4
 		blt $t3, $zero, next_j_step			#se t3 < 0, proxima parte do loop
 		bge $t3, SIZE, end_loop_j			#se t3 == 8, finaliza o loop j (nao tem mais colunas)
 		
 		#Calculate the board position
 		mul $t4, $t2, SIZE				#adiciona ao registrador t4 o valor 2*8 = 16
 		add $t4, $t4, $t3				#adiciona ao registrador t4 o valor t4 + t3 = 16 + 2 = 18
 		sll $t4, $t4, 2					#multiplica o valor no registrador t4 por 4 = 18*4 = 72
 		add $t5, $t4, $s0				#adiciona ao registrador t5 o endereço t4 + s0 ~= 72
 		lw $t6, 0($t5)					#adiciona ao registrador t6 o conteudo de 72 ''supondo -1''
 		
 		bne $t6, -1, not_bomb				#é igual a -1
 		addi $v0, $v0, 1					#adiciona 1 a v0
 		
 		not_bomb:
	
	next_j_step:
		addi $t1, $t1, 1 
		j loop_j
	next_i_step:
		addi $t0, $t0, 1
		j loop_i
	end_loop_j:
		addi $t0, $t0, 1
		j loop_i
	end_loop_i:
		restore_context
		jr $ra
		
	

