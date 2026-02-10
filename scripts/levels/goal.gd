## 关卡终点（旗杆/门）
## 当玩家（CharacterBody2D）进入区域时，通过 GameManager 切换关卡；可配置下一关路径。

extends Area2D

# ---------- 配置 ----------
## 下一关场景路径（.tscn）；留空则使用 GameManager 的第一关（重玩/循环）
@export_file("*.tscn") var next_level_path: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

## 有物体进入区域时检查是否为玩家（CharacterBody2D），是则触发过关
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		_handle_level_complete()

## 通过 GameManager 切换关卡；无 GameManager 时直接 change_scene_to_file
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
