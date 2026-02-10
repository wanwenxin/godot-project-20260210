## 第一关场景逻辑
## 负责：生成天空背景、在 PlayerStart 位置生成玩家、摄像机跟随玩家 X 轴。

extends Node2D

# ---------- 配置 ----------
@export var player_scene: PackedScene  ## 玩家场景，未指定时使用默认路径

@onready var player_start: Node2D = $PlayerStart   ## 玩家出生点
@onready var camera: Camera2D = $MainCamera      ## 主摄像机

var player: CharacterBody2D  ## 运行时生成的玩家实例

func _ready() -> void:
	# 添加全屏天空色背景（CanvasLayer 最底层）
	_add_sky_background()
	# 若未指定玩家场景则加载默认
	if player_scene == null:
		player_scene = load("res://scenes/player/Player.tscn")
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = player_start.global_position
	camera.position = player.position

## 创建一层 CanvasLayer（layer=-10）并添加铺满视口的浅蓝色 ColorRect，作为天空背景
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

## 每帧让摄像机 X 与玩家对齐，实现横向跟随
func _process(_delta: float) -> void:
	if player:
		camera.position.x = player.position.x
