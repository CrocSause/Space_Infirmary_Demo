extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false  # Also ensure we're not paused


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
