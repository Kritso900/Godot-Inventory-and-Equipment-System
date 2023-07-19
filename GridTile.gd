extends Node
var position:Vector2i
var occupied:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $".".get_global_rect().has_point(get_viewport().get_mouse_position()):
		_on_mouse_entered()
		
	$LabelPos.text = str(position)
	$LabelOcc.text = "Yes" if occupied else "No"
	pass




func _on_mouse_entered():
	DragDropController.hoveredTile = self
	
