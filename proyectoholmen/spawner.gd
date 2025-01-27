extends Node2D

@export var enemy_scene: PackedScene  # Asigna aquí la escena del enemigo
@export var spawn_interval: float = 15  # Intervalo para generar enemigos
@export var speed_increase_interval: float = 30  # Cada cuánto aumenta la velocidad
var enemies = []  # Lista para rastrear enemigos

var spawn_timer = 0.0
var speed_timer = 0.0
var enemy_speed = 100

func _process(delta):
	spawn_timer += delta
	speed_timer += delta

	# Generar enemigos
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_enemy()

	# Incrementar la velocidad de los enemigos
	if speed_timer >= speed_increase_interval:
		speed_timer = 0
		enemy_speed += 20  # Aumenta la velocidad en 20

		# Actualiza la velocidad de todos los enemigos existentes
		for enemy in enemies:
			if enemy:
				enemy.speed = enemy_speed

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.speed = enemy_speed  # Asigna la velocidad actual
	add_child(enemy)

	# Ubica al enemigo en una posición aleatoria (por ejemplo, cerca de los bordes)
	enemy.position = Vector2(randf() * 1024, randf() * 768)  # Ajusta según el tamaño de tu pantalla
	enemies.append(enemy)
