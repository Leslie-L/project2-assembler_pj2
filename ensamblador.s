////////////////////////////////////////////////////////////////////////////////////
/////////////////////////CIENCIAS DE LA COMPUTACON III - 2017///////////////////////
////////////////////////////////UNIVERSIDAD GALILEO/////////////////////////////////
///////////////////////////////Proyecto-2 Ensamblador///////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

.data
READ_MODE: .asciz "r"
HOPE: .asciz "TENGO LA ESPERANZA DE QUE AQUI SALGA LO QUE ESPERO %s\n"
INSTRUCCION_: .asciz "0x%08x\n"
args_error_msg: .asciz "No se ingresaron el numero correcto de parametros"
dot_data: .space 1000 	//el area de data
dot_text: .space 4000	//el area de texto
file_buffer: .space 8000//el buffer que guardara el texto a codificar
.text
  .globl main

read_file: 		//x0 es el buffer, x1 es el archivo
   ADD SP, SP, #-32
   STR x30,[SP,#0]
   STR x19,[SP,#8]
   STR x20,[SP,#16]
   STR x21,[SP,#24]
   MOV x19, x0		//el buffer
   MOV x20, x1		//el archivo
read_file_loop:
   MOV x0, x20
   BL fgetc
   MOV x21,x0
   MOV x0,x20
   BL feof
   CMP x0,#0
   B.NE read_file_finish
   STR x21,[x19,#0]
   ADD x19,x19, #1
   B read_file_loop
read_file_finish:
   MOV x9,#0		//un \0 diciendo que se acabo el archivo
   STR x9,[x19,#0]
   LDR x21,[SP,#24]
   LDR x20,[SP,#16]
   LDR x19,[SP,#8]
   LDR x30,[SP,#0]
   ADD SP, SP, #32
   RET

display_instructions:
   ADD SP, SP, #-16
   STR x30,[SP,#0]
   STR x19,[SP,#8]
   MOV x19, x0
display_loop:
   LDR x0,=INSTRUCCION_
   LDR w1,[x19,#0]
   ADD x19,x19,#4
   CMP w1,#0
   B.EQ finish_display
   BL printf
   B display_loop
finish_display:
   LDR x19,[SP,#8]
   LDR x30,[SP,#0]
   ADD SP, SP, #16
   RET

//////////////////////////////////////////////////////////////////////////////
///////////////////////////////encode/////////////////////////////////////////
/////////////////////x0: buffer con las instrucciones/////////////////////////
/////////////////////////////x1: area de texto////////////////////////////////
/////////////////////////////x2: area de data ////////////////////////////////
///////////////////ESTA ES LA FUNCION QUE DEBEN IMPLEMENTAR///////////////////
//////////////////////////////////////////////////////////////////////////////
encode:
   RET

main:
   ADD SP, SP, #-16
   STR x30,[SP,#0]
   CMP x0, #2
   BNE args_error
   MOV x27, x1		//argv se guarda en x27
   LDR x19,=file_buffer	//x19 guarda el buffer de caracteres ya leidos
   LDR x20,=dot_text	//x20 guarda el area de texto
   LDR x21,=dot_data	//x21 guarda el area de data
   LDR x0,[x27,#8]
   LDR x1,=READ_MODE
   BL fopen
   MOV x22, x0		//el archivo del que leeremos esta en x22
   MOV x0, x19
   MOV x1, x22
   BL read_file		//leemos el archivo completo
   MOV x0, x22
   BL fclose
   MOV x0, x19
   MOV x1, x20
   MOV x2, x21
   BL encode		//esta es la ultima instruccion que hay que codificar
   MOV x0, x20    	//desplegaremos las instrucciones codificadas
   BL display_instructions
main_finish:
   MOV x0,#0 		// return 0 :)
   LDR x30,[SP,#0]
   ADD SP, SP, #16
   RET
args_error:
   LDR x0,=args_error_msg
   BL puts
   B main_finish
