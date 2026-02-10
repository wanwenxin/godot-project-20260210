extends Area2D

@export_file("*.tscn") var next_level_path: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		_handle_level_complete()

func _handle_level_complete() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		if next_level_path != "":
			gm.change_level(next_level_path)
		else:
			gm.change_level(gm.FIRST_LEVEL_PATH)
	else:
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)

