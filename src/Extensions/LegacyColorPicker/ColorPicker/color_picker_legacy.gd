extends PanelContainer

var tools_autoload: Node
@onready var left_color_picker_button: ColorPickerButton = %LeftColorPickerButton
@onready var right_color_picker_button: ColorPickerButton = %RightColorPickerButton
@onready var average_color: ColorRect = %AverageColor

func _ready() -> void:
	## NOTE: use get_node_or_null("/root/ExtensionsApi") to access api.
	tools_autoload = get_node_or_null("/root/Tools")
	tools_autoload.color_changed.connect(update_ui)


func update_ui(color_info, button: int):
	var tool_color: Dictionary

	if typeof(color_info) == TYPE_COLOR:  # Pixelorama 1.0.5 and below
		tool_color["color"] = color_info

	match button:
		MOUSE_BUTTON_LEFT:
			left_color_picker_button.color = tool_color.get("color", Color.WHITE)
		MOUSE_BUTTON_RIGHT:
			right_color_picker_button.color = tool_color.get("color", Color.BLACK)
	_average()


func _average() -> void:
	var average := (left_color_picker_button.color + right_color_picker_button.color) / 2.0
	var copy_button := average_color.get_parent() as Control
	copy_button.tooltip_text = str(tr("Average Color:"), "\n#", average.to_html(), "\n(Click to copy)")
	average_color.color = average


func _on_left_color_picker_button_color_changed(color: Color) -> void:
	tools_autoload.assign_color(color, MOUSE_BUTTON_LEFT)


func _on_right_color_picker_button_color_changed(color: Color) -> void:
	tools_autoload.assign_color(color, MOUSE_BUTTON_RIGHT)


func _on_to_right_pressed() -> void:
	tools_autoload.assign_color(average_color.color, MOUSE_BUTTON_RIGHT)


func _on_to_left_pressed() -> void:
	tools_autoload.assign_color(average_color.color, MOUSE_BUTTON_LEFT)


func _on_copy_average_pressed() -> void:
	DisplayServer.clipboard_set(average_color.color.to_html())


func _on_color_switch_pressed() -> void:
	tools_autoload.swap_color()


func _on_color_defaults_pressed() -> void:
	tools_autoload.default_color()
