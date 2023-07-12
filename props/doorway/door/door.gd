extends Node3D

var is_open: bool = false

func close() -> void:
	is_open = false
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3.ZERO, 0.3).set_ease(Tween.EASE_OUT)

func open_inward() -> void:
	_open_to_rotation(90)

func open_outward() -> void:
	_open_to_rotation(-90)

func open_away_from(opener_position: Vector3) -> void:
	is_open = true
	var direction: Vector3 = global_position.direction_to(opener_position)
	var forward_vector: Vector3 = Vector3.RIGHT.rotated(Vector3.UP, global_rotation.y)
	var angle: float = direction.dot(forward_vector)

	if angle > 0:
		open_inward()
	else:
		open_outward()

#	var debugger = DebugLine.new()
#	var node: MeshInstance3D = debugger.line(global_position, global_position + forward_vector, Color.RED)
#	get_tree().root.add_child(node)
#	node.global_position.y += 1
#	print(angle)

func _open_to_rotation(to_rotation: float = 90) -> void:
	is_open = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3(0, to_rotation, 0), 0.3).set_ease(Tween.EASE_OUT)


func _on_interactable_interacted(interactor: Interactor) -> void:
	if is_open:
		close()
	else:
		open_away_from(interactor.controller.global_position)
