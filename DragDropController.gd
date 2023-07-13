extends Node

var HeldItem:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (HeldItem):
		HeldItem.position = get_viewport().get_mouse_position() - HeldItem.imageRef.size/2
		
		
