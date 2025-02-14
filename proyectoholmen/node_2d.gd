extends Node

var score: int = 0
@export var enemy_scene: PackedScene
@export var spawn_position: Vector2 = Vector2(100, 100) 
@export var base_enemy_speed: float = 100.0
@export var speed_increment: float = 50.0  
@export var enemies_per_spawn: int = 1
@export var spawn_increment: int = 2      

var current_enemy_speed: float
var total_enemies_to_spawn: int = 1

func _ready() -> void:
	current_enemy_speed = base_enemy_speed
	spawn_enemies(total_enemies_to_spawn)
	$CanvasLayer/ScoreLabel.text = "Score: 0"
	print("Score initialized to 0")

func add_score(puntos: int) -> void:
	score += puntos
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)
	print("Score increased by ", puntos, " to ", score)
	
func spawn_enemies(amount: int) -> void:
	for i in range(amount):
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.global_position = spawn_position + Vector2(randf_range(-450, 400), randf_range(-150, 300))
		enemy_instance.speed = current_enemy_speed
		add_child(enemy_instance)
		print("Spawned enemy at ", enemy_instance.global_position)

func on_EnemySpawnTimer_timeout() -> void:
	# Cada xs: incrementa la cantidad de enemigos que aparecerán
	total_enemies_to_spawn += spawn_increment
	spawn_enemies(total_enemies_to_spawn)
	print("EnemySpawnTimer timeout: total_enemies_to_spawn =", total_enemies_to_spawn)

func on_EnemySpeedTimer_timeout() -> void:
	# Cada xs: aumenta la velocidad de todos los enemigos nuevos
	current_enemy_speed += speed_increment
	print("EnemySpeedTimer timeout: current_enemy_speed =", current_enemy_speed)
	
	# Aumenta la velocidad de los enemigos existentes
	for child in get_children():
		if child is Enemy:
			child.speed += speed_increment
			print("Increased speed of enemy ", child, " to ", child.speed)


func game_over() -> void:
	$CanvasLayer/GameOverLabel.text = "Game Over"
	$CanvasLayer/GameOverLabel.visible = true
	print("Game Over triggered")
	get_tree().paused = true
