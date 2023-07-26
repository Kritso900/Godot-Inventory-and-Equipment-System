extends Control

class_name DD_GridItem

var isInitialised:bool
@export var item:ItemResource
@onready var imageRef:TextureRect = $TextureRect
var locationCell:Vector2i
var occupiedCells:Array[Vector2i]

func setup(gridCellSize:Vector2):
	if(item):
		$TextureRect.set_texture(item.itemUiImageGrid)
		$TextureRect.size = gridCellSize * Vector2(item.itemDragDropGridSize)
		$TextureRect/ItemPickupButton.tooltip_text = setupTooltip()

func _on_item_context_button_press():
	
	print("Right click")
	pass # Replace with function body.

func setupTooltip():
	var _tooltipText:String = item.itemName
	match item.itemType:
		Globals.ItemTypes.ARMOUR:
			_tooltipText +=  "\nDoes thing: " + ("Yes" if item.exampleBool else "No")
			_tooltipText +=  "\nThinginess: " + str(item.exampleInt)
		Globals.ItemTypes.WEAPON:
			_tooltipText += "\nDisappointment: " + str(item.exampleFloat)
		Globals.ItemTypes.CONSUMABLE:
			pass
	_tooltipText += "\n" + item.itemTooltip
	return _tooltipText

func _on_item_pickup_button_pressed():
	if !DD_InventoryController.heldItem:
		DD_InventoryController.PickUp(self)
		$TextureRect/ItemPickupButton/ItemContextButton.disabled = true
	else:
		DD_InventoryController.Place(self)
	$TextureRect/ItemPickupButton/ItemContextButton.disabled = false
