# Chess Game
It is a command line Chess game where two players can play against each other.

## Features
- Two-player mode
- Legal move validation
- Check and checkmate detection
- Save and load game state

## How to Play
Run the script in [main.rb] (lib/main.rb) in terminal to play the game.
```
ruby lib/main.rb
```
Following introduction will be shown when starting a new game. Players take turns to move the piece.
```
Welcome to the Chess Game!

Type the position of the piece you want to move, and then new position for the piece.
i.e. Type 'a2 a3' to move the piece from a2 to a3

Let's start!
  ┌───┬───┬───┬───┬───┬───┬───┬───┐
8 │ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
7 │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
6 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
5 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
4 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
3 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
2 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
1 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │
  └───┴───┴───┴───┴───┴───┴───┴───┘
    A   B   C   D   E   F   G   H
Current Player: White
Enter the square of the piece to be moved, and which square to move to. e.g. 'a2 a3'
(You can type 'save' to save the game at any time)
```

### Save Game
You can type '**save**' to save the game anytime. The saved game will be added to the **/save** directory.
```
  ┌───┬───┬───┬───┬───┬───┬───┬───┐
8 │ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
7 │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
6 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
5 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
4 │ ♙ │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
3 │   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
2 │   │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
1 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │
  └───┴───┴───┴───┴───┴───┴───┴───┘
    A   B   C   D   E   F   G   H
Current Player: Black
Enter the square of the piece to be moved, and which square to move to. e.g. 'a2 a3'
(You can type 'save' to save the game at any time)
> save
```

### Load Saved Game
If there is any saved game found when starting the game, the following message will prompt.
```
You have previously saved game(s). Do you want to continue to play? (Y/N)
```
Type '**Y**' to load saved game or '**N**' to start a new game.

All incompleted saved games will be shown for selection. Enter corresponding option number to load the game.
```
Which saved game would you like to load? Please enter corresponding option number.
[1] save/saved_game_240712215105.yml
[2] save/saved_game_240712220016.yml
[3] save/saved_game_240712220031.yml
```

## Rules
Players can make any move that follows the movement rules below, except moves that would place their own king in check.

### Normal movement
- **King:** Moves one square in any direction (horizontally, vertically, or diagonally).
- **Rook:** Moves any number of vacant squares vertically or horizontally.
- **Bishop:** Moves any number of vacant squares diagonally.
- **Queen:** Moves any number of vacant squares vertically, horizontally, or diagonally.
- **Knight:** Moves in an 'L' shape: two squares in one direction and then one square perpendicular. Can jump over other pieces.
- **Pawn:** 
  - Moves forward one square. 
  - On its first move, it can move forward two squares.
  - Captures diagonally one square forward.
### Special Movement
- **En passant:** A special pawn capture that can occur immediately after a pawn moves two squares forward from its starting position and an opposing pawn could have captured it had it moved only one square forward.
- **Castling:** A special move involving the king and either rook:
  - King moves two squares towards a rook on the player's first rank, and then the rook moves to the square over which the king crossed.
  - Conditions:
    - Neither the king nor the rook involved has previously moved.
    - No pieces between the king and the rook.
    - The king is not currently in check, nor does it move through or end up in a square that is under attack.
- **Promotion:** When a pawn reaches the opponent's back rank (8th rank for White, 1st rank for Black), it is promoted to any other piece, typically a queen, but can also be a rook, bishop, or knight.

### End of Game
The game is over if either player is **mated** or the position is a **stalemate**.
