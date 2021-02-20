# 8-puzzle-ASM
8 puzzle game made in assembly

A simple project made for my subject "Structure of Computers" for my Bachelor's Degree for UOC university

## Screenshots 
Main menu

![Main menu](/images/main-menu.png)

Starting board

![Starting board](/images/starting-board.png)

Victory

![Victory](/images/victory.png)

Defeat

![Defeat](/images/defeat.png)


## Requirements
- Assembler (I used yasm)
- Compiler (I used gcc)
- Debugger (I used kdbg)

## Usage
Assemble the asm source code

`$ yasm –f elf64 –g dwarf2 8-puzzle.asm`

Generate the object file

`gcc -no-pie –o 8-puzzle 8-puzzle.o 8-puzzle.c`
	
Run/debug the game
`kdbg 8-puzzle`
	
In the main menu you can choose the option 6 to play the game with the assembly code, or do it with the C code. The game is identical in both of them.

Play it!

i - Move the tile up

k - Move the tile down

l - Move the tile right

j - Move the tile left


If the game is too difficult for you, you can easily increase the maximum moves by changing a variable in the code.
For ASM game, on line 870:

`mov r10d, 9`

For C game, on line 494:

`int moves = 9;`
	
