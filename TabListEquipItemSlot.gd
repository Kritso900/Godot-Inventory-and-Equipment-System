extends VBoxContainer
class_name TL_EquipItemSlot


var equippedItem:ItemResource
@export var slotItemType:Globals.ItemTypes 

@export var inventoryControllerRef:TL_InventoryController

@export var slotName:String
@export var slotNameRef:Label

@export var equippedItemImageRef:TextureRect

@onready var equipButtonRef:Button = $"Slot Background Container/Equip Button"
@onready var unequipButtonRef:Button = $"Slot Background Container/Equip Button/Unequip Button"

func _ready():
	inventoryControllerRef.equipSlotRefArray.append(self)
	slotNameRef.text = slotName
	equipButtonRef.pressed.connect(inventoryControllerRef.EquipmentSelect.bind(slotItemType, self, equippedItem))
	unequipButtonRef.pressed.connect(inventoryControllerRef.EquipmentUnequip.bind(self))
	

func equipItem(_item:ItemResource):
	equippedItem = _item
	equippedItemImageRef.texture = equippedItem.itemUiImage
	inventoryControllerRef.PlayerStatRebuild()

func UnequipItem():
	equippedItem = null
	equippedItemImageRef.texture = null
	inventoryControllerRef.PlayerStatRebuild()
