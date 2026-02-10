extends Node2D

@export var player_scene: PackedScene

@onready var player_start: Node2D = $PlayerStart
@onready var camera: Camera2D = $MainCamera

var player: CharacterBody2D

func _ready() -> void:
	_add_sky_background()
	if player_scene == null:
		player_scene = load("res://scenes/player/Player.tscn")
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = player_start.global_position
	camera.position = player.position

func _add_sky_background() -> void:
	var layer := CanvasLayer.new()
	layer.layer = -10
	add_child(layer)
	var rect := ColorRect.new()
	rect.color = Color(0.53, 0.81, 0.92)
	var size := get_viewport().get_visible_rect().size
	rect.set_size(size)
	rect.set_position(Vector2.ZERO)
	layer.add_child(rect)

func _process(_delta: float) -> void:
	if player:
		camera.position.x = player.position.x

