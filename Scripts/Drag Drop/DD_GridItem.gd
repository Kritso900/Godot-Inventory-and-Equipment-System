### This script is used for the item nodes in the drag drop inventory
extends Control

class_name DD_GridItem

# Holds the item's item resource
var item:ItemResource

# Reference to the item's sprite node
@onready var imageRef:TextureRect = $TextureRect

# Holds the item's last known location on the grid
var locationCell:Vector2i

# Holds the item's last known occupied cells on the grid
var occupiedCells:Array[Vector2i]

# Called when creating the item
func setup(gridCellSize:Vector2):
	#Checks if the item has been given an item resource
	if(item):
		# Sets the item's sprite to the grid sprite of the item resource
		# Ensure the sprite's dimentions are in multiples of the grid cell size
		$TextureRect.set_texture(item.itemUiImageGrid)
		$TextureRect.size = gridCellSize * Vector2(item.itemDragDropGridSize)
		$TextureRect/ItemPickupButton.tooltip_text = setupTooltip()

# Returns the item's tooltip
func setupTooltip():
	var _tooltipText:String = item.itemName
	
	# Allows for different stats to be listed for each item type
	match item.itemType:
		Globals.ItemTypes.ARMOUR:
			_tooltipText +=  "\nDoes thing: " + ("Yes" if item.exampleBool else "No")
			_tooltipText +=  "\nThinginess: " + str(item.exampleInt)
		Globals.ItemTypes.WEAPON:
			_tooltipText += "\nDisappointment: " + str(item.exampleFloat)
		Globals.ItemTypes.CONSUMABLE:
			pass
	
	# Adds the item description to the bottom of the tool tip
	_tooltipText += "\n" + item.itemTooltip
	return _tooltipText

# Tells the inventory controller it sould be picked up or put down
func _on_item_pickup_button_pressed():
	if !DD_InventoryController.heldItem:
		DD_InventoryController.PickUp(self)
	else:
		DD_InventoryController.Place(self)
