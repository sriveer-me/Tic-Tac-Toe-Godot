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

func gameBoardFull():
	var flag = true;
	for val in gameBoard:
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
func miniMaxPlay(board,value,isMax):
	#start check if the game is over and is the result favourable or not
	var gameVictor = gameOver(board);
	if(gameVictor == 2):
		return {"score" : 1, "move":null};
	elif(gameVictor == 1):
		return {"score" : -1,"move":null};
	elif(gameBoardFull()):
		return {"score" : 0, "move":null};
	#end check if game is over block
	
	var counter = 0;
	var highScore = null;
	var totalScore = 0;
	var bestMove = null;
	for point in board:
		if(point == 0):
			board[counter] = value;
			var ret = miniMaxPlay(board.duplicate(),oppositeValue[str(value)],!isMax);
			if(isMax):
				if(highScore == null or highScore < ret["score"]):
					highScore=ret["score"];
					bestMove=counter;
			else:
				if(highScore == null or highScore > ret["score"]):
					highScore=ret["score"];
					bestMove=counter;
			totalScore = ret["score"] + totalScore;
			board[counter] = 0;
		counter = counter + 1;
	
	return {"score":totalScore,"move":bestMove}


func getMovement(board1,board2):
	if(board1.size() != board2.size()):
		print("get movement failed as both the boards are of different sizes");
	
	for i in range(0,board1.size()):
		if(board1[i] == board2[i]):
			continue;
		else: return {"x":i%3,"y":i/3} 
	
	print("two similar boards are given");
	return null;

func enemyMove():
	var newMovement = miniMaxPlay(gameBoard.duplicate(),2,true)["move"];
	if(newMovement == null):
		print("Game Over In Tie");
	else:
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
