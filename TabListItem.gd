extends PanelContainer

var item:ItemResource
@export var imageRef:TextureRect
@export var nameRef:Label
@export var selectButtonRef:Button
@export var contextButtonRef:MenuButton


func Setup(_item):
	item = _item
	imageRef.set_texture(item.itemUiImage)
	nameRef.set_text(item.itemName)
	
	contextButtonRef.get_popup().set_item_disabled(1, item.isKeyItem)
	contextButtonRef.get_popup().set_item_disabled(2, item.isKeyItem)
	
	contextButtonRef.get_popup().set_item_disabled(0, !item.isItemUsable)
	selectButtonRef.disabled = !item.isItemUsable
