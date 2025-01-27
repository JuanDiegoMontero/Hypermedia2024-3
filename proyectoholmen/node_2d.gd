extends Node

@export var enemy_scene: PackedScene
@export var spawn_position: Vector2 = Vector2(100, 100) # Donde aparecerán nuevos enemigos
@export var base_enemy_speed: float = 100.0
@export var speed_increment: float = 50.0  # Cuánto aumenta cada 30s
@export var enemies_per_spawn: int = 1
@export var spawn_increment: int = 2      # Cuántos enemigos extra se suman cada 15s

var current_enemy_speed: float
var total_enemies_to_spawn: int = 1


func _ready() -> void:
	current_enemy_speed = base_enemy_speed

	# Empezamos creando uno (o varios) enemigos iniciales, si quieres
	spawn_enemies(total_enemies_to_spawn)

	# Timers deben estar en la escena con Autostart = true
	# EnemySpawnTimer → se conecta en el editor a on_EnemySpawnTimer_timeout
	# EnemySpeedTimer → se conecta en el editor a on_EnemySpeedTimer_timeout

func spawn_enemies(amount: int) -> void:
	for i in range(amount):
		var enemy_instance = enemy_scene.instantiate()
		# Ajusta la posición de spawn. Por ejemplo, un punto fijo o un random:
		enemy_instance.global_position = spawn_position + Vector2(randf_range(-580, 450), randf_range(-250, 390))
		
		# Ajustamos la velocidad del enemigo con la variable global
		# (Si tu script de enemigo usa `@export var speed`, hacemos:)
		enemy_instance.speed = current_enemy_speed

		add_child(enemy_instance)

func on_EnemySpawnTimer_timeout() -> void:
	# Cada 15s: incrementa la cantidad de enemigos que aparecerán
	total_enemies_to_spawn += spawn_increment
	spawn_enemies(total_enemies_to_spawn)

func on_EnemySpeedTimer_timeout() -> void:
	# Cada 30s: aumenta la velocidad de todos los enemigos nuevos
	current_enemy_speed += speed_increment
	
	# Si deseas que los enemigos existentes también aumenten su velocidad:
	for child in get_children():
		if child is Enemy:  # Ajusta al nombre de tu script/clase
			child.speed += speed_increment
