extends CharacterBody2D

@export var move_speed: float = 40.0
@export var gravity: float = 1200.0
@export var direction: int = 1

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * move_speed
	move_and_slide()
	_check_collisions()

func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var other := collision.get_collider()
		if other is CharacterBody2D and other.has_method("grow"):
			other.grow()
			queue_free()
		else:
			var normal := collision.get_normal()
			if abs(normal.x) > 0.9:
				direction *= -1

