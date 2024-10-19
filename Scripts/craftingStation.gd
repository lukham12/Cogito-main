extends Node3D

@export var scene : PackedScene;

func _on_basic_interaction_was_interacted_with(interaction_text: Variant, input_map_action: Variant) -> void:
	# Open crafting UI
	get_tree().change_scene_to_packed(scene);


func _on_interaction_component_was_interacted_with(interaction_text: Variant, input_map_action: Variant) -> void:
	# Open crafting UI
	get_tree().change_scene_to_packed(scene);
