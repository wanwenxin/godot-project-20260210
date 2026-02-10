extends CharacterBody2D

@export var move_speed: float = 50.0
@export var gravity: float = 1200.0
@export var direction: int = 1
@export var jump_impulse: float = -250.0
@export var invincible_duration: float = 5.0

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * move_speed
	move_and_slide()
	_check_collisions()

func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var other := collision.get_collider()
		var normal := collision.get_normal()

		if other is CharacterBody2D and other.has_method("set_invincible"):
			other.set_invincible(invincible_duration)
			queue_free()
		else:
			# 碰到地面弹跳，碰到墙体反向
			if normal.y < -0.9:
				velocity.y = jump_impulse
			if abs(normal.x) > 0.9:
				direction *= -1

