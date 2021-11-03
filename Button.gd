extends TextureButton

onready var GlobalFlags = get_node("/root/GlobalFlags");
var circleImage = load("res://art/circle.png");
var crossImage = load("res://art/cross.png");
export var position: Vector2 = Vector2(0,0);

onready var gameBoard = get_tree().get_nodes_in_group("main")[0].gameBoard;

signal playerPiecePlaced(position);

func occupied():
	return get("texture_normal") != null;

func onButtonPressed():
	if(occupied() == false and GlobalFlags.playerCanChoose == true):
		set("texture_normal",circleImage);
		GlobalFlags.playerCanChoose = false;
		emit_signal("playerPiecePlaced",position);
	else:
		print("slot already occupied");

func _process(delta):
	if(gameBoard[(position.y * 3)+position.x] == 2):
		set("texture_normal",crossImage);
