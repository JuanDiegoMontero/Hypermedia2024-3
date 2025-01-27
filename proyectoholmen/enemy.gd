extends CharacterBody2D
class_name Enemy
@export var speed: float = 100.0  # Velocidad base. Se puede incrementar con el tiempo.

var player: Node = null  # Referencia al jugador.


func _ready() -> void:
	# Podemos buscar al jugador si está en la misma escena principal
	# Ajusta la ruta según la estructura de tus nodos.
	var root_scene = get_tree().get_current_scene()
	player = root_scene.get_node("Jugador")

	# Iniciar la animación si usas AnimatedSprite2D
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play()

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
