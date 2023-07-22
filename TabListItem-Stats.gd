extends "res://TabListItem.gd"

@export var stat1Ref:HBoxContainer
@export var stat2Ref:HBoxContainer

@onready var exampleImage:CompressedTexture2D = preload("res://Mini Error.png")

func Setup(_item):
	super(_item)
	setupStat(stat1Ref, exampleImage, _item.exampleInt)
	setupStat(stat2Ref, exampleImage, _item.exampleFloat)
	print("tried")

func setupStat(_statRef:HBoxContainer, _statTexture:CompressedTexture2D, _statValue):
	_statRef.find_child("Stat Icon").set_texture(_statTexture)
	_statRef.find_child("Stat Value").set_text(str(_statValue))
