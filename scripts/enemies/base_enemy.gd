extends CharacterBody2D

@export var move_speed: float = 60.0
@export var gravity: float = 1200.0
@export var direction: int = -1 # -1 向左, 1 向右

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * move_speed
	move_and_slide()
	_check_collisions()

func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var other := collision.get_collider()
		if other is CharacterBody2D and other.has_method("shrink_or_die"):
			_handle_player_collision(other)

func _handle_player_collision(player: CharacterBody2D) -> void:
	# 通过玩家速度和相对位置判断是被踩还是侧面撞
	var is_stomp := false
	if "velocity" in player:
		is_stomp = player.velocity.y > 0.0 and player.global_position.y < global_position.y

	if is_stomp and has_method("die_from_stomp"):
		die_from_stomp(player)
	elif player.has_method("shrink_or_die"):
		player.shrink_or_die()

func die_from_stomp(player: CharacterBody2D) -> void:
	# 子类可以重写此方法，例如加特效或音效
	queue_free()
	if "velocity" in player:
		player.velocity.y = -abs(player.velocity.y) # 踩完以后轻微弹跳

