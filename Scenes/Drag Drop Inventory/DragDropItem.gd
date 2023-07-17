extends Control

var isInitialised:bool

@export var item:ItemResource

@onready var imageRef:TextureRect = $TextureRect





func setup(gridCellSize:Vector2):
	if(item):
		$TextureRect.set_texture(item.itemUiImage)
		$TextureRect.size = gridCellSize * Vector2(item.itemDragDropGridSize)
		$TextureRect/ItemPickupButton.tooltip_text = setupTooltip()


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

func setupTooltip():
	var _tooltipText:String = item.itemName
	match item.itemType:
		Globals.ItemTypes.TYPE1:
			_tooltipText +=  "\nDoes thing: " + ("Yes" if item.exampleBool else "No")
			_tooltipText +=  "\nThinginess: " + str(item.exampleFloat)
		Globals.ItemTypes.TYPE2:
			_tooltipText += "\nDisappointment: " + str(item.exampleInt)
		Globals.ItemTypes.TYPE3:
			pass
	_tooltipText += "\n" + item.itemTooltip
	return _tooltipText

