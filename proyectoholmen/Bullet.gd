extends Area2D
class_name Bullet

@export var speed: float = 500.0
@export var damage: int = 1  # Por si quieres manejar daños

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Mover la bala hacia la derecha local, tomando en cuenta su rotación
	# Vector2.RIGHT es (1,0). Al rotar la bala, RIGHT gira con ella.
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		print("Bullet hit an Enemy")
		
		# Obtener referencia al nodo Main
		var main = get_tree().get_current_scene()
		if main and main.has_method("add_score"):
			main.add_score(1)
		else:
			print("Main does not have add_score method or not found")
		
		# Eliminar al enemigo y a la bala
		body.queue_free()  # Elimina al enemigo
		queue_free()       # Destruye también la bala
