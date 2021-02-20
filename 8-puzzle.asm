section .data               
; Developer name
developer db "_Javier_ _Alarcia_",0

; Constantes also defined in C.
DimMatrix    equ 3
SizeMatrix   equ DimMatrix*DimMatrix ;=9 

section .text            

; Assembly variables
global developer                        

; Assembly subroutines called from C
global updateBoardP2, spacePosScreenP2, copyMatrixP2,
global moveTileP2, checkStatusP2, playP2

; C variables
extern tilesIni, tiles, tilesEnd

; C functions called from assembly
extern clearScreen_C, printBoardP2_C, gotoxyP2_C, printchP2_C, getchP2_C
extern printMessageP2_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Cheatsheet
;;   'char'  -> BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   'short' -> WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   'int'   -> DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   'long'  -> QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODEIS MODIFICAR.
; Place the cursor in a certain row and column 
; of screen received from gotoxyP2_C.
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; rdi(edi): Row
; rsi(esi): Column
; 
; Returned parameters : 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP2:
   push rbp
   mov  rbp, rsp
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show a character (dil) on screen, received as parameter, 
; in the cursor position calling printchP2_C.
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; rdi(dil): character to be shown
; 
; Returned parameters : 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP2:
   push rbp
   mov  rbp, rsp
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read input key and returned associated character (al)
; without showing on screen, calling getchP2_C
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; None
; 
; Returned parameters : 
; rax(al): read character from keyboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP2:
   push rbp
   mov  rbp, rsp
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   mov rax, 0
   call getchP2_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show matrix (t) contents, received as a parameter, on screen,
; placed on the board on corresponding positions 
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; rdi(rdi): (t)    : Matrix where game numbers are stored
; rsi(esi): (moves): Remaining moves to lose the game
; 
; Returned parameters : 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateBoardP2:
   push rbp
   mov  rbp, rsp
   
   push rax        ; rowScreen
   push rbx        ; colScreen
   push rcx        ; i: row index (0-2) (dword)
   push rdx        ; j: column index (0-2) (dword)
   push r8         ; t
   push r9         ; moves
   push r10        ; matrix index (0-8)
   push r11        ; matrix char
   
   mov r8, rdi     ; store t on r8
   mov r9d, esi    ; store moves on r9
   mov ecx, 0      ; initialize i
   mov edx, 0      ; initialize j
   
   mov eax, 12     ; store 12 on rowScreen
   
   loop_row:
   
   mov edx, 0      ; reset col counter
   
   mov ebx, 8      ; store 8 on colScreen
   
   loop_col:
   
   mov edi, eax    ; se escribe rowScreen en rdi (param 1)
   mov esi, ebx    ; se escribe colScreen en rsi (param 2)
   
   call gotoxyP2
   
   mov r10d, ecx        ; cálculo índice 1: fila
   imul r10d, DimMatrix ; cálculo índice 2: fila*DimMatrix
   add r10d, edx        ; cálculo índice 3: (fila*DimMatrix)+col
   
   mov dil, BYTE[r8+r10] ; sumamos la matriz y el índice en dil (param1)
   
   call printchP2
      
   add ebx, 4          ; colScreen + 4
   
   inc edx             ; j++
   cmp edx, DimMatrix
   jl loop_col
   
   add eax, 2          ; rowScreen + 2
   
   inc ecx             ; i++
   cmp ecx, DimMatrix
   jl loop_row
   
   mov edi, 8          ; store 8 on rdi (param 1)
   mov esi, 20         ; store 20 on rsi (param 2)
   call gotoxyP2
   
   
   mov dil, r9b        ; store moves on dil (param 1)
   add dil, 48         ; add character '0' to moves
   
   call printchP2
   
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Locate the space in matrix (tiles), position cursor on it,
; and return its position inside the matrix.
;
; (row = (pos / DimMatrix) * 2 + 12)
; (col = (pos % DimMatrix) * 4 + 8)
;
; If there is no space, (pos = sizeMatrix).
; 
; Used global variables:   
; (tiles): Matrix where game numbers are stored
; 
; Passed arguments : 
; None
;
; Returned parameters : 
; rax(eax): (pos): Space position inside the matrix.
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
spacePosScreenP2:
   push rbp
   mov  rbp, rsp
   
   push rbx        ; i
   push rcx        ; j
   push rdx        ; remainder registry
   push rdi        ; row
   push rsi        ; col
   push r8         ; matrix index
   push r9         ; matrix character
   push r10        ; pos
   push r11        ; dividing register
   
   mov ebx, 0       ; i = 0
   mov ecx, 0       ; j = 0
   mov r10d, 0      ; pos = 0
   
   
   while: 
   cmp r10d, SizeMatrix
   jge endw
   
   mov r8d, ebx             ; index calculation 1: row
   imul r8d, DimMatrix      ; index calculation 2: row*DimMatrix   
   add r8d, ecx             ; index calculation 3: (row*DimMatrix)+col

   mov r9b, BYTE[tiles+r8d] ; character to compare
   cmp r9b, 32              ; compare with ' ' (ASCII 32)
   je endw
   
   inc r10d                  ; pos++
   
   mov eax, r10d            ; store pos (r10d) on RAX (implicit dividend)
                            
   mov edx, 0               ; initialize remainder
   
   mov r11d, DimMatrix      ; store divisor
   div r11d                 ; pos / DimMatrix
   mov ebx, eax             ; i = quotient (RAX)
   mov ecx, edx             ; j = remainder (RDX)
   
   jmp while
   
   endw:
   cmp r10d, SizeMatrix      ; pos < SizeMatrix
   jge endif
   
   imul ebx, 2               ; i*=2
   add ebx, 12               ; i+=12
   mov edi, ebx              ; store row on rdi (param 1)
   
   imul ecx, 4               ; j*=4
   add ecx, 8                ; j+=12
   mov esi, ecx              ; store col on esi (param 2)
   
   call gotoxyP2
   
   endif:
   
   mov eax, r10d             ; store pos on eax to return it
   
   pop r11
   pop r10
   pop r9
   pop r8
   pop rsi
   pop rdi
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy initial matrix (tilesIni) on the matrix (t), received as parameter
;
; Used global variables:   
; (tilesIni) : Matrix where initial game numbers are stored.
; 
; Passed arguments : 
; rdi(rdi): (t): Matrix where game numbers are stored.
;
; Returned parameters : 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copyMatrixP2:
   push rbp
   mov  rbp, rsp
   
   push rax        ; t
   push rbx        ; i: row 0-2
   push rcx        ; j: col 0-2
   push rdx        ; matrix index
   push rsi        ; matrix character
   
   mov rax, rdi    ; store t matrix on rax
   
   mov ebx, 0
   mov ecx, 0
   mov edx, 0
   
   loop_rows: 
   
   mov ecx, 0      ; reset cols index
   
   loop_cols:
   
   mov edx, ebx        ; index calculation 1: row
   imul edx, DimMatrix ; index calculation 2: row*DimMatrix   
   add edx, ecx        ; index calculation 3: (row*DimMatrix)+col
   
   mov sil, BYTE[tilesIni+edx] ; get tilesIni character
   
   
   mov BYTE[rax+rdx], sil      ; store on t[i][j]
   
   inc ecx
   cmp ecx, DimMatrix
   jl loop_cols
   
   inc ebx
   cmp ebx, DimMatrix
   jl loop_rows   
   
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Swap the chip on the direction pointed by character (charac)
; ('i':up, 'k':down, 'j':left o 'l':right) received as a parameter
; where there is the space in the matrix indicated by the variable (spacePos)
; received as a parameter, considering the cases where there can be no movement.
; If the tile is in the edge of the board, the movement from there cannot be done
; If the movement is allowed, move the chip where the space is located 
; and place the space where the tile was
;
; Used global variables:   
; (tiles): Matrix where game numbers are stored.
; 
; Passed arguments : 
; rdi (dil): (charac)  : Read keyboard character
; rsi (esi): (spacePos): Space position on matrix (tiles).
;
; Returned parameters : 
; rax (eax): (newPosSpace): New space position on matrix (tiles).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
moveTileP2:
   push rbp
   mov  rbp, rsp
   
   push rbx        ; charac
   push rcx        ; spacePos
   push rdx        ; division remainder
   push r8         ; i
   push r9         ; j
   push r10        ; newPosSpace
   push r11        ; DimMatrix for division
   push r12        ; DimMatrix-1
   push r13        ; register for sums and substractions
   push r14        ; matrix index 
   push r15        ; matrix character 
   
   mov bl, dil     ; store read character on RBX
   mov ecx, esi    ; store spacePos on RCX
   
   mov eax, ecx    ; store spacePos on RAX (implicit dividend)
   mov edx, 0      ; initialize remainder
   
   mov r11d, DimMatrix ; store on dividing registry
   div r11d            ; spacePos / DimMatrix
   mov r8d, eax        ; i = quotient (RAX)
   mov r9d, edx        ; j = remainder (RDX)
   
   mov r10d, ecx       ; store spacePos on newPosSpace
   
   mov r12d, DimMatrix
   dec r12d            ; store DimMatrix-1 for the conditionals
   
   cmp bl, 105         ; character 'i'
   jne case2
   
   cmp r8d, r12d       ; i < DimMatrix-1
   jge endsw
   
   mov r13d, ecx       ; addend 1: spacePos
   add r13d, DimMatrix ; addend 2: DimMatrix
   mov r10d, r13d      ; store sum on newPosSpace
   
   mov r14d, r8d        ; index calculation 1: row
   inc r14d             ; row+1
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov r15b, BYTE[tiles+r14d] ; take tiles[i+1][j] character
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov BYTE[tiles+r14d], r15b ; store tiles[i][j] character
   
   mov r14d, r8d        ; index calculation 1: row
   inc r14d             ; row+1
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov BYTE[tiles+r14d], 32 ; store ' ' on tiles[i+1][j]
   
   jmp endsw
   
   case2:
   cmp bl, 107          ; 'k' character
   jne case3
   
   cmp r8d, 0           ; i > 0
   jle endsw
   
   mov r13d, ecx       ; diminisher 1: spacePos
   sub r13d, DimMatrix ; diminisher 2: DimMatrix
   mov r10d, r13d      ; store result on newPosSpace
   
   mov r14d, r8d        ; index calculation 1: row
   dec r14d             ; row-1
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov r15b, BYTE[tiles+r14d] ; take character from tiles[i-1][j]
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov BYTE[tiles+r14d], r15b ; store character on tiles[i][j]
   
   mov r14d, r8d        ; index calculation 1: row
   dec r14d             ; row-1
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov BYTE[tiles+r14d], 32 ; store ' ' on tiles[i+1][j]
   
   jmp endsw
   
   case3:
   cmp bl, 106          ; 'j' character
   jne case4
   
   cmp r9d, r12d       ; j < DimMatrix-1
   jge endsw
   
   mov r13d, ecx       ; addend 1: spacePos
   inc r13d            ; addend 2: 1
   mov r10d, r13d      ; store sum on newPosSpace
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   inc r14d             ; index+1
   
   mov r15b, BYTE[tiles+r14d] ; take tiles[i][j+1] character
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov BYTE[tiles+r14d], r15b ; store tiles[i][j] character
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   inc r14d             ; index+1
   
   mov BYTE[tiles+r14d], 32 ; store ' ' on tiles[i][j+1]
   
   jmp endsw
   
   case4:
   cmp bl, 108          ; 'l' character
   jne case3
   
   cmp r9d, 0           ; j > 0
   jle endsw
   
   mov r13d, ecx       ; diminisher 1: spacePos
   dec r13d            ; diminisher 2: 1
   mov r10d, r13d      ; store substraction on newPosSpace
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   dec r14d             ; index-1 (col-1)
   
   mov r15b, BYTE[tiles+r14d] ; take character from tiles[i][j-1]
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   
   mov BYTE[tiles+r14d], r15b ; store character on tiles[i][j]
   
   mov r14d, r8d        ; index calculation 1: row
   imul r14d, DimMatrix ; index calculation 2: row*DimMatrix   
   add r14d, r9d        ; index calculation 3: (row*DimMatrix)+col
   dec r14d             ; index-1 (col-1)
   
   mov BYTE[tiles+r14d], 32 ; store ' ' on tiles[i+1][j]
   
   jmp endsw
   
   endsw:
   
   mov eax, r10d        ; store newPosSpace on eax (return param)
   
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verify game state
; If moves ran out (moves == 0), set status='3'
; If the move could not be done (spacePos == newSpacePos), set status='2'.
; Else:
; Check if matrix (tiles) is equal to target matrix (tilesEnd).
; If all positions are equal, set status = '4' to indicate win condition.
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; rdi (edi) moves       : Remaining moves.
; rsi (esi) spacePos    : Position of space.
; rdx (edx) newSpacePos : New space position.
;
; Returned parameters : 
; rax (al): (status): State of game.
;                     '1': Continue playing
;                     '2': The move could not be done
;                     '3': Defeat, no moves remaining
;                     '4': Win, all tiles are sorted
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkStatusP2:
   push rbp
   mov  rbp, rsp
   
   push rbx        ; status
   push rcx        ; sorted
   push r8         ; i
   push r9         ; j
   push r10        ; k
   push r11        ; tiles character
   push r12        ; tilesIni character
   push r13
   push r14
   push r15
   
   mov ecx, 1      ; sorted = 1
   mov r8d, 0      ; i=0
   mov r9d, 0      ; j=0
   mov r10d, 0     ; k=0
   
   cmp edi, 0
   jne else1
   
   mov bl, 51      ; status = '3'
   
   jmp endifStatus
   
   else1:
   cmp esi, edx    ; spacePos == newSpacePos?
   jne whileStatus
   
   mov bl, 50      ; status = '2'
   
   jmp endifStatus
   
   whileStatus:
   
   cmp r10d, SizeMatrix   ; k < SizeMatrix
   jge endwStatus
   
   cmp ecx, 1             ; sorted == 1
   jne endwStatus
   
   mov r11b, BYTE[tiles+r10d]    ; tiles[i][j]
   mov r12b, BYTE[tilesEnd+r10d] ; tilesIni[i][j]
   
   cmp r11b, r12b
   je endcmp
   
   mov ecx, 0                    ; sorted = 0
   
   endcmp:
   inc r10d                      ; k++
   
   jmp whileStatus
   
   endwStatus:
   
   cmp ecx, 1
   jne elseSorted
   
   mov bl, 52                    ; status = '4'
   jmp endifStatus
   
   elseSorted:
   mov bl, 49                    ; status = '1'
   
   endifStatus:
   
   mov al, bl       ; store status on RAX (return param)
   
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display a message under the board depending on the status variable
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; rdi (dil): (status): State of game.
;
; Returned parameters : 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP2:
   push rbp
   mov  rbp, rsp
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   
   call printMessageP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret
   
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main subroutine
; 
; Display board game calling printBoard2_C.
; Initialize game state, (state='1').
; Initialize max allowed moves (moves = 9).
; Initialize matrix (tiles) with initial matrix's values (tilesIni)
; caling copyMatrixP2_C subroutine.
; While state=='1':
;   Update board calling updateBoardP2
;   Look for space inside matrix (tiles) and position 
;   the cursor calling subroutine spacePosScreenP2.
;   If the space is found:
;     Make the space position the new space position (spacePos = newSpacePos)
;     Read a key calling getchP2.
;     Depending on the key, one subrutine or another will be called:
;      - ['i','j','k' o 'l'] move the tile on a direction calling moveTileP2.
;        If a move has been done, decrease available moves (moves--).
;        Check game state calling checkStatusP2.
;      - '<ESC>'  (ASCII 27) set state = '0' to exit.   
;    If the space is not found:
;    	Set state='5' to indicate it. 
;    Display a message under the game board depending on the state variable calling
;    printMessageP2 subroutine.
;    If the move could not be done, set state = '1' to continue playing. 
; 
; Before exiting, update board calling updateBoardP2 and position the cursor 
; where the space is calling spacePosScreenP2.
; Wait for a key input calling getchP2
; Exit game.
; 
; Used global variables:   
; None
; 
; Passed arguments : 
; None
;
; Returned parameters : 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
playP2:
   push rbp
   mov  rbp, rsp
   
   call printBoardP2_C   ;printBoard2_C();
   
   push rax
   push rbx
   push rdx
   push rdi
   push rsi
   push r8
   push r9
   push r10
   
   
   mov r8d, 0             ;int spacePos = 0
   mov r9d, 0             ;int newSpacePos;
   mov r10d, 9            ;int moves = 9
   mov bl , '1'           ;char state = '1';
   
   mov  rdi, tiles
   call copyMatrixP2     ;copyMatrixP2_C(tiles);
   
   playP2_While:
   cmp  bl, '1'                 ;while (state == '1')
   jne  playP2_EndWhile       ; Main loop.
      mov  rdi, tiles
      mov  esi, r10d
      call updateBoardP2      ;updateBoardP2_C(tiles, moves);
      call spacePosScreenP2   ;newSpacePos = spacePosScreenP2_C();
      mov r9d, eax
      cmp r9d, SizeMatrix     ;if (newSpacePos < SizeMatrix) {
      jge playP2_ElseIf1
         mov r8d, r9d              ;spacePos = newSpacePos;
            
         call getchP2              ;getchP2_C()
      
         playP2_ReadKey_ijkl:
         cmp al, 'i'
         jl  playP2_ReadKey_ESC    ;(c>='i')
         cmp al, 'l'
         jg  playP2_ReadKey_ESC    ;(c<='l')
            mov dil, al
            mov esi, r8d
            call moveTileP2        ;newSpacePos = moveTileP2_C(c, spacePos);
            mov r9d, eax
            cmp r9d, r8d           ;if (newSpacePos != spacePos) moves--;
            je  playP2_EndIf2
               dec r10d
            playP2_EndIf2:
            mov edi, r10d
            mov esi, r8d
            mov edx, r9d
            call checkStatusP2     ;state = checkStatusP2_C(moves, spacePos, newSpacePos);
            mov  bl, al
            jmp playP2_ReadKey_noESC   
         playP2_ReadKey_ESC:
         cmp al, 27                 ;if (c==27)
         jne playP2_ReadKey_noESC
            mov bl, '0'             ;state = '0'  
         playP2_ReadKey_noESC:
         jmp playP2_EndIf1
         playP2_ElseIf1:
            mov bl, '5'             ;state = '0' 
         playP2_EndIf1:
         mov  dil, bl
         call printMessageP2    ;printMessageP2_C(state);
         cmp bl, '2'            ;if (state == '2') 
         jne playP2_While
            mov bl, '1'         ;state = '1';
      jmp playP2_While
   
   playP2_EndWhile:
   mov  rdi, tiles
   mov  esi, r10d
   call updateBoardP2         ;updateBoardP2_C(tiles, moves);
   call spacePosScreenP2      ;spacePosScreenP2_C();
   mov r9d, eax
   call getchP2               ;getchP2_C();
   
   pop r10
   pop r9
   pop r8
   pop rsi
   pop rdi
   pop rdx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
