extends "res://TabListItem.gd"

@export var textRef:Label

func Setup(_item, _controllerRef):
	super(_item, _controllerRef)
	textRef.set_text(item.itemTooltip)
