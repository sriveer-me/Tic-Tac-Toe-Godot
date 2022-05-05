extends Control

onready var globalFlags = get_node("/root/GlobalFlags")
export var gameBoard = [0,0,0,0,0,0,0,0,0];

#player piece
func placeCircle(positionX,positionY):
	gameBoard[(positionY * 3) + positionX] = 1;

#computer piece
func placeCross(gameBoardPosition):
	gameBoard[gameBoardPosition] = 2;
	print('cross placed in %s,%s'%[gameBoardPosition%3,gameBoardPosition/3]);

func isPositionEmpty(positionX,positionY):
	return gameBoard[(positionY * 3) + positionX] == 0

func gameBoardFull(board):
	var flag = true;
	for val in board:
		if(val == 0):
			flag = false;
			break;
	return flag;

#return 
# 0 means not Over COMPUTER DECLARES DRAW WHEN IT HAS NO MORE SLOTS TO PLACE.
# 1 means player victory 
# 2 means computer victory
func gameOver(gameBoard):
	
	#horizontal lines
	if(gameBoard[0] == gameBoard[1] and gameBoard[1] == gameBoard[2] and gameBoard[0] != 0):
		return gameBoard[0];
	if(gameBoard[3] == gameBoard[4] and gameBoard[4] == gameBoard[5] and gameBoard[3] != 0):
		return gameBoard[3];
	if(gameBoard[6] == gameBoard[7] and gameBoard[7] == gameBoard[8] and gameBoard[6] != 0):
		return gameBoard[6];
	
	#vertical lines
	if(gameBoard[0] == gameBoard[3] and gameBoard[3] == gameBoard[6] and gameBoard[0] != 0):
		return gameBoard[0];
	if(gameBoard[1] == gameBoard[4] and gameBoard[4] == gameBoard[7] and gameBoard[1] != 0):
		return gameBoard[1];
	if(gameBoard[2] == gameBoard[5] and gameBoard[5] == gameBoard[8] and gameBoard[2] != 0):
		return gameBoard[2];
	
	#diagnol lines
	if(gameBoard[0] == gameBoard[4] and gameBoard[4] == gameBoard[8] and gameBoard[0] != 0):
		return gameBoard[0];
	if(gameBoard[2] == gameBoard[4] and gameBoard[4] == gameBoard[6] and gameBoard[2] != 0):
		return gameBoard[2];

	return 0;

var oppositeValue = {
	"1":2,
	"2":1
}
func miniMaxPlay(board,value = 2,isMax = true,depth = 0):
	#start check if the game is over and is the result favourable or not
	var gameVictor = gameOver(board);
	if(gameVictor == 2): #computer victory
		return {"score" : 10 - depth ,"move":null};
	elif(gameVictor == 1): #player victory
		return {"score" : -10 + depth ,"move":null};
	elif(gameBoardFull(board)): #tie
		return {"score" : 0, "move":null};
	#end check if game is over block
	
	var move = null;
	
	if(isMax):
		var counter = 0;
		var maxValue = -INF;
		for position in board:
			if(position == 0):
				board[counter] = value;
				var ret = miniMaxPlay(board.duplicate(),oppositeValue[str(value)],!isMax,depth + 1)
				if(maxValue < ret["score"]):
					maxValue = ret["score"];
					move = counter;
				board[counter] = 0;
			counter = counter +1;
		return {"score": maxValue,"move": move}
	else:
		var counter = 0;
		var minValue = INF;
		for position in board:
			if(position == 0):
				board[counter] = value;
				var ret = miniMaxPlay(board.duplicate(),oppositeValue[str(value)],!isMax,depth + 1)
				if(minValue > ret["score"]):
					minValue = ret["score"];
					move = counter;
				board[counter] = 0;
			counter = counter +1;
		return {"score": minValue,"move": move}

func enemyMove():
	var newMovement = miniMaxPlay(gameBoard.duplicate())["move"];
	if(newMovement == null):
		print("Game Over In Tie");
	else:
		print("cross placed in %s" % newMovement);
		placeCross(newMovement);
		globalFlags.playerCanChoose = true;

func PlayerPiecePlaced(position):
	if(isPositionEmpty(position.x,position.y) != true):
		print("error, player placed a piece on already occupied slot");
	placeCircle(position.x,position.y);
	if(gameOver(gameBoard)):
			print("game over player won");
	else: 
		enemyMove();
		if(gameOver(gameBoard)):
			print("game over computer won");
