### This script holds the variables needed for items, they are loaded in as resources

extends Resource
class_name ItemResource

const  ITEM:GDScript = preload("res://Scripts/ItemResource.gd")
# The image that will be used inside the inventory
@export var itemUiImage:CompressedTexture2D

# The name that will be displayed inside the inventory
@export var itemName:String

# A short description that will be displayed for the item
@export var itemTooltip:String

# The item type of the item, can be used for requirments such as if armor is a helmet or glove
@export var itemType:Globals.ItemTypes

# Size of the item in the drag drop grid, will be ignored if not using the drag drop inventory
@export var itemDragDropGridSize:Vector2i

# An example int to make future implementation easier, could be used for value, item rarity, etc
@export var exampleInt:int

# An example float to make future implementation easier, could be used for damage, weight, etc
@export var exampleFloat:float

# An example boolean to make future implementation easier, could be used for item unlocked state, if it's a key item, etc
@export var exampleBool:bool


# All variables in the resource must have a default value or they will create problems
func _init():
	itemUiImage = preload("res://1x1 Misc Item Error.png")
	itemName = ""
	itemTooltip = ""
	itemType = Globals.ItemTypes.TYPE3
	itemDragDropGridSize = Vector2i(1,1)
	exampleInt = 0
	exampleFloat = 0
	exampleBool = false
