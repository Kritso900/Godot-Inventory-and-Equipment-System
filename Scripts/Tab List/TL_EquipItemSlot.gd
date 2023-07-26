### This script is used for the equipment slots in the tab list inventory
extends VBoxContainer
class_name TL_EquipItemSlot

# The item currently equipped to this slot
var equippedItem:ItemResource

# The item type allowed to be equipped to this slot
@export var slotItemType:Globals.ItemTypes 

# A reference to the tab list inventory controller
@export var inventoryControllerRef:TL_InventoryController

# The name of the item slot
@export var slotName:String

# Reference to the label showing the item slot name
@export var slotNameRef:Label

# Reference to the textureRext that will display the equipped item's image
@export var equippedItemImageRef:TextureRect

# Reference to the equip button
@onready var equipButtonRef:Button = $"Slot Background Container/Equip Button"

# Reference to the unequip button
@onready var unequipButtonRef:Button = $"Slot Background Container/Equip Button/Unequip Button"

func _ready():
	# Adds itself to the controller array of equip slots
	inventoryControllerRef.equipSlotRefArray.append(self)
	
	slotNameRef.text = slotName
	
	# Connects pressing the equip button to the inventory controller function that sets up a TL_ItemListContainer so select an item to equip
	equipButtonRef.pressed.connect(inventoryControllerRef.EquipmentSelect.bind(slotItemType, self, equippedItem))
	
	unequipButtonRef.pressed.connect(UnequipItem)
	

# Called by the TL_ItemListContainer setup when presing the this slot's equip button
func equipItem(_item:ItemResource):
	equippedItem = _item
	equippedItemImageRef.texture = equippedItem.itemUiImage
	inventoryControllerRef.PlayerStatRebuild()

func UnequipItem():
	equippedItem = null
	equippedItemImageRef.texture = null
	inventoryControllerRef.PlayerStatRebuild()
