extends CharacterBody2D

@export var velocidad = 200  # Velocidad de movimiento del personaje

# Función que se ejecuta cuando el nodo entra en la escena
func _ready():
	$Animaciones.play("miraqueguay")
	var camara = $Camera2D
	camara.make_current()
	camara.offset = Vector2.ZERO  # Asegúrate de que no haya desplazamiento


# Función para procesar la física del movimiento
func _physics_process(delta):
	var direccion = Vector2.ZERO
	
	# Detecta la entrada de las teclas W, A, S, D
	direccion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direccion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# Si hay dirección, calcula el movimiento
	if direccion != Vector2.ZERO:
		direccion = direccion.normalized()
	velocity = direccion * velocidad
	
	# Mueve al jugador
	move_and_slide()
