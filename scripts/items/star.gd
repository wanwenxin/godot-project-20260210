## 无敌星道具
## 水平移动 + 重力；碰到地面（法线向上）时赋予 jump_impulse 弹跳，碰到墙则反向；
## 碰到带 set_invincible 的玩家时调用 set_invincible(invincible_duration) 并自身消失。

extends CharacterBody2D

@export var move_speed: float = 50.0
@export var gravity: float = 1200.0
@export var direction: int = 1
@export var jump_impulse: float = -250.0       ## 着地时的向上弹跳速度
@export var invincible_duration: float = 5.0  ## 给予玩家的无敌时长（秒）

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * move_speed
	move_and_slide()
	_check_collisions()

## 碰撞：玩家则给无敌并消失；地面则弹起，墙体则反向
func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var other := collision.get_collider()
		var normal := collision.get_normal()

		if other is CharacterBody2D and other.has_method("set_invincible"):
			other.set_invincible(invincible_duration)
			queue_free()
		else:
			if normal.y < -0.9:
				velocity.y = jump_impulse
			if abs(normal.x) > 0.9:
				direction *= -1
