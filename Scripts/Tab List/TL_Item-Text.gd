### This script inherits from TL_Item, it is used in all cases where TL_Item-Stats isn't
extends "res://Scripts/Tab List/TL_Item.gd"

@export var textRef:Label

# Runs setup from it's inherited script then sets up the description box
func Setup(_item, _controllerRef):
	super(_item, _controllerRef)
	textRef.set_text(item.itemTooltip)
