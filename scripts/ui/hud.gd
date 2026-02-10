extends CanvasLayer

var lives_label: Label
var coins_label: Label
var score_label: Label
var pause_menu: Control
var resume_button: Button
var main_menu_button: Button

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# 用路径取节点，避免 % 在延迟添加时为 null
	lives_label = get_node_or_null("TopBar/LivesLabel")
	coins_label = get_node_or_null("TopBar/CoinsLabel")
	score_label = get_node_or_null("TopBar/ScoreLabel")
	pause_menu = get_node_or_null("PauseMenu")
	resume_button = get_node_or_null("PauseMenu/VBoxContainer/ResumeButton")
	main_menu_button = get_node_or_null("PauseMenu/VBoxContainer/MainMenuButton")

	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu_pressed)

	# 连接 GameManager 信号（Autoload 节点）
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.lives_changed.connect(_on_lives_changed)
		gm.coins_changed.connect(_on_coins_changed)
		gm.score_changed.connect(_on_score_changed)
		_on_lives_changed(gm.lives)
		_on_coins_changed(gm.coins)
		_on_score_changed(gm.score)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	var tree := get_tree()
	tree.paused = not tree.paused
	if pause_menu:
		pause_menu.visible = tree.paused

func _on_resume_pressed() -> void:
	get_tree().paused = false
	if pause_menu:
		pause_menu.visible = false

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func _on_lives_changed(value: int) -> void:
	if lives_label:
		lives_label.text = "Lives: %d" % value

func _on_coins_changed(value: int) -> void:
	if coins_label:
		coins_label.text = "Coins: %d" % value

func _on_score_changed(value: int) -> void:
	if score_label:
		score_label.text = "Score: %d" % value
