extends InteractionComponent;
class_name craftingStation;

@onready var player = get_tree().get_first_node_in_group("Player");
@onready var crafting = player.get_node("Crafting");

func interact(_player_interaction_component: PlayerInteractionComponent):
	# Making crafting UI visible
	crafting.visible = true;
	
	# Pause player movement
	player._on_pause_movement();
