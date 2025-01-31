extends CharacterBody2D
class_name Enemy

@export var speed: float = 100.0  # Velocidad base. Se puede incrementar con el tiempo.

var player: Node = null  # Referencia al jugador.

func _ready() -> void:
	var root_scene = get_tree().get_current_scene()
	player = root_scene.get_node("Jugador")
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Verificar si el enemigo ha tocado al jugador
		if global_position.distance_to(player.global_position) < 20:  # Ajusta si es necesario
			player.morir()  # Llamar a la función que maneja la muerte del jugador
