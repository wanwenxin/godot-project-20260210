## 游戏管理器（单例 Autoload）
## 负责：关卡切换、生命/金币/分数、HUD 加载、死亡与 Game Over 逻辑。
## 注意：通过项目 Autoload 使用，不要使用 class_name 避免与同名 Autoload 冲突。

extends Node

# ---------- 常量 ----------
## 第一关场景路径，用于主菜单「开始游戏」和 Game Over 后重开
const FIRST_LEVEL_PATH := "res://scenes/levels/Level1.tscn"
## HUD 场景路径，启动时延迟挂到根节点下
const HUD_SCENE_PATH := "res://scenes/ui/HUD.tscn"

# ---------- 状态 ----------
## 当前关卡场景路径，用于死亡后重开本关
var current_level_path: String = FIRST_LEVEL_PATH
## 剩余生命数
var lives: int = 3
## 金币数（与分数可分开扩展）
var coins: int = 0
## 当前得分
var score: int = 0
## HUD 实例引用，避免重复创建
var hud_instance: CanvasLayer

# ---------- 信号（供 HUD 等订阅） ----------
signal level_changed(new_level_path: String)
signal lives_changed(lives: int)
signal coins_changed(coins: int)
signal score_changed(score: int)

func _ready() -> void:
	# 编辑器内不执行
	if Engine.is_editor_hint():
		return
	# 延迟添加 HUD，避免在场景树构建时 add_child 报错
	_ensure_hud()
	# 若没有当前场景（异常情况），则加载第一关
	if get_tree().current_scene == null:
		change_level(FIRST_LEVEL_PATH)

## 确保根节点下存在 HUD；若已存在则跳过。使用 call_deferred 添加避免 "Parent node is busy"。
func _ensure_hud() -> void:
	if hud_instance and is_instance_valid(hud_instance):
		return
	var hud_scene := load(HUD_SCENE_PATH)
	if hud_scene:
		hud_instance = hud_scene.instantiate()
		get_tree().root.add_child.call_deferred(hud_instance)

## 切换到指定关卡场景；更新 current_level_path 并发出 level_changed。
func change_level(level_path: String) -> void:
	current_level_path = level_path
	var error := get_tree().change_scene_to_file(level_path)
	if error != OK:
		push_error("Failed to change level to %s, error code: %s" % [level_path, str(error)])
		return
	emit_signal("level_changed", level_path)

## 增加金币并同步增加分数（每币 100 分），发出对应信号。
func add_coin(amount: int = 1) -> void:
	coins += amount
	score += amount * 100
	emit_signal("coins_changed", coins)
	emit_signal("score_changed", score)

## 增加分数并发出 score_changed。
func add_score(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)

## 扣一条命；若生命归零则 Game Over，否则重开当前关。
func lose_life() -> void:
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		_game_over()
	else:
		_reload_current_level()

## 重新加载当前关卡（死亡后复活）
func _reload_current_level() -> void:
	change_level(current_level_path)

## Game Over：重置生命/金币/分数并回到第一关
func _game_over() -> void:
	lives = 3
	coins = 0
	score = 0
	emit_signal("lives_changed", lives)
	emit_signal("coins_changed", coins)
	emit_signal("score_changed", score)
	change_level(FIRST_LEVEL_PATH)
