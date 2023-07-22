extends "res://TabListItem.gd"

@export var textRef:Label

func Setup(_item):
	super(_item)
	textRef.set_text(item.itemTooltip)
