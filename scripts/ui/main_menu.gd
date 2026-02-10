extends Control

const LEVEL1_PATH := "res://scenes/levels/Level1.tscn"

func _ready() -> void:
	# 确保根不拦截点击，让按钮能收到信号（若 .tscn 里未设 mouse_filter = 2 则这里兜底）
	if mouse_filter != MOUSE_FILTER_IGNORE:
		mouse_filter = MOUSE_FILTER_IGNORE

	var start_btn: Button = get_node_or_null("VBoxContainer/StartButton")
	var quit_btn: Button = get_node_or_null("VBoxContainer/QuitButton")
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	if quit_btn:
		quit_btn.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm and gm.has_method("change_level"):
		gm.change_level(LEVEL1_PATH)
	else:
		get_tree().change_scene_to_file(LEVEL1_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()

