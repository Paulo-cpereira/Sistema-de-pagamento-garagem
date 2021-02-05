org 100h 
include 'emu8086.inc'          






menu_principal:                             ;Escrever menu principal
     
   call clear_screen
    
    
   mov ah, 9      
   lea dx, Menu
   int 21h 
   
   mov si, 0 
   
         
                      
                  
ler_tecla:                                  ;Ler tecla do menu
    
    
    
    mov ah, 9
    lea dx, LER_OPCAO
    int 21h
  
  
    mov ah, 1
    int 21h
    
    cmp al, 31h  
    
    
    je chegada_carro 
    
   
    cmp al, 32h
    
    je sair 
             
             
    jmp ler_tecla
   
   
   
   
inicio:                                         ;Inicio do programa   GAME LOOP

   mov ah, 9
   lea dx, mudar_linha
   int 21h
               
               
               
   jmp escrever_matricula
   

chegada_carro:                                  ;Chega um carro, limpa a tela
         
   mov bx, 6  
   
   call clear_screen   
   
   mov ah, 9                                     ;Escrever chegada do carro
   lea dx, mesagem_carro_entrar
   int 21h
   
   mov ah, 9
   lea dx, mudar_linha
   int 21h
   
                         
   mov ah, 9      
   lea dx, chegada_texto
   int 21h
   
           
   J1:                                              ; Gerar um carater aleatorio de 'A a Z'
                  
 
   MOV AH, 00h                                      ; Tira o tempo do sistema
   INT 1AH                                          ; CX:DX guardam os ticks apartir da meia noite

   mov  ax, dx
   xor  dx, dx
   mov  cx, 26
   div  cx                                          

   add  dl, 'A'                                     
   mov ah, 2h                                       
   int 21h 
                                                    ; decrementa o bx
   dec bx 
    
   cmp bx, 0
   
   jne J1   
   

fim_chegada:
   
   mov ah, 9
   lea dx, mudar_linha
   int 21h 
                    
                      
                       
                                   
                                   
                                   
escrever_matricula:                                  ;Guardar a matricula dos carros que entram
     
    mov cx, 6
    mov bp, 0                                        
    
    mov ah, 9
    lea dx, mudar_linha
    int 21h 
    
    
    mov ah, 9
    lea dx, texto_auxiliar
    int 21h

    L1:                                               ; Loop para ler e guardar 1 a 1, os carateres da matricula
    
     
     
     mov ah, 1
     int 21h


     mov matriculas[bp], al
     inc bp 
      
     Loop L1
     
  
     
     mov ah, 9
     lea dx, mudar_linha
     int 21h 
   

    
timer:                                                 ;Temporizador para fazer um intervalo de espera 
                                                       ;para a chegada de um novo carro
   mov ah, 9
   lea dx, em_espera
   int 21h
     
   mov ah, 9
   lea dx, mudar_linha
   int 21h 
           
   mov bx,0        
           
Num_aleatorio:                                          ;se de 0 a 100 o numero que sair for maior
                                                        ;que 95, o carro sai do estacionamento.
   inc bx                                               ;Foi um artefacto que utilizamos para simular
                                                        ;um temporizador
   mov ah, 2ch    
   int 21h                                              ;So' sai do loop quando esse numero (>95) for atingido
   
   cmp dl, 95
   jg   sair_carro
   
   
nao_sair:
   mov dl,3
   jmp Num_aleatorio
   
    
    
sair_carro:
   
   push bx
     
   mov ah, 9
   lea dx, mesagem_carro_sair
   int 21h
   
   mov ah, 9
   lea dx, mudar_linha
   int 21h 
           
   
   
                                        
ler_matricula:                                          ;Guardar as matriculas dos carros que estam a sair
     
    mov cx, 6
    mov si, 0

    mov ah, 9
    lea dx, mudar_linha
    int 21h
    
    mov ah, 9
    lea dx, texto_auxiliar_2
    int 21h
    

    L2:                                                  ;Compara a matricula introduzida 'a saida com a matricula introduzida 
                                                         ;na entrada, se for a certa continua para calcular o preco
     mov ah, 1                                           ;se for a errada pede para escrever novamente
     int 21h


     mov comparador[si], al   
     
     inc si 
      
     Loop L2
    
    mov ah, 9
    lea dx, mudar_linha
    int 21h  
     
             
             
testar:                                                 ;Compara matricula com o carro que vai sair, com a que foi 
                                                        ;registada na entrada
     mov al, 0  
     mov si, 0
     mov di, 0
     
     jmp L3 
     
    
     
     L3:                                                 ;Comparamos as 6 diferentes posicoes dos dois arrays de duas matriculas
          
     mov bh,matriculas[si] 
     mov ah,comparador[di]   
        
     cmp ah, bh  
     
     JNE carro_nao_encontrado                             ;Se falhar saltamos para carro_nao_encontrado
     
     inc di
     inc si
     
     cmp di, 6                                            ;se o di chegar a 6, significa que todas as posicoes 
                                                          ;testadas anteriormente sao iguais, salta para certa
     je certa
                  
     loop L3
  

carro_nao_encontrado:                                      ;apresenta uma mensagem de erro, e voltamos a tentar ler a matricula a sair

   mov ah, 9
   lea dx, falha_encontrar
   int 21h 
   
   jmp ler_matricula



mostrar_matricula:

   mov ah, 9
   lea dx, mudar_linha
   int 21h

   mov ah, 9
   lea dx, matriculas
   int 21h
   
     
   
certa:                          ;Label para nos ajudar a organizar o codigo
 
               
                  
    jmp calcular_preco          ;vamos para calcular preco
    
    
  
     
calculado:    
    
          
    
        
    mov ah, 9
    lea dx, mudar_linha
    int 21h   
    
    mov ah, 9
    lea dx, frase_saida1
    int 21h   
    
    mov ah, 9
    lea dx, comparador
    int 21h
    
    mov ah, 9
    lea dx, frase_saida3
    int 21h
          
    mov ah, 9
    lea dx, mudar_linha
    int 21h
          
                           

                         
                           
    mov ah, 9              ;Carregue NA BARRA DE ESPACO para regressar ao menu principal
    lea dx, quer_sair      
    int 21h                
    
    mov ah, 9
    lea dx, mudar_linha
    int 21h
    
    mov ah, 9
    lea dx, continuar      ;Depois de terminada a sequencia do carro anterior
    int 21h                ;ao carregar em qualquer tecla ficamos 'a espera do proximo carro
    
    mov ah, 9
   lea dx, mudar_linha
   int 21h    
    
    
    mov ah, 1
    int 21h
    
    cmp al, 20h    ;Se carregar em qualquer tecla (tirando a 'BARRA DE ESPACO') ele continua o jogo 
    
       
    
    jne timer_2  ;se escolhermos continuar, ficamos 'a espera que chegue o proximo carro

           
    je menu_principal     ;se escolhermos sair, voltamos para o menu
 
           
          
sair: ;Sair do programa
   
   ret
   
   
   
   
   
   Menu db 13,10,'Parque de estacionamento: ', 13, 10, 13, 10,'1-Inicio' , 13, 10, '2-Sair', 13, 10, '$'   
   mudar_linha db 13, 10, '$'        
   matriculas db '      ', '$'
   comparador db '      ', '$'     
   continuar db 13,10,'Para continuar carregue numa tecla qualquer.','$'     
   quer_sair db 13,10, 'Se quiser sair para o menu principal carregue',13,10,' na tecla "BARRA DE ESPACO"','$'       
   frase_preco1 db 13,10,'Valor a pagar:','$'
   frase_preco2 db ' euros.','$'   
   em_espera db 13,10, 'A espera que o carro queira sair...','$'      
   em_espera_2 db 13,10, 'A espera que apareca algum carro...','$'    
   mesagem_carro_sair db 13,10, 'O carro vai sair do estacionamento...','$'     
   mesagem_carro_entrar db 13,10, 'Aproxima-se um carro do estacionamento...','$'                           
   LER_OPCAO db 13,10, 'Opcao: ', '$'   
   falha_encontrar db 13,10, 'Falha ao encontrar a matricula pretendida!', 13,10, 'Tente novamente!','$'                                  
   frase_saida1 db 13,10, 'O veiculo com a matricula ','$' 
   frase_saida3 db ' saiu!','$'    
   chegada_texto db 13,10, 'Chegou um carro ao parque com a matricula:',13,10,'$' 
   texto_auxiliar db 13,10, 'Registar matricula a entrar:','$'
   texto_auxiliar_2 db 13,10, 'Registar matricula a sair:','$'   
 
 
 
   
   clear_screen proc near
        push    ax      ; store registers...
        push    ds      ;
        push    bx      ;
        push    cx      ;
        push    di      ;

        mov     ax, 40h
        mov     ds, ax  ; for getting screen parameters.
        mov     ah, 06h ; scroll up function id.
        mov     al, 0   ; scroll all lines!
        mov     bh, 1111_0000b  ; attribute for new lines.
        mov     ch, 0   ; upper row.
        mov     cl, 0   ; upper col.
        mov     di, 84h ; rows on screen -1,
        mov     dh, [di] ; lower row (byte).
        mov     di, 4ah ; columns on screen,
        mov     dl, [di]
        dec     dl      ; lower col.
        int     10h

        ; set cursor position to top
        ; of the screen:
        mov     bh, 0   ; current page.
        mov     dl, 0   ; col.
        mov     dh, 0   ; row.
        mov     ah, 02
        int     10h

        pop     di      ; re-store registers...
        pop     cx      ;
        pop     bx      ;
        pop     ds      ;
        pop     ax      ;

        ret
clear_screen endp
          



timer_2:              ;Temporizador para a chegada do carro ao estacionamento
          
   mov ah, 9
   lea dx, mudar_linha
   int 21h         
          
   mov ah, 9
   lea dx, em_espera_2
   int 21h
     
   mov ah, 9
   lea dx, mudar_linha
   int 21h 
           
   mov bl,0        
           
Num_aleatorio_2:            ;se de 0 a 100 o numero que sair for maior
                            ;que 90, o carro entra no estacionamento
   inc bl                   ;foi um artefacto que utilizamos para simular
                            ;um timer
   mov ah, 2ch    
   int 21h
   
   cmp dl, 90
   jg   chegada_carro
 
   
nao_entrar:
   mov dl,3
   jmp Num_aleatorio_2
   
    

     
calcular_preco:             ;Calculamos o preco a pagar


mostrar:
      mov ah, 9
      lea dx, frase_preco1
      int 21h   
      
      
         pop ax              ;Para nao aparecerem valores de euros absurdos, fizemos este pequeno sistema 
                              ;o preco ira' varia entre 1 euro e 10 euros sensivelmente, dependendo do 
      cmp ax, 30               ;tempo presente dentro do estacionamento
      jg  tira_25
      
      cmp ax, 20
      jg  tira_20
      
      cmp ax, 10
      jg  tira_10  
      
      jmp calcular_preco_2
      
tira_25:
        sub ax, 25
        jmp calcular_preco_2      
      
tira_20:
        sub ax, 20
        jmp calcular_preco_2
tira_10:
        sub ax, 10
        jmp calcular_preco_2
        
        
calcular_preco_2:             ;escrever o valor do preco
   
      CALL   print_num      ; escreve o valor de ax      


      mov ah, 9
      lea dx, frase_preco2
      int 21h

      jmp calculado



DEFINE_PRINT_NUM          ;defines necessarios para efetuarmos o call print_num
DEFINE_PRINT_NUM_UNS  