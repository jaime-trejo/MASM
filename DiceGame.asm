INCLUDE Irvine32.inc


;------------------------------------------------------
mWriteString MACRO buffer:REQ
;
; Writes a string variable to standard output.
; Receives: string variable name.
;------------------------------------------------------
	push edx
	mov edx,OFFSET buffer
	call WriteString
	pop edx
ENDM

;------------------------------------------------------
mWriteName MACRO buffer:REQ
;
; Writes a name variable to standard output.
; Receives: string variable
;------------------------------------------------------
	push edx
	mov edx,buffer
	call WriteString
	pop edx
ENDM

;------------------------------------------------------
mReadString MACRO varName:REQ
;
; Reads from standard input into a buffer.
; Receives: the name of the buffer. Avoid passing
;    ECX and EDX as arguments.
;------------------------------------------------------
	push ecx
	push edx
	mov  edx,OFFSET varName
	mov  ecx,SIZEOF varName
	call ReadString
	pop  edx
	pop  ecx
ENDM

Game PROTO name1:PTR BYTE,name2:PTR BYTE

.data

consoleTitle BYTE "Dice Game",0
diceGameTitle BYTE "Dice Game ",0
diceGamePromptIntroduction BYTE "(Welcome to the Dice Game. This is a two player game.)",0

playersRolledPrompt BYTE "The players rolled. ",0
matchResultPrompt BYTE "The match result is ",0
slashPrompt BYTE "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ",0

playerRolled BYTE " rolled: ",0

playerLoses BYTE " Loses. ",0
playerWins BYTE " Wins. ",0
playerTies BYTE " Ties. ",0

player1NamePrompt BYTE "Please enter the name for player 1: ",0
player1Name BYTE 30 DUP(?)

player2NamePrompt BYTE "Please enter the name for player 2: ",0
player2Name BYTE 30 DUP(?)

playMatchAgainPrompt BYTE "Would you like to play another match enter (y,n): ",0
yesResponse BYTE "y",0

thanksForPlayingPrompt BYTE "Thanks For playing. ",0

.code
main proc

	INVOKE SetConsoleTitle, ADDR consoleTitle			;sets the console windows title

	call GamePageStart		;calls Procedure GamePageStart to run its purpose


	call clrscr				;clears the console window and locates the cursor at the upper left corner

	;asks for player1name and stores it into player1Name, asks for player2Name and stores it in player2Name
	mWriteString player1NamePrompt
	mReadString player1Name
	mWriteString player2NamePrompt
	mReadString player2Name
	call crlf
	call crlf

	;call the procedure game to start the simulation, passing in the players' names
	INVOKE Game, ADDR player1Name, ADDR player2Name

	;clears the screen and displays the following prompt, and starts 2 new lines
	;and sets color to gray foreground, black background
	call clrscr
	mov eax,white + (black* 16)
	call SetTextColor
	mWriteString thanksForPlayingPrompt
	call crlf
	call crlf


	exit

main endp

;------------------------------------
;GamePageStart PROC
;This procedure displays certain strings to
;the console at specific x,y coordinates.
;Ends with waiting the user to enter a key to continue
;receives: nothing
;returns:  nothing
;------------------------------------
GamePageStart PROC

	mov edx, 0		;sets edx to 0 so it won't have garbage

	mov dh,2		;y coordinate
	mov dl,35		;x coordinate
	call Gotoxy
	mWriteString diceGameTitle

	mov dh,15		;y coordinate
	mov dl,16		;x coordinate
	call Gotoxy
	mWriteString diceGamePromptIntroduction


	mov dh,20		;y coordinate
	mov dl,27		;x coordinate
	call Gotoxy
	call WaitMsg	;displays a message and waits for a key to be pressed

	ret
GamePageStart endP


;------------------------------------
;RollDie PROC
;Rolls a die.Only generates one random value
;at the time from range 1-6.
;receives: nothing
;returns:  nothing
;------------------------------------
RollDie PROC

		mov ebx,1		;lower bound
    mov eax,7		;upper bound
		mov ecx,1		;will only loop once


	;starts loop to loop once
	L1:
		mov eax,7			;sets upper bound all the time
		sub eax,ebx			;subtract 7-(1)  which is 6, range 0-6
		call RandomRange	;calls random range
		add eax,ebx			;add 0+1 = 1, so range 1-6
		call WriteDec		;writes integer value onto the screen

		loop L1

ret
RollDie endP


;------------------------------------
;Game PROC,name1:PTR BYTE,name2:PTR BYTE
;This procedure generates a random roll value
;for player 1 and 2, it then displays it with
;the following name.
;It also displays which player wins,loses, or ties.
;Red output means player won
;Yellow output means player lost
;Blue output means player ties
;receives: the name of player 1 and 2
;returns:  nothing
;------------------------------------
Game PROC,name1:PTR BYTE,name2:PTR BYTE

	mov eax,0
	mov ecx,0
	mov ebx,0				    ;will hold the die value of player 2
	mov edx,0				    ;will hold the die value of player 1


	call Randomize				;init random generator

	mov al, yesResponse			;sets the loop to true while it is 'y' yes

	;will continue looping if the user keeps choosing 'y'
	.While ( al == yesResponse)

	; empty two new lines and sets color to gray foreground, black background
	mov eax,white + (black* 16)
	call SetTextColor


	;displays the following onto the screen
	mWriteString playersRolledPrompt
	call crlf
	mWriteString slashPrompt
	call crlf


	; empty two new lines and sets color to gray foreground, black background
	mov eax,gray + (black* 16)
	call SetTextColor

	;displays the name of first player and what he/she rolled
	mWriteName name1
	mWriteString playerRolled
	call RollDie
	mov dl,al
	call crlf

	;displays the name of second player and what he/she rolled
	mWriteName name2
	mWriteString playerRolled
	call RollDie
	mov bl,al
	call crlf

	call crlf				;new line

	; empty two new lines and sets color to gray foreground, black background
	mov eax,white + (black* 16)
	call SetTextColor
	mWriteString matchResultPrompt
	call crlf
	mWriteString slashPrompt
	call crlf

			;the following loop will output which player wins,loses,ties with the corresponding player names
			;Red letters means that the player won
			;Yellow letters mean that the player lost
			;Blue letters mean that the player tied

			.IF(dl < bl)

				;prints out player1 loses in yellow foreground with black background
				mov eax,yellow + (black* 16)
				call SetTextColor
				mWriteName name1
				mWriteString playerLoses
				call crlf

				;prints out player2 wins in red foreground with black background
				mov eax,red+ (black* 16)
				call SetTextColor
				mWriteName name2
				mWriteString playerWins
				call crlf


				;sets color to white foreground, black background
				mov eax,white + (black* 16)
				call SetTextColor

			.ELSEIF( dl > bl)

				;prints out player1 wins in red foreground with black background
				mov eax,red+ (black* 16)
				call SetTextColor
				mWriteName name1
				mWriteString playerWins

				;prints out player2 loses in yellow foreground with black background
				mov eax,yellow + (black* 16)
				call SetTextColor
				call crlf
				mWriteName name2
				mWriteString playerLoses
				call crlf

				;sets color to white foreground, black background
				mov eax,white + (black* 16)
				call SetTextColor

			.ELSE

				;if both players tie then results will be output in blue foreground, black background
				mov eax,blue+ (black* 16)
				call SetTextColor
				mWriteName name1
				mWriteString playerTies
				call crlf
				mWriteName name2
				mWriteString playerTies
				call crlf

				;sets color to white foreground, black background
				mov eax,white + (black* 16)
				call SetTextColor

			.ENDIF



	;asks user if he/she wants to continue playing a match
	;sets color to green foreground, black background
	mov eax,green + (black* 16)
	call SetTextColor
	call crlf
	mWriteString playMatchAgainPrompt
	call ReadChar

	;new line
	call crlf
	call crlf


	.ENDW						;ends while loop

	ret
Game endP

end main
