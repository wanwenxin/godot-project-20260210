## 玩家控制器
## 负责：左右移动、跳跃、重力、与敌人/道具的交互（踩怪、受伤、变大、无敌）、死亡时通知 GameManager。

extends CharacterBody2D

# ---------- 可调参数（在编辑器中可见） ----------
@export var move_speed: float = 200.0      ## 水平移动速度（像素/秒）
@export var jump_velocity: float = -420.0 ## 起跳初速度（负值向上）
@export var gravity: float = 1200.0       ## 重力加速度（像素/秒²）

# ---------- 形态与状态 ----------
enum PlayerSize {
	SMALL, ## 小形态，被敌人侧面撞到即死亡
	BIG    ## 大形态（吃蘑菇后），被撞先变回小形态
}
var size_state: PlayerSize = PlayerSize.SMALL
var is_invincible: bool = false  ## 无敌星期间为 true，不受伤害

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# 占位图：无贴图时用纯色矩形显示玩家（红色 16x32）
	if sprite and sprite.texture == null:
		var img := Image.create(16, 32, false, Image.FORMAT_RGBA8)
		img.fill(Color(0.9, 0.2, 0.2))
		sprite.texture = ImageTexture.create_from_image(img)

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_movement()
	_handle_jump()
	move_and_slide()

## 未着地时施加重力；着地时把纵向速度清零，避免贴地滑动
func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0.0:
			velocity.y = 0.0

## 读取左右输入（ui_left / ui_right），设置水平速度
func _handle_movement() -> void:
	var input_dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = input_dir * move_speed

## 仅当着地且按下跳跃键（ui_accept，默认空格/回车）时赋予跳跃初速度
func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

## 吃蘑菇时调用：小形态变为大形态，放大 1.2 倍
func grow() -> void:
	if size_state == PlayerSize.SMALL:
		size_state = PlayerSize.BIG
		scale = Vector2(1.2, 1.2)

## 被敌人侧面/下方撞到时调用：无敌则忽略；大形态变回小形态；小形态则死亡
func shrink_or_die() -> void:
	if is_invincible:
		return
	if size_state == PlayerSize.BIG:
		size_state = PlayerSize.SMALL
		scale = Vector2.ONE
	else:
		die()

## 死亡：通知 GameManager 扣命（或 Game Over），无 GameManager 时重载当前场景
func die() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.lose_life()
	else:
		get_tree().reload_current_scene()

## 吃无敌星时调用：在 duration 秒内 is_invincible = true，到期后自动恢复
func set_invincible(duration: float) -> void:
	if duration <= 0.0:
		return
	is_invincible = true
	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(func () -> void:
		is_invincible = false)
