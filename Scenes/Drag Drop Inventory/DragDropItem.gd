extends Control

var isInitialised:bool
@export var item:ItemResource
@onready var imageRef:TextureRect = $TextureRect
var locationCell:Vector2i
var occupiedCells:Array[Vector2i]

func setup(gridCellSize:Vector2):
	if(item):
		$TextureRect.set_texture(item.itemUiImage)
		$TextureRect.size = gridCellSize * Vector2(item.itemDragDropGridSize)
		$TextureRect/ItemPickupButton.tooltip_text = setupTooltip()

func _on_item_context_button_press():
	
	print("Right click")
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

func _on_item_pickup_button_pressed():
	if !DragDropController.heldItem:
		DragDropController.PickUp(self)
		$TextureRect/ItemPickupButton/ItemContextButton.disabled = true
	else:
		DragDropController.Place(self)
	$TextureRect/ItemPickupButton/ItemContextButton.disabled = false
