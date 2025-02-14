extends Area2D
class_name Bullet

@export var speed: float = 500.0
@export var damage: int = 1  

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		var main = get_tree().get_current_scene()
		if main and main.has_method("add_score"):
			main.add_score(1)
		else:
			print("Main does not have add_score method or not found")
		body.queue_free()  
		queue_free()       
