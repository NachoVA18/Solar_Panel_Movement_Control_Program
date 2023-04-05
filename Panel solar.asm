.data
#-- Definition of ports' addresses
.eqv Output_power  		0xFFFF0000
.eqv Sensors_measurement 	0xFFFF0020
.eqv Angle_position		0xFFFF0040
.eqv Desired_angle_position 	0xFFFF0060
.eqv Battery_level		0xFFFF0080
.eqv Status_flag		0xFFFF00E0
.eqv maximo_izquierda		-30000
.eqv maximo_derecha		30000
.eqv maximo_sensor		255
.eqv DisplayString 4
.eqv DisplayInteger 1
.eqv FinishProgram 10
Message1: .string "Battery level: "



#este código debido a su diseño funcionará mejor cuanto mayor sea la velocidad del simulador, y en ningún caso limitandola
.text
Bucle_inicial:	#Este bucle nos permite dejar en la posición 0 el panel hasta saber de que lado saldrá el sol
 jal Flags
 beqz a6,Finish#si la flag de test está a 0 acabamos el programa
 jal Datos_sensores
 bgt t3,t4, pos_in_izquierda #nos vamos a la posición inicial de la izq si el sensor izq es mayor que el derecho
 bgt t4,t3, pos_in_derecha #nos vamos a la posición inicial de la der si el sensor der es mayor que el izq
 b Bucle_inicial



pos_in_izquierda:
 li s3, -30000#guardamos en s3 para todo el resto del programa el valor inicial por donde saldrá el sol
 mv s2, s3
 jal Mover
 b Main




pos_in_derecha:
 li s3, 30000#guardamos en s3 para todo el resto del programa el valor inicial por donde saldrá el sol
 mv s2, s3
 jal Mover
 b Main



Main:#Bucle principal 
 jal Flags
 beqz a6,Finish#si la flag de test está a 0 acabamos el programa
 bnez a7,Main#si se está moviendo el motor no hacemos nada
 jal Datos_sensores 
 beq t3,t4,posición_inicial  #miramos si valen lo mismo y en ese caso  lo mandamos al programa de pos. inc. donde evaluará si son 0
 bgt t3,t4,Mover_izquierda #si un lado es mayor que el otro moverá el panel en una dirección u otra
 bgt t4,t3,Mover_derecha
 b Main	#volvemos al bucle



posición_inicial:
 bnez t4, Main #ya hemos visto si son iguales pero queremos saber si tambien son 0, sino lo volvemos al main
 mv s2,s3  #aquí mandamos a moverse a lo que hemos decidido al principio que era la posiciónn inicial
 jal Mover
 b Main



Mover_derecha:
 jal Estado_angulo_panel
 li a4, maximo_derecha 
 beq a3, a4, Main #miramos si ha llegado al limite por la derecha(30º) y si es así no se mueve
 li s2, 0
 addi s2, a3, 75 #lo movemos 75 a
 jal Mover
 b Main



Mover_izquierda:
 jal Estado_angulo_panel
 li a4, maximo_izquierda
 beq a3, a4, Main #miramos si ha llegado al limite por la izquierda(-30º) y si es así no se mueve
 li s2, 0
 addi s2, a3, -75 #lo movemos -75
 jal Mover
 b Main


Flags: #Sacamos las flags del programa ,a6= test y a7=motor movement execution
 li a5, Status_flag
 lw a6, 0(a5)
 andi a7,a6,0x1 #Mascara and para sacar b0
 andi a6,a6,0x2 #Mascara and para sacar b1
 ret



Estado_angulo_panel:#sacamos la info de donde se encuentra el panel y la guardamos en a3
 li a2, Angle_position
 lw a3, 0(a2)
 ret



Datos_sensores:#Sacamos los datos de los sensores t3=right,t4=left
 li t2, Sensors_measurement 
 lw t3, 0(t2) 
 andi t4,t3,0xFF #Mascara and para sacar los dos primeros bytes
 srli  t3,t3,16 #Desplazamiento a la derecha para sacar los dos segundos bytes
 ret



Mover:#esta función nos moverá el panel lo que tengamos puesto en el registro s2
 li t0, Desired_angle_position
 sw s2, 0(t0) 
 ret



Finish:
 li t2, Battery_level
 lw t1, 0(t2) #guardamos en t1 el nivel de batería
 la a0,Message1 #imprimimos el mensaje 
 li a7, DisplayString
 ecall
 mv a0, t1 #imprimimos el nivel de la batería
 li a7, DisplayInteger
 ecall
 li,a7,FinishProgram #terminamos el programa
 ecall



