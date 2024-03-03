# Arquitectura de computadores I
# Taller #1: Generador de numeros pseudoaleatorios
# LFSR con Fibonacci
# Mario Jesús Carranza Castillo - 2019180212

.text
main:
    li t0, 0x43   	# Cargar la letra C como semilla (01000011)
    li s0, 100 		# limite de repeticiones
    li a1, 0x100 	# posicion de memoria inicial para los datos
    li a2, 0xf4		# posicion de memoria para los bits de salida
    sw t0, 0(a1) 	# Guardar el valor de la semilla en 0x100
    
    ### BUCLE DEL PROGRAMA
loop:
    srli t5, t0, 2 	# shift right 2 posiciones a la semilla
    andi t1, t0, 0x1 	# obtener el bit 8 de la semilla
    andi t2, t5, 0x1 	# obtener el bit 6 de la semilla
    xor t3, t1, t2 	# se calcula el primer XOR (bit 8 con bit 6)
    
    srli t5, t0, 3 	# shift right 3 posiciones a la semilla
    andi t1,t5, 0x1 	# se obtiene el bit 5 de la semilla
    xor t3, t1, t3 	# se calcula el segundo XOR (bit 5 con el resltado del xor anterior)
    
    srli t5, t0, 4 	# shift right 4 posiciones a la semilla
    andi t1, t5, 0x1 	# se obtiene el bit 4 de la semilla
    xor t3, t3, t1 	# se calcula el tercer XOR (bit 4 con el resultado del xor anterior)
    
    ### GUARDAR EL BIT MENOS SIGNIFICATIVO (bit de salida)
    slli t6, t6, 1  	# shift left al registro con los bits de salida
    andi t2, t0, 0x1 	# se obtiene el bit que sale de la semilla (posicion 8)
    or t6, t6, t2 	# aqui t6 queda con el bit que sale como LSB
    
    ### REALIZAR EL SHIFT HACIA LA DERECHA
    srli t0, t0, 1 	# shift right a la semilla
    
    ###  METER EL RESULTADO DEL XOR EN t0
    slli t3, t3, 7 	# se corre el resultado del xor 7 bits a la izquierda
    or t0, t0, t3 	# el resultado del xor ahora es el MSB de la nueva semilla
    
    ### CARGAR EL DATO A LA MEMORIA
    addi a1,a1,0x4 	# sumar 4 a la posicion de memoria
    sw t0, 0(a1) 	# cargar la nueva semilla
    sw t6, 0(a2) 	# actualizar cadena de bits de salida en memoria
    
    ### VERIFICAR SI SE SALE DEL LOOP
    addi t4, t4, 1 	# incrementar el contador
    bne t4, s0, loop 	# se devuelve a loop si contador < 100
    
    ### TERMINAR EL PROGRAMA
    li a7, 93 		# codigo de llamada al sistema para salir
    li a0, 0 		# codigo de salida 0 es exitoso
    ecall

