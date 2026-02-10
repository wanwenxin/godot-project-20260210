## 敌人基类（横版巡逻 + 与玩家碰撞判定）
## 子类需实现 die_from_stomp(player) 以处理被踩死逻辑。
## 使用 CharacterBody2D：重力、水平匀速、move_and_slide 后根据碰撞判断踩/撞。

extends CharacterBody2D

# ---------- 可调参数 ----------
@export var move_speed: float = 60.0   ## 水平移动速度
@export var gravity: float = 1200.0   ## 重力
@export var direction: int = -1       ## -1 向左，1 向右

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * move_speed
	move_and_slide()
	_check_collisions()

## 遍历本帧碰撞：若与带 shrink_or_die 的 CharacterBody2D 相撞，则判断是踩还是侧撞
func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var other := collision.get_collider()
		if other is CharacterBody2D and other.has_method("shrink_or_die"):
			_handle_player_collision(other)

## 根据玩家纵向速度与相对位置判断：玩家从上往下且在自己上方视为踩；否则视为侧撞，调用玩家 shrink_or_die
func _handle_player_collision(player: CharacterBody2D) -> void:
	var is_stomp := false
	if "velocity" in player:
		is_stomp = player.velocity.y > 0.0 and player.global_position.y < global_position.y

	if is_stomp and has_method("die_from_stomp"):
		die_from_stomp(player)
	elif player.has_method("shrink_or_die"):
		player.shrink_or_die()

## 被踩时的默认行为：移除自身，并给玩家一个向上的反弹速度。子类可重写以加特效/音效
func die_from_stomp(player: CharacterBody2D) -> void:
	queue_free()
	if "velocity" in player:
		player.velocity.y = -abs(player.velocity.y)
