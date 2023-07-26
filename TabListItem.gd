extends PanelContainer

class_name TL_Item

var item:ItemResource
var invControllerRef:TL_InventoryController
var equipMode:bool = false
var equipItemSlot:TL_EquipItemSlot
@export var imageRef:TextureRect
@export var nameRef:Label
@export var selectButtonRef:Button
@export var contextButtonRef:MenuButton


func Setup(_item:ItemResource, _controllerRef:Node):
	item = _item
	imageRef.set_texture(item.itemUiImage)
	nameRef.set_text(item.itemName)
	
	contextButtonRef.get_popup().set_item_disabled(1, item.isKeyItem)
	contextButtonRef.get_popup().set_item_disabled(2, item.isKeyItem)
	
	contextButtonRef.get_popup().set_item_disabled(0, !item.isItemUsable)
	selectButtonRef.disabled = !item.isItemUsable
	invControllerRef = _controllerRef
	contextButtonRef.get_popup().id_pressed.connect(MenuButtonPressed)

func SetupEquip(_itemSlot:TL_EquipItemSlot):
	equipMode = true
	equipItemSlot = _itemSlot
	selectButtonRef.disabled = false
	contextButtonRef.get_popup().clear()
	contextButtonRef.get_popup().add_item("Equip")
	
	selectButtonRef.pressed.connect(FinishEquip)
	
	
	
func FinishEquip():
	equipItemSlot.equipItem(item)
	invControllerRef.HideItemEquipSubView()
	
func MenuButtonPressed(id:int):
	if equipMode:
		if id == 0: FinishEquip()
	elif id == 0:
		invControllerRef.RemoveItemFromInventory(item)
	elif id == 1:
		invControllerRef.RemoveItemFromInventory(item)
	elif id == 2:
		invControllerRef.RemoveItemFromInventory(item)
