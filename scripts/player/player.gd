extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_velocity: float = -420.0
@export var gravity: float = 1200.0

enum PlayerSize {
	SMALL,
	BIG
}

var size_state: PlayerSize = PlayerSize.SMALL
var is_invincible: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# 占位图：无贴图时用纯色矩形显示玩家
	if sprite and sprite.texture == null:
		var img := Image.create(16, 32, false, Image.FORMAT_RGBA8)
		img.fill(Color(0.9, 0.2, 0.2))
		sprite.texture = ImageTexture.create_from_image(img)

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_movement()
	_handle_jump()
	move_and_slide()

func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0.0:
			velocity.y = 0.0

func _handle_movement() -> void:
	var input_dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = input_dir * move_speed

func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

func grow() -> void:
	if size_state == PlayerSize.SMALL:
		size_state = PlayerSize.BIG
		scale = Vector2(1.2, 1.2)

func shrink_or_die() -> void:
	if is_invincible:
		return
	if size_state == PlayerSize.BIG:
		size_state = PlayerSize.SMALL
		scale = Vector2.ONE
	else:
		die()

func die() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.lose_life()
	else:
		get_tree().reload_current_scene()

func set_invincible(duration: float) -> void:
	if duration <= 0.0:
		return
	is_invincible = true
	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(func () -> void:
		is_invincible = false)

