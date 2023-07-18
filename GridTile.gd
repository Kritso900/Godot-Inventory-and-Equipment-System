extends Node
var position:Vector2i
var occupied:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LabelPos.text = str(position)
	$LabelOcc.text = "Yes" if occupied else "No"
	pass

