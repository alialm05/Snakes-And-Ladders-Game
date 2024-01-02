%%-- Variables
var x, y, dice, c, c2 : int
var r2, r, row, row2, column, column2, oldcolumn, oldcolumn2, oldrow, oldrow2, currentDice : int

%---- starter values ----%
c := 1
c2 := 1

% player 1 (you)
column := 1
row := 20
%player 2 (opponent)
column2 := 1
row2 := 20

oldcolumn := 0
oldcolumn2 := 0

var board := "snakes.jpg"
var backdrop := "backdrop2.jpg"
var song := "Undertale - Hopes and Dreams.MP3"
var Color1 : int := 63
var Color2 : int := 79
var ColorStroke1 : int := 38
var ColorStroke2 : int := 34
var currentColor, oppColor, currentColorStroke, oppColorStroke : int

var intfont, intfont2, intscore, intstage, spotchanged, spotchangedInner : int
var YourTurn : boolean := true
var both, gameEnded : boolean := false
var rollDiceLimit : int := 25

var chars : array char of boolean

setscreen ("offscreenonly")

%%-- Fonts
intfont := Font.New ("Futura-Bold:15")
intstage := Font.New ("Palatino:13:Bold,Italic")
intscore := Font.New ("Futura-Bold:25")
intfont2 := Font.New ("Futura-Bold:7")

var spotChangeNum : int
var SpotChanges : array 1 .. 100 of int := init (

%spots where place changes will be made either by snake or ladder
    0, 0, 48, 0, 0, 21, 0, 0, 0, 0,     % row 1
    0, 0, 0, 0, 0, 0, 0, 0, 0, 50,      % row 2
    0, 0, 0, 0, -20, 0, 0, 0, 0, 0,     % row 3
    0, 0, 0, -34, 0, 19, 0, 0, 0, 0,    % row 4
    0, 0, 0, 0, 0, 0, -28, 0, 0, 0,     % row 5
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,       % row 6
    0, 0, 32, 0, -13, 0, 0, 30, 0, 0,   % row 7
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,       % row 8
    0, 0, 0, 0, 0, 0, -30, 0, 0, 0      % row 9
    - 30, 0, 0, 0, 0, 0, 0, 0, -30, 0, 0 % row 10

    )

%----------------------------------------------------------------

%--where the board is positioned:--%
x := 120
y := 1
%------------------------------------

%plays the song while the program is running
Music.PlayFileLoop (song)


%---------- Drawing Board + Player Position Function -------------------%

procedure drawBoard (currentDice, c, column, row, column2, row2 : int)

    % draws actual snake board

    Pic.ScreenLoad (backdrop, 0, 0, picCopy)
    Pic.ScreenLoad (board, x, y, picCopy)

    if YourTurn = true then
	%label for the Dice Count
	Font.Draw ("Your Turn", 10, 350, intfont, Color1)
	Font.Draw (intstr (currentDice), 20, 300, intscore, Color1)

	%Label for your position on the board
	Font.Draw ("Your Place:", 540, 350, intstage, Color1 + 1)
	Font.Draw (intstr (c), 550, 300, intstage, Color1 + 1)

    else

	Font.Draw ("Opponents", 10, 250, intfont, Color2)
	Font.Draw ("Turn", 13, 230, intfont, Color2)
	Font.Draw (intstr (currentDice), 20, 190, intscore, Color2)

	%Label for your position on the board
	Font.Draw ("Opponents", 540, 250, intstage, Color2 + 1)
	Font.Draw ("Place:", 543, 230, intstage, Color2 + 1)
	Font.Draw (intstr (c), 550, 190, intstage, Color2 + 1)

    end if

    %Draws player's circle in their position

    drawfilloval (102 + (column2 * 40), row2, 15, 15, ColorStroke2)     %% the outline of the circle (stroke)
    drawfilloval (100 + (column2 * 40), row2, 15, 15, Color2)           %% the main circle

    drawfilloval (102 + (column * 40), row, 15, 15, ColorStroke1) %% the outline of the circle (stroke)
    drawfilloval (100 + (column * 40), row, 15, 15, Color1)       %% the main circle

end drawBoard

%-----------------------------------------------

procedure playerWon (currentDice, cc, col, r, oppColumn, oppRow, C, O, CStroke, OStroke : int)

    for i : 1 .. 30

	drawBoard (currentDice, cc, col, r, column2, row2)

	spotchanged := Font.New ("Verdana:" + intstr (i) + ":Bold")
	spotchangedInner := Font.New ("Verdana:" + intstr (i) + ":Bold")

	if YourTurn = true then

	    Font.Draw ("YOU WON!", (245 - (i * 3)) + 3, 400 - (i * 8), spotchanged, 123)
	    Font.Draw ("YOU WON!", 245 - (i * 3), 400 - (i * 8), spotchangedInner, 49)

	else

	    Font.Draw ("YOU LOST!", (225 - (i * 3)) + 3, 400 - (i * 8), spotchanged, 112)
	    Font.Draw ("YOU LOST!", 225 - (i * 3), 400 - (i * 8), spotchangedInner, 40)

	end if

	if i = 30 then


	spotchanged := Font.New ("Verdana:15:Bold")
	spotchangedInner := Font.New ("Verdana:15:Bold")
	
	    View.Update ()
	    delay (500)

	    gameEnded := true

	    %will stop the game until the players decides to retry the game
	    loop

		Font.Draw ("PRESS ENTER TO PLAY AGAIN", (225 - (20 * 3)) + 3, 400 - (25 * 8), spotchanged, 123)
		Font.Draw ("PRESS ENTER TO PLAY AGAIN", 225 - (20 * 3), 400 - (25 * 8), spotchangedInner, 49)

		Input.KeyDown (chars)

		drawfilloval (102 + (column2 * 40), row2, 15, 15, ColorStroke2)      %% the outline of the circle (stroke)
		drawfilloval (100 + (column2 * 40), row2, 15, 15, Color2)

		drawfilloval (102 + (column * 40), row, 15, 15, ColorStroke1)      %% the outline of the circle (stroke)
		drawfilloval (100 + (column * 40), row, 15, 15, Color1)


		% -- Shows Player's Place

		Font.Draw ("Your Place:", 540, 350, intstage, Color1)
		Font.Draw (intstr (c), 550, 300, intstage, Color1)

		Font.Draw ("Opponents", 540, 250, intstage, Color2)
		Font.Draw ("Place:", 543, 230, intstage, Color2)
		Font.Draw (intstr (c2), 550, 190, intstage, Color2)

		% -- When enter is Pressed
		if chars (KEY_ENTER) then
		    cls

		    % resets the player's values

		    column := 1
		    column2 := 1
		    row := 20
		    row2 := 20
		    c := 1
		    c2 := 1
		    %resets the other values
		    both := false
		    YourTurn := true
		    %resets the game
		    drawBoard (0, c, column, row, column2, row2)

		    exit

		else

		    View.Update ()
		    delay (25)

		end if

	    end loop


	else
	    View.Update ()
	    delay (1)
	    cls
	end if
    end for

end playerWon


%---------- Circle Animates -------------------%
procedure playerMove (currentDice, c, column, row, oppColumn, oppRow, C, O, CStroke, OStroke : int)

    for decreasing h2 : 23 .. 1

	Pic.ScreenLoad (backdrop, 0, 0, picCopy)
	Pic.ScreenLoad (board, x, y, picCopy)

	if YourTurn = true then

	    %Label for your Dice
	    Font.Draw ("Your Turn", 10, 350, intfont, C)
	    Font.Draw (intstr (currentDice), 20, 300, intscore, C)

	    %Label for your position on the board
	    Font.Draw ("Your Place:", 540, 350, intstage, C - 1)
	    Font.Draw (intstr (c), 550, 300, intstage, C - 1)

	else     % (if its not your turn)

	    %Label for your opponent's Dice
	    Font.Draw ("Opponents", 10, 250, intfont, Color2)
	    Font.Draw ("Turn", 13, 230, intfont, Color2)
	    Font.Draw (intstr (currentDice), 20, 190, intscore, Color2)

	    %Label for opponent's position on the board
	    Font.Draw ("Opponents", 540, 250, intstage, Color2 - 1)
	    Font.Draw ("Place:", 543, 230, intstage, Color2 - 1)
	    Font.Draw (intstr (c), 550, 190, intstage, C - 1)
	end if


	%% draws each player's circle

	drawfilloval (102 + (column * 40) - h2, row, 15, 15, CStroke)     %% the outline of the circle (stroke)
	drawfilloval (100 + (column * 40) - h2, row, 15, 15, C)

	drawfilloval (102 + (oppColumn * 40), oppRow, 15, 15, OStroke)      %% the outline of the circle (stroke)
	drawfilloval (100 + (oppColumn * 40), oppRow, 15, 15, O)

	View.Update ()
	delay (1)
	cls
    end for

    oldcolumn := column
    oldrow := row

    delay (50)

end playerMove

%---------------------------------------------------------------

%-------------------Spot Changed Function----------------------%
procedure spotChanged (change, C, currentDice, c, column, row, column2, row2 : int)

    for i : 1 .. 30

	drawBoard (currentDice, c, column, row, column2, row2)

	if change > 0 then

	    spotchanged := Font.New ("Verdana:" + intstr (i) + ":Bold")
	    spotchangedInner := Font.New ("Verdana:" + intstr (i) + ":Bold")

	    if YourTurn = true then



		Font.Draw ("YOU FOUND A LADDER", (245 - (i * 6)) + 3, 400 - (i * 6), spotchanged, 123)
		Font.Draw ("YOU FOUND A LADDER", 245 - (i * 6), 400 - (i * 6), spotchangedInner, 49)

	    else


		Font.Draw ("OPPONENT FOUND ", (245 - (i * 6)) + 3, 400 - (i * 6), spotchanged, 123)
		Font.Draw ("OPPONENT FOUND ", 245 - (i * 6), 400 - (i * 6), spotchangedInner, 49)

		Font.Draw ("A LADDER", (320 - (i * 6)) + 3, 400 - (i * 7), spotchanged, 123)
		Font.Draw ("A LADDER", 320 - (i * 6), 400 - (i * 7), spotchangedInner, 49)

	    end if
	else

	    if i <= 28 then
		spotchanged := Font.New ("Verdana:" + intstr (i - 1) + ":Bold")
		spotchangedInner := Font.New ("Verdana:" + intstr (i - 1) + ":Bold")
	    end if

	    if YourTurn = true then

		Font.Draw ("YOU ENCOUNTERED A SNAKE!", (225 - (i * 7)) + 3, 400 - (i * 6), spotchanged, 112)
		Font.Draw ("YOU ENCOUNTERED A SNAKE!", 225 - (i * 7), 400 - (i * 6), spotchangedInner, 40)

	    else

		Font.Draw ("OPPONENT ENCOUNTERED ", (225 - (i * 7)) + 3, 400 - (i * 6), spotchanged, 112)
		Font.Draw ("OPPONENT ENCOUNTERED ", 225 - (i * 7), 400 - (i * 6), spotchangedInner, 40)

		Font.Draw ("A SNAKE!", (225 - (i * 6)) + 3, 400 - (i * 7), spotchanged, 112)
		Font.Draw ("A SNAKE!", 225 - (i * 6), 400 - (i * 7), spotchangedInner, 40)

	    end if
	end if

	if i ~= 30 then
	    View.Update ()
	    delay (15)
	    cls
	end if

    end for


    %drawBoard (currentDice, c, column, row, column2, row2)

    View.Update ()
    delay (1500)
    cls

    spotchanged := Font.New ("Verdana:13")

end spotChanged

%----------------------------------------------------------------------



%/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////%
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%------------------------------------------------------------------- STARTING --- LOOP --------------------------------------------------------------------%
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////%


procedure startGame ()

    loop

	%% --------------------------- your turn ------------------------- %%

	if YourTurn = true then


	    currentColor := Color1
	    oppColor := Color2
	    currentColorStroke := ColorStroke1
	    oppColorStroke := ColorStroke2

	    Pic.ScreenLoad (backdrop, 0, 0, picCopy)
	    Pic.ScreenLoad (board, x, y, picCopy)
	    Font.Draw ("Your Turn", 10, 350, intfont, Color1)



	    %------------------ looping until ENTER is pressed -----------------------------

	    loop

		Input.KeyDown (chars)
		Font.Draw ("Press Enter to Roll the Dice", 2, 250, intfont2, Color1)

		if both = true then

		    drawfilloval (102 + (column2 * 40), row2, 15, 15, ColorStroke2)  %% the outline of the circle (stroke)
		    drawfilloval (100 + (column2 * 40), row2, 15, 15, Color2)

		    drawfilloval (102 + (column * 40), row, 15, 15, ColorStroke1)  %% the outline of the circle (stroke)
		    drawfilloval (100 + (column * 40), row, 15, 15, Color1)
		else

		    drawfilloval (102 + (column * 40), 20, 15, 15, ColorStroke2) %% the outline of the circle (stroke)
		    drawfilloval (100 + (column * 40), 20, 15, 15, Color2)

		    drawfilloval (102 + (1 * 40), 20, 15, 15, ColorStroke1)  %% the outline of the circle (stroke)
		    drawfilloval (100 + (1 * 40), 20, 15, 15, Color1)
		end if

		% -- Shows Player's Place

		Font.Draw ("Your Place:", 540, 350, intstage, Color1)
		Font.Draw (intstr (c), 550, 300, intstage, Color1)

		Font.Draw ("Opponents", 540, 250, intstage, Color2)
		Font.Draw ("Place:", 543, 230, intstage, Color2)
		Font.Draw (intstr (c2), 550, 190, intstage, Color2)

		% -- When enter is Pressed
		if chars (KEY_ENTER) then
		    cls
		    exit
		end if
		View.Update ()
		delay (50)
	    end loop


	    % ------------- rolling the dice ---------------


	    for k : 1 .. rollDiceLimit

		randint (dice, 1, 6)

		drawBoard (dice, c, column, row, column2, row2)

		% -- Shows Player's Place

		Font.Draw ("Your Place:", 540, 350, intstage, Color1)
		Font.Draw (intstr (c), 550, 300, intstage, Color1)

		Font.Draw ("Opponents", 540, 250, intstage, Color2)
		Font.Draw ("Place:", 543, 230, intstage, Color2)
		Font.Draw (intstr (c2), 550, 190, intstage, Color2)

		View.Update ()
		delay (79)

		if k ~= rollDiceLimit then
		    cls
		end if

	    end for

	    %---------------------Player Move + dice amount decreases------------------------

	    View.Update ()
	    delay (399)

	    for h : 1 .. dice

		c += 1
		currentDice := dice - h

		drawBoard (currentDice, c, column, row, column2, row2)

		r := floor (c / 10) * 10
		column := c - r

		if column = 0 then
		    r -= 10
		    column += 10
		end if

		row := 20 + round (r * 3.7) + round (r / 4)
		if not both then
		    oldrow := 20 + round (r * 3.7) + round (r / 4)
		end if

		% ----- tweening circle (animates) -----%

		playerMove (currentDice, c, column, row, column2, row2, currentColor, oppColor, currentColorStroke, oppColorStroke)

		if c >= 100 then
		    delay (100)
		    c := 100
		    playerWon (currentDice, c, column2, row2, column, row, currentColor, oppColor, currentColorStroke, oppColorStroke)
		    exit
		end if
	    end for

	    if gameEnded = true then
		exit
	    end if

	    % ------ SPOT CHANGES ------ %


	    for i : 1 .. 100

		if i = c then

		    spotChangeNum := SpotChanges (i)

		    if spotChangeNum ~= 0 then
			spotChanged (spotChangeNum, currentColor, currentDice, c2, column, row, column2, row2)
		    end if

		    c += SpotChanges (i)

		    r := floor (c / 10) * 10
		    column := c - r

		    if column = 0 then
			r -= 10
			column += 10
		    end if

		    row := 20 + round (r * 3.7) + round (r / 4)
		    if not both then
			oldrow := 20 + round (r * 3.7) + round (r / 4)
		    end if

		    exit
		end if
	    end for


	    %-------End of Turn---------%

	    drawBoard (currentDice, c, column, row, column2, row2)

	    View.Update ()
	    delay (79)
	    cls


	    YourTurn := false


	    %% ----------------------------- OPPONENTS TURN -----------------------------------%%


	else

	    currentColor := Color2
	    oppColor := Color1
	    currentColorStroke := ColorStroke2
	    oppColorStroke := ColorStroke1

	    drawfilloval (100 + (column * 40), row, 15, 15, Color1)

	    if both = true then
		drawfilloval (100 + (column2 * 40), row2, 15, 15, Color2)
		drawfilloval (100 + (column * 40), row, 15, 15, Color1)
	    end if




	    % ------------- rolling dice ---------------

	    for k : 1 .. rollDiceLimit

		randint (dice, 1, 6)

		drawBoard (dice, c2, column, row, column2, row2)

		% -- Shows Player's Place

		Font.Draw ("Your Place:", 540, 350, intstage, Color1)
		Font.Draw (intstr (c), 550, 300, intstage, Color1)

		Font.Draw ("Opponents", 540, 250, intstage, Color2)
		Font.Draw ("Place:", 543, 230, intstage, Color2)
		Font.Draw (intstr (c2), 550, 190, intstage, Color2)

		View.Update ()
		delay (79)

		if k ~= rollDiceLimit then
		    cls
		end if


	    end for

	    %-------------------- PLAYER MOVE -------------------------
	    delay (399)
	    both := true

	    for h : 1 .. dice

		c2 += 1
		currentDice := dice - h

		drawBoard (currentDice, c, column, row, column, row)

		r2 := floor (c2 / 10) * 10
		column2 := c2 - r2

		if column2 = 0 then
		    r2 -= 10
		    column2 += 10
		end if

		row2 := 20 + round (r2 * 3.7) + round (r2 / 4)
		if not both then
		    oldrow2 := 20 + round (r2 * 3.7) + round (r2 / 4)
		end if

		playerMove (currentDice, c2, column2, row2, column, row, currentColor, oppColor, currentColorStroke, oppColorStroke)


		%% if player won

		if c2 >= 100 then
		    c2 := 100
		    playerWon (currentDice, c, column2, row2, column, row, currentColor, oppColor, currentColorStroke, oppColorStroke)
		    exit
		end if

	    end for

	    if gameEnded = true then
		exit
	    end if

	    % ------ SPOT CHANGES ------ %


	    for i : 1 .. 100

		if i = c2 then

		    spotChangeNum := SpotChanges (i)

		    if spotChangeNum ~= 0 then
			spotChanged (spotChangeNum, currentColor, currentDice, c2, column, row, column2, row2)
		    end if

		    c2 += SpotChanges (i)

		    r2 := floor (c2 / 10) * 10
		    column2 := c2 - r2

		    if column2 = 0 then
			r2 -= 10
			column2 += 10
		    end if

		    row2 := 20 + round (r2 * 3.7) + round (r2 / 4)
		    if not both then
			oldrow2 := 20 + round (r2 * 3.7) + round (r2 / 4)
		    end if

		    exit
		end if
	    end for

	    % ------ End of Turn ------ %

	    YourTurn := true

	end if

	delay (1000)
	cls
    end loop

end startGame


%% this calls the function for the game to initially start
startGame ()
%%--------------------------------------------------

%% when the game ends and the player decides to retry the game
if gameEnded = true then
    startGame ()
end if
