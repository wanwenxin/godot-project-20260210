## 变大蘑菇道具
## 水平移动 + 重力，碰到带 grow() 的 CharacterBody2D 时调用其 grow() 并自身消失；
## 碰到墙体（法线主要为水平）时反向移动。

extends CharacterBody2D

@export var move_speed: float = 40.0
@export var gravity: float = 1200.0
@export var direction: int = 1  ## 初始方向 1 向右

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * move_speed
	move_and_slide()
	_check_collisions()

## 碰撞处理：与玩家（有 grow）则触发 grow 并 queue_free；与墙则 direction 取反
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
