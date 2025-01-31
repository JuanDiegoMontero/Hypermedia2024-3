extends CharacterBody2D

@export var velocidad: float = 200.0  # Velocidad de movimiento del personaje
@export var bullet_scene: PackedScene # Arrastra aquí tu escena de bala (Bullet.tscn) en el editor
@export var camara_posicion_fija: Vector2 = Vector2(0, 0)  # Ajusta según el tamaño de tu viewport

var camara: Camera2D

func _ready():
	
	camara = $Camera2D
	camara.make_current()
	camara.offset = Vector2.ZERO  # Asegurar que no haya desplazamiento

func _process(delta: float) -> void:
	# 1) Rotar la escopeta hacia el mouse
	var mouse_global_pos = get_global_mouse_position()
	var direction = mouse_global_pos - $Escopeta.global_position
	$Escopeta.rotation = direction.angle()

	# 2) Disparar al hacer clic
	if Input.is_action_just_pressed("shoot"):
		disparar()

func disparar() -> void:
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = $Escopeta/MuzzlePoint.global_position
		bullet.rotation = $Escopeta/MuzzlePoint.global_rotation
		get_tree().get_current_scene().add_child(bullet)

func _physics_process(delta: float) -> void:
	var direccion = Vector2.ZERO
	
	# Detecta la entrada de las teclas W, A, S, D
	direccion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direccion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	$Animaciones.play("miraqueguay")
	# Si hay dirección, la normalizamos para no superar la velocidad
	if direccion != Vector2.ZERO:
		direccion = direccion.normalized()
	velocity = direccion * velocidad
	
	# Mueve al jugador con move_and_slide()
	move_and_slide()

# Función para manejar la eliminación del jugador
func morir() -> void:
	if camara:
		# Fijar la cámara en una posición fija en la pantalla
		camara.global_position = camara_posicion_fija
		camara.make_current()
	
	# Llamar a la función de "Game Over" en el nodo principal
	var root_scene = get_tree().get_current_scene()
	if root_scene.has_method("game_over"):
		root_scene.game_over()
	
	# Eliminar al jugador
	queue_free()
