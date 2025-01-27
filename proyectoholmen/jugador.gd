extends CharacterBody2D

@export var velocidad: float = 200.0  # Velocidad de movimiento del personaje
@export var bullet_scene: PackedScene # Arrastra aquí tu escena de bala (Bullet.tscn) en el editor

func _ready():
	$Animaciones.play("miraqueguay")
	var camara = $Camera2D
	camara.make_current()
	camara.offset = Vector2.ZERO  # Asegúrate de que no haya desplazamiento

func _process(delta: float) -> void:
	# 1) Rotar la escopeta hacia el mouse
	var mouse_global_pos = get_global_mouse_position()
	var direction = mouse_global_pos - $Escopeta.global_position
	$Escopeta.rotation = direction.angle()

	# 2) Disparar al hacer clic
	# Primero, en "Project Settings" -> "Input Map", crea una acción "shoot"
	# y asígnale Mouse Left Button (o la tecla que prefieras).
	if Input.is_action_just_pressed("shoot"):
		disparar()

func disparar() -> void:
	if bullet_scene:
		# Instanciamos la bala
		var bullet = bullet_scene.instantiate()
		
		# Posicionamos la bala en la punta de la escopeta.
		# Si no tienes un nodo "MuzzlePoint", puedes usar la posición actual
		# de la escopeta, o ajustarla con un offset.
		bullet.global_position = $Escopeta/MuzzlePoint.global_position
		bullet.rotation = $Escopeta/MuzzlePoint.global_rotation

		
		# Añadimos la bala a la escena actual (raíz de la escena de juego)
		get_tree().get_current_scene().add_child(bullet)

func _physics_process(delta: float) -> void:
	var direccion = Vector2.ZERO
	
	# Detecta la entrada de las teclas W, A, S, D
	direccion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direccion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# Si hay dirección, la normalizamos para no superar la velocidad
	if direccion != Vector2.ZERO:
		direccion = direccion.normalized()
	velocity = direccion * velocidad
	
	# Mueve al jugador con move_and_slide()
	move_and_slide()
