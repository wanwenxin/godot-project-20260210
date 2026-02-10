## 蘑菇怪（Goomba）敌人
## 继承 base_enemy：被踩时给玩家固定反弹速度 -200，然后移除自身。

extends "res://scripts/enemies/base_enemy.gd"

func die_from_stomp(player: CharacterBody2D) -> void:
	if "velocity" in player:
		player.velocity.y = -200.0
	queue_free()
