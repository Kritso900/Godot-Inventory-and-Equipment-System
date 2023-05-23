extends Node

@export var size:Vector2i = Vector2i(1,1)
var anchorLocation:Vector2i # Last known location on grid
var anchorRotation:int # Last known rotation on grid
var isheld:bool
var item:Resource = get_meta("metadata/ItemResource")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
