extends Control

var isInitialised:bool

@export var item:ItemResource

@onready var imageRef:TextureRect = $TextureRect

#func _init(_item:ItemResource):
#	item = _item
#	imageRef.set_texture(item.itemUiImage)
#	isInitialised = true
#	pass
#
#func _ready():
#	if !isInitialised:
#		pass # Called if object is pre-placed in a scene, this shouldn't happen but is here incase a workaround is needed
func _ready():
	if(item):
		imageRef.set_texture(item.itemUiImage)




func _on_item_pickup_button_press():
	DragDropController.HeldItem = self
	$TextureRect/ItemPickupButton/ItemContextButton.disabled = true
	


func _on_item_pickup_button_release():
	DragDropController.HeldItem = null
	$TextureRect/ItemPickupButton/ItemContextButton.disabled = false





func _on_item_context_button_press():
	print("Right click")
	pass # Replace with function body.


func _on_item_pickup_button_mouse_entered():
	print("hover start")
	$Position.global_position
	pass # Replace with function body.


