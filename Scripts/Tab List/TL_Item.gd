### This script is used as a base for all items used in the tab list inventory
extends PanelContainer

class_name TL_Item

var item:ItemResource
var invControllerRef:TL_InventoryController

# Only used when created for equipping an item
var equipMode:bool = false

# Only used when created for equipping an item
# A reference to the tiem slot the item is being equipped to
var equipItemSlot:TL_EquipItemSlot

@export var imageRef:TextureRect
@export var nameRef:Label
@export var selectButtonRef:Button
@export var contextButtonRef:MenuButton

# Sets up the item's visuals and buttons using information from the given item
func Setup(_item:ItemResource, _controllerRef:TL_InventoryController):
	item = _item
	imageRef.set_texture(item.itemUiImage)
	nameRef.set_text(item.itemName)
	contextButtonRef.get_popup().set_item_disabled(1, item.isKeyItem)
	contextButtonRef.get_popup().set_item_disabled(2, item.isKeyItem)
	contextButtonRef.get_popup().set_item_disabled(0, !item.isItemUsable)
	selectButtonRef.disabled = !item.isItemUsable
	invControllerRef = _controllerRef
	contextButtonRef.get_popup().id_pressed.connect(MenuButtonPressed)

# Called when created for equipping an item
func SetupEquip(_itemSlot:TL_EquipItemSlot):
	equipMode = true
	equipItemSlot = _itemSlot
	selectButtonRef.disabled = false
	contextButtonRef.get_popup().clear()
	contextButtonRef.get_popup().add_item("Equip")
	selectButtonRef.pressed.connect(FinishEquip)

# Called when an item to equip has been selected
func FinishEquip():
	equipItemSlot.equipItem(item)
	invControllerRef.HideItemEquipSubView()

# Sets up the context menu for the item
func MenuButtonPressed(id:int):
	if equipMode:
		if id == 0: FinishEquip()
	elif id == 0:
		invControllerRef.RemoveItemFromInventory(item)
	elif id == 1:
		invControllerRef.RemoveItemFromInventory(item)
	elif id == 2:
		invControllerRef.RemoveItemFromInventory(item)
