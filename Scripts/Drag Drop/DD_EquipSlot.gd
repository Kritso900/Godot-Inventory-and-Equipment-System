### This script is used for the equipment slots in the drag drop inventory
extends VBoxContainer

class_name DD_EquipSlot

# A reference to the Drag Drop inventory controller
@onready var inventoryControllerRef:DD_InventoryController = DD_InventoryController.GetControllerRef()

# A reference to the texture rect of the slot, is set to the equipped item's icon
@onready var textureRectRef:TextureRect = $"Slot Background Container/Equiped Item Icon"

# The name of the slot
@export var slotName:String

# The item type allowed to be equipped in this slot
@export var slotItemType:Globals.ItemTypes

# The item currently equipped in this slot
var equippedItem:ItemResource

func _ready():
	$"Slot Name".text = slotName

# Called when clicked on, decideds if the player equips or unequips an item
func _on_equip_button_pressed():
	if !equippedItem and inventoryControllerRef.heldItem:
		if inventoryControllerRef.heldItem.item.itemType == slotItemType:
			EquipItem()
	elif equippedItem and !inventoryControllerRef.heldItem:
		UnequipItem()
	

# Called when the slot is clicked on while holding an item, and slot is empty
func EquipItem():
	equippedItem = inventoryControllerRef.heldItem.item
	textureRectRef.texture = equippedItem.itemUiImage
	var _tooltipText:String = equippedItem.itemName
	match equippedItem.itemType:
		Globals.ItemTypes.ARMOUR:
			_tooltipText +=  "\nDoes thing: " + ("Yes" if equippedItem.exampleBool else "No")
			_tooltipText +=  "\nThinginess: " + str(equippedItem.exampleInt)
		Globals.ItemTypes.WEAPON:
			_tooltipText += "\nDisappointment: " + str(equippedItem.exampleFloat)
		Globals.ItemTypes.CONSUMABLE:
			pass
	_tooltipText += "\n" + equippedItem.itemTooltip
	$"Slot Background Container/Equip Button".tooltip_text = _tooltipText
	inventoryControllerRef.Destroy(inventoryControllerRef.heldItem)

# Called when clicked on when not holding an item and slot is filled
func UnequipItem():
	var _item:DD_GridItem = inventoryControllerRef.currentGrid.CreateItem(equippedItem)
	inventoryControllerRef.PickUp(_item)
	equippedItem = null
	textureRectRef.texture = null
	$"Slot Background Container/Equip Button".tooltip_text = ""
	
	
