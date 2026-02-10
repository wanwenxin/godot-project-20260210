extends "res://scripts/enemies/base_enemy.gd"

func die_from_stomp(player: CharacterBody2D) -> void:
	if "velocity" in player:
		player.velocity.y = -200.0
	queue_free()

