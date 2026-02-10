extends Node

## 通过项目 Autoload 使用，不要使用 class_name 避免与同名 Autoload 冲突。

const FIRST_LEVEL_PATH := "res://scenes/levels/Level1.tscn"
const HUD_SCENE_PATH := "res://scenes/ui/HUD.tscn"

var current_level_path: String = FIRST_LEVEL_PATH
var lives: int = 3
var coins: int = 0
var score: int = 0

var hud_instance: CanvasLayer

signal level_changed(new_level_path: String)
signal lives_changed(lives: int)
signal coins_changed(coins: int)
signal score_changed(score: int)

func _ready() -> void:
	# 确保在启动时加载 HUD 和第一关
	if Engine.is_editor_hint():
		return
	_ensure_hud()
	if get_tree().current_scene == null:
		change_level(FIRST_LEVEL_PATH)

func _ensure_hud() -> void:
	if hud_instance and is_instance_valid(hud_instance):
		return
	var hud_scene := load(HUD_SCENE_PATH)
	if hud_scene:
		hud_instance = hud_scene.instantiate()
		get_tree().root.add_child.call_deferred(hud_instance)

func change_level(level_path: String) -> void:
	current_level_path = level_path
	var error := get_tree().change_scene_to_file(level_path)
	if error != OK:
		push_error("Failed to change level to %s, error code: %s" % [level_path, str(error)])
		return
	emit_signal("level_changed", level_path)

func add_coin(amount: int = 1) -> void:
	coins += amount
	score += amount * 100
	emit_signal("coins_changed", coins)
	emit_signal("score_changed", score)

func add_score(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)

func lose_life() -> void:
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		_game_over()
	else:
		_reload_current_level()

func _reload_current_level() -> void:
	change_level(current_level_path)

func _game_over() -> void:
	# 简单实现：重置生命和分数并回到第一关
	lives = 3
	coins = 0
	score = 0
	emit_signal("lives_changed", lives)
	emit_signal("coins_changed", coins)
	emit_signal("score_changed", score)
	change_level(FIRST_LEVEL_PATH)
