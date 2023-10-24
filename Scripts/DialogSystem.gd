extends Node2D

var dialog_output = []
var DialogNode

func _ready():
	DialogNode = $Dialog
	dialog_output.push_back("This is the first text output in the dialog.")
	DialogNode.bbcode_text = dialog_output[0]

func add_new_output(output : String):
	dialog_output.push_back(str(output))
	DialogNode.bbcode_text = dialog_output[-1]
