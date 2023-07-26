extends VBoxContainer

class_name DD_EquipSlot

@onready var inventoryControllerRef:DD_InventoryController = DD_InventoryController.GetControllerRef()
@onready var textureRectRef:TextureRect = $"Slot Background Container/Equiped Item Icon"

@export var slotName:String
@export var slotItemType:Globals.ItemTypes
var equippedItem:ItemResource

func _ready():
	$"Slot Name".text = slotName

func _on_equip_button_pressed():
	if !equippedItem and inventoryControllerRef.heldItem:
		if inventoryControllerRef.heldItem.item.itemType == slotItemType:
			EquipItem()
	elif equippedItem and !inventoryControllerRef.heldItem:
		UnequipItem()
	

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
	
func UnequipItem():
	var _item:DD_GridItem = inventoryControllerRef.currentGrid.CreateItem(equippedItem)
	inventoryControllerRef.PickUp(_item)
	equippedItem = null
	textureRectRef.texture = null
	$"Slot Background Container/Equip Button".tooltip_text = ""
	
	
