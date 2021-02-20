#include <stdlib.h>
#include <stdio.h>
#include <termios.h>     //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>      //STDIN_FILENO

/**
 * Constantes
 */
#define DimMatrix 3      //matrix dimension 3x3
#define SizeMatrix  DimMatrix*DimMatrix //=9

extern int developer;   

/**
 * Global variables
 */
// Matrix 3x3 with initial tiles
char tilesIni[DimMatrix][DimMatrix] = { {'1','2','4'},
                                        {'E','8','A'},
                                        {'C','6',' '} }; 

// Matrix 3x3 with game tiles
char tiles[DimMatrix][DimMatrix]    = { {'1','2','4'},
                                        {'6','8','A'},                                     
                                        {'C','E',' '} };

// Matrix 3x3 with goal tiles
char tilesEnd[DimMatrix][DimMatrix] = { {'1','2','4'},
                                        {'E',' ','6'},
                                        {'C','A','8'} }; 
                                        
/**
 * C functions definition
 */
void clearscreen_C();
void gotoxyP2_C();
void printchP2_C(char);
char getchP2_C();

char printMenuP2_C();
void printBoardP2_C();

void updateBoardP2_C(char[DimMatrix][DimMatrix], int);
int  spacePosScreenP2_C();
void copyMatrixP2_C(char[DimMatrix][DimMatrix]);
int  moveTileP2_C(char, int);
char checkStatusP2_C(int, int, int);
void printMessageP2_C(char);
void playP2_C();

/**
 * Definition of assembly subroutines called from C.
 */
void updateBoardP2(char[DimMatrix][DimMatrix], int);
int  spacePosScreenP2();
void copyMatrixP2(char[DimMatrix][DimMatrix]);
int  moveTileP2(char, int);
char checkStatusP2(int, int, int);
void playP2();


/**
 * Clear screen
 * 
 * Used global variables:   
 * None
 *
 * Passed arguments: 
 * None
 *   
 * Returned parameters : 
 * None
 * 
 */
void clearScreen_C(){
   
    printf("\x1B[2J");
    
}


/**
 * Place the cursor in a row and col of the screen
 * depending on the rowScreen and colScreen variables 
 * received as a parameter.
 * 
 * Used global variables:   
 * None
 *
 * Passed arguments: 
 * rdi(edi): (rowScreen): Row
 * rsi(esi): (colScreen): Column
 *   
 * Returned parameters : 
 * None
 * 
 * Equivalent assembly subroutine 'gotoxyP2' 
 *
 */
void gotoxyP2_C(int rowScreen, int colScreen){
   
   printf("\x1B[%d;%dH",rowScreen,colScreen);
   
}


/**
 * Display a character (c) on screen, received as parameter 
 * on the cursor position
 * 
 * Used global variables:   
 * None
 *
 * Passed arguments: 
 * rdi(dil): (c): Character to be shown.
 *   
 * Returned parameters : 
 * None
 * 
 * Equivalent assembly subroutine 'printchP2' 
 *
 */
void printchP2_C(char c){
   
   printf("%c",c);
   
}


/**
 * Read a key and return its associated character
 * 
 * Used global variables:   
 * None
 *
 * Passed arguments: 
 * None
 *   
 * Returned parameters : 
 * rax(al): (c): Character read from keyboard
 * 
 * Equivalent assembly subroutine 'getchP2'
 *
 */
char getchP2_C(){

   int c;   

   static struct termios oldt, newt;

   /*tcgetattr get terminal parameters from stdin on oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /* copy params */
   newt = oldt;

    /* ~ICANON to handle entered key as characters 
    ~ECHO so the read character is not displayed. */
   newt.c_lflag &= ~(ICANON | ECHO);          

   /* Set new parameters from terminal for the STDIN
   TCSANOW tells tcsetattr to immediately change parameters. */
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /* Read a character */
   c=getchar();                 
    
   /* Restore original parameters */
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);

   /* Return read character */
   return (char)c;
   
}


/**
 * Display on screen the game menu and ask an option
 * Only accepts '0'-'9'
 *
 */
char printMenuP2_C(){

   clearScreen_C();
   gotoxyP2_C(1,1);
   printf("                               \n");
   printf("         Developed by:         \n");
   printf("      ( %s )    \n",(char *)&developer);
   printf(" _____________________________ \n");
   printf("|                             |\n");
   printf("|          MAIN MENU          |\n");
   printf("|_____________________________|\n");
   printf("|                             |\n");
   printf("|      1. updateBoard         |\n");
   printf("|      2. spacePosScreen      |\n");
   printf("|      3. copyMatrix          |\n");
   printf("|      4. moveTiles           |\n");
   printf("|      5. checkStatus         |\n");
   printf("|      6. Play Game           |\n");
   printf("|      7. Play Game C         |\n");
   printf("|      0. Exit                |\n");
   printf("|_____________________________|\n");
   printf("|                             |\n");
   printf("|         OPTION:             |\n");
   printf("|_____________________________|\n"); 

   char charac =' ';
    while (charac < '0' || charac > '7') {
      gotoxyP2_C(19,19);      //posicionar el cursor
      charac = getchP2_C();   //Leer una opción
   }
   return charac;
   
}


/**
 * Display game board 
 * 
 */
void printBoardP2_C(){

   gotoxyP2_C(0,0);                                   //Filas
                                                      //Tablero
   printf(" _____________________________________ \n"); //01
   printf("|                                     |\n"); //02
   printf("|           8-PUZZLE  v2.0            |\n"); //03
   printf("|                                     |\n"); //04
   printf("|      Order the tiles as shown!      |\n"); //05
   printf("|_____________________________________|\n"); //06
   printf("|                                     |\n"); //07
   printf("|  Remaining Moves[_]    FINAL GOAL   |\n"); //08
   printf("|                                     |\n"); //09
   //             8   12  16                           <- Columnas Tablero              
   printf("|      0   1   2         0   1   2    |\n"); //10
   printf("|    +---+---+---+     +---+---+---+  |\n"); //11
   printf("|  0 |   |   |   |   0 | 1 | 2 | 4 |  |\n"); //12
   printf("|    +---+---+---+     +---+---+---+  |\n"); //13
   printf("|  1 |   |   |   |   1 | E |   | 6 |  |\n"); //14
   printf("|    +---+---+---+     +---+---+---+  |\n"); //15
   printf("|  2 |   |   |   |   2 | C | A | 8 |  |\n"); //16
   printf("|    +---+---+---+     +---+---+---+  |\n"); //17
   printf("|_____________________________________|\n"); //18
   printf("|                                     |\n"); //20
   printf("|   (i)Up (j)Left (k)Down (l)Right    |\n"); //21
   printf("|             (ESC)  Exit             |\n"); //22
   printf("|_____________________________________|\n"); //23
            
}


/**
 * Display values of matrix (t), received as a parameter, on screen
 * on the board.
 *
 */
void updateBoardP2_C(char t[DimMatrix][DimMatrix], int moves){

   int i, j;
   int rowScreen, colScreen;
   rowScreen = 12;
   for (i=0;i<DimMatrix;i++){
	  colScreen = 8;
      for (j=0;j<DimMatrix;j++){
         gotoxyP2_C(rowScreen, colScreen);
         printchP2_C(t[i][j]);
         colScreen = colScreen + 4;
      }
      rowScreen = rowScreen + 2;
   }
   
   gotoxyP2_C(8, 20);
   moves = moves + '0';
   printchP2_C(moves);
   
   
}

/**
 * Locate the space in matrix (tiles), position cursor on it,
 * and return its position inside the matrix.
 *
 */
int spacePosScreenP2_C(){

   int i=0, j=0, pos=0;
   while ((pos<SizeMatrix) && (tiles[i][j]!=' ')){
      pos++;
      i = pos / DimMatrix;
      j = pos % DimMatrix;
   }
   if (pos < SizeMatrix){  // Space found
   	  int row = i*2 + 12;
	  int col = j*4 + 8;
      gotoxyP2_C(row, col);// Set the cursor on the board where the space is
   }
   return pos;
}


/**
 * Copy initial matrix (tilesIni) on the matrix (t), received as parameter
 * 
 */
void copyMatrixP2_C(char t[DimMatrix][DimMatrix]){
   
   int i, j;

   for (i=0;i<DimMatrix;i++){
      for (j=0;j<DimMatrix;j++){
         t[i][j] = tilesIni[i][j];
      }
   }

}


/**
 * Swap the chip on the direction pointed by character (charac)
 * ('i':up, 'k':down, 'j':left o 'l':right) received as a parameter
 * where there is the space in the matrix indicated by the variable (spacePos)
 * received as a parameter, considering the cases where there can be no movement.
 * If the tile is in the edge of the board, the movement from there cannot be done
 * If the movement is allowed, move the chip where the space is located 
 * and place the space where the tile was.
 * 
 */
int moveTileP2_C(char charac, int spacePos){

   int i = spacePos / DimMatrix;
   int j = spacePos % DimMatrix;
   int newPosSpace = spacePos;

   switch(charac){
      case 'i': //arriba
         if (i < (DimMatrix-1)) {
			newPosSpace = spacePos+DimMatrix;
            tiles[i][j]= tiles[i+1][j]; //
            tiles[i+1][j] = ' ';
         }
      break;
      case 'k': //abajo
         if (i > 0) {
			newPosSpace = spacePos-DimMatrix;
            tiles[i][j]= tiles[i-1][j];
            tiles[i-1][j] = ' ';
            
         }
      break;
      case 'j': //izquierda
         if (j < (DimMatrix-1)) {
			newPosSpace = spacePos+1;
            tiles[i][j]= tiles[i][j+1];
            tiles[i][j+1] = ' ';
         }
      break;
      case 'l': //derecha
         if (j > 0) {
			newPosSpace = spacePos-1;
            tiles[i][j]= tiles[i][j-1];
            tiles[i][j-1] = ' ';
         }
      break;
      
   }
   return newPosSpace;
  
}


/**
 * Verify game state
 * If moves ran out (moves == 0), set status='3'
 * If the move could not be done (spacePos == newSpacePos), set status='2'.
 * Else:
 * Check if matrix (tiles) is equal to target matrix (tilesEnd).
 * If all positions are equal, set status = '4' to indicate win condition.
 *
 */
char checkStatusP2_C(int moves, int spacePos, int newSpacePos) {
   
   char status;
   int  sorted = 1;
   int  i=0, j=0, k=0;
   
   if (moves == 0) {
      status= '3';
   } else if (spacePos == newSpacePos) {
	      status= '2';
   } else {
      while ((k<SizeMatrix) && (sorted==1)){
		 i = k / DimMatrix;   // En ensamblador no es necesario
         j = k % DimMatrix;   // calcular la 'i' y la 'j'. Utilizamos 'k'.
         if (tiles[i][j]!=tilesEnd[i][j]) {
           sorted=0;
         }
         k++;
      }
      if (sorted==1){
         status = '4'; 
      } else {
         status = '1';
      }
   }
   return status;
   
}


/**
 * Display a message under the board depending on the status variable
 * status: '1': Continue playing
 *         '2': The move could not be done
 *         '3': Defeat, no moves remaining
 *         '4': Win, all tiles are sorted
 *         '5': Error, space not found.
 *
 */
void printMessageP2_C(char status) {

   gotoxyP2_C(24, 2);
   
   switch(status){
      case '0':
         printf("<<<<<<<< EXIT: (ESC) Pressed >>>>>>>>");
      break;
      case '1':
         printf("============  NEXT MOVE  ============");
      break;
      case '2':
         printf("***********  CAN'T  MOVE  ***********");
      break;
      case '3':
         printf("------- SORRY, NO MORE MOVES! -------");
      break;
      case '4':
         printf("+++++++++ SORTED!!! YOU WIN +++++++++");
      break;
      case '5':
         printf("xxxxxxxxx ERROR -> NO SPACE xxxxxxxxx");
      break;
   }
   
}


/**
 * Main game function
 * 
 * Display board game calling printBoard2_C.
 * Initialize game state, (state='1').
 * Initialize max allowed moves (moves = 9).
 * Initialize matrix (tiles) with initial matrix's values (tilesIni)
 * caling copyMatrixP2_C subroutine.
 * While state=='1':
 *   Update board calling updateBoardP2
 *   Look for space inside matrix (tiles) and position 
 *   the cursor calling subroutine spacePosScreenP2.
 *   If the space is found:
 *     Make the space position the new space position (spacePos = newSpacePos)
 *     Read a key calling getchP2.
 *     Depending on the key, one subrutine or another will be called:
 *      - ['i','j','k' o 'l'] move the tile on a direction calling moveTileP2.
 *        If a move has been done, decrease available moves (moves--).
 *        Check game state calling checkStatusP2.
 *      - '<ESC>'  (ASCII 27) set state = '0' to exit.   
 *    If the space is not found:
 *    	Set state='5' to indicate it. 
 *    Display a message under the game board depending on the state variable calling
 *    printMessageP2 subroutine.
 *    If the move could not be done, set state = '1' to continue playing. 
 * 
 * Before exiting, update board calling updateBoardP2 and position the cursor 
 * where the space is calling spacePosScreenP2.
 * Wait for a key input calling getchP2
 * Exit game.
  */
void playP2_C(){
	
   printBoardP2_C();
   
   int spacePos = 0;// Space position inside matrix (3x3),
                    //spacePos [0 : (SizeMatrix-1)].
	                //Row = pos / DimMatrix  [0 : (DimMatrix-1)]
                    //Col = pos % DimMatrix [0 : (DimMatrix-1)]
   int newSpacePos; //New position after move.
   
   char state = '1';//'0':Exit, 'ESC' pressed
                    //'1': Continue playing
                    //'2': The move could not be done
                    //'3': Defeat, no moves remaining
                    //'4': Win, all tiles are sorted 
                    //'5': Error, space not found.
   
   int moves = 9;   //Remaining moves.
   
   char charac;
   
   copyMatrixP2_C(tiles);
      
   while (state == '1') {                    //Main loop.
	  updateBoardP2_C(tiles, moves);
      newSpacePos = spacePosScreenP2_C(); 
      if (newSpacePos < SizeMatrix) {
         spacePos = newSpacePos;
         
         charac = getchP2_C();                         //Red a key

         if (charac>='i' && charac<='l') {
            newSpacePos = moveTileP2_C(charac, spacePos);
            if (newSpacePos != spacePos) moves--;
            state = checkStatusP2_C(moves, spacePos, newSpacePos);             
         } else if (charac==27) {
            state='0';
         }
      } else {
         state = '5';
      }
      printMessageP2_C(state);
      if (state == '2') state = '1'; 
   }
   updateBoardP2_C(tiles, moves);
   spacePosScreenP2_C();
   getchP2_C();     //Wait for user input.
   
}


/**
 * Main program
 * 
 */
int main(void){   

   int spacePos = 0;// Space position inside matrix (3x3),
                    //spacePos [0 : (SizeMatrix-1)].
	                //Row = pos / DimMatrix  [0 : (DimMatrix-1)]
                    //Column = pos % DimMatrix [0 : (DimMatrix-1)]
   int newSpacePos; //New position after move.
   
   char state = '1';//'0':Exit, 'ESC' pressed
                    //'1': Continue playing
                    //'2': The move could not be done
                    //'3': Defeat, no moves remaining
                    //'4': Win, all tiles are sorted 
                    //'5': Error, space not found.
   
   int moves = 9;   //Remaining moves.
   
   char op = '9';
   char charac;    
   
   while (op != '0') {
     op = printMenuP2_C();    //Display menu.
     switch(op){
        case '1'://Update board.  
          printBoardP2_C();      
          //=======================================================
            updateBoardP2(tiles, moves);
            //updateBoardP2_C(tiles, moves);
          //=======================================================
          gotoxyP2_C(24, 12);
          printf(" Press any key ...");
          getchP2_C();
        break;
        case '2': //Look for space in matrix and place cursor there
                  
          printBoardP2_C();
          updateBoardP2_C(tiles, moves);
          gotoxyP2_C(24, 12);
          printf(" Press any key ...");
          //=======================================================        
            newSpacePos = spacePosScreenP2();
            //newSpacePos = spacePosScreenP2_C();
          //=======================================================
          if (newSpacePos == SizeMatrix) {
             gotoxyP2_C(24, 10);
             printf(" ERROR -> NO SPACE: Press any key ...");
          } 
          getchP2_C();
        break;
        case '3': //Copy matrix tilesIni to tiles.
          printBoardP2_C();
          gotoxyP2_C(24, 10);
          //=======================================================
            copyMatrixP2(tiles);
            //copyMatrixP2_C(tiles); 
          //=======================================================
          gotoxyP2_C(24, 12);
          printf(" Press any key ...");
          updateBoardP2_C(tiles, moves);
          spacePosScreenP2_C();
          getchP2_C();
        break;
        case '4': //Move chip in correct direction
          moves = 9;
          printBoardP2_C();
          gotoxyP2_C(24, 12);
          printf(" Press i,j,k,l: ");
          updateBoardP2_C(tiles, moves);
          spacePos = spacePosScreenP2_C();
          charac = getchP2_C();   
          if (charac>='i' && charac<='l') {
          //=======================================================
             newSpacePos = moveTileP2(charac, spacePos);
             //newSpacePos = moveTileP2_C(charac, spacePos);
          //=======================================================
             if (newSpacePos != spacePos) moves--;
             updateBoardP2_C(tiles, moves);
             spacePosScreenP2_C();
             state =checkStatusP2_C(moves, spacePos, newSpacePos);
             printMessageP2_C(state);
             gotoxyP2_C(23,12);
             printf(" Press any key ...");
          } else {			 
             gotoxyP2_C(24, 12);
             printf(" Incorrect key !!!");
          }
          getchP2_C();
        break;
        case '5': // Check game state
          printBoardP2_C();    
          moves = 5;
          ///moves = 0; //state='3' -> NO MORE MOVES
          updateBoardP2_C(tiles, moves);
          newSpacePos = spacePosScreenP2_C();
          spacePos = newSpacePos; ///state='2' -> CAN'T MOVE
          ///spacePos = 0; //state='1' -> NEXT MOVE
          //=======================================================
            state = checkStatusP2(moves, spacePos, newSpacePos);
            //state = checkStatusP2_C(moves, spacePos, newSpacePos);
          //=======================================================
          printMessageP2_C(state);
          gotoxyP2_C(23, 12);
          printf(" Press any key ...");
          getchP2_C();  
        break;
        case '6': // Check game state
          //=======================================================
          playP2();
          //=======================================================
        break;
        case '7': // Full game on C.
          //=======================================================
          playP2_C();
          //=======================================================
        break;
     }
  }
  printf("\n\n");
  
  return 0;
  
}
