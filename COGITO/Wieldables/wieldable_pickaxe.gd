extends CogitoWieldable

@export_group("Pickaxe Settings")
@export var damage_area : Area3D

@export_group("Audio")
@export var swing_sound : AudioStream

@onready var player = get_tree().get_first_node_in_group("Player");
@onready var ray = player.get_node("Neck").get_node("Head").get_node("Eyes").get_node("Camera").get_node("InteractionRaycast");

var trigger_has_been_pressed : bool = false


func _ready():
	#if wieldable_mesh:
		#wieldable_mesh.hide()
	
	damage_area.body_entered.connect(_on_body_entered)
	
	print(ray);


# Primary action called by the Player Interaction Component when flashlight is wielded.
func action_primary(_passed_item_reference:InventoryItemPD, _is_released: bool):
	if _is_released:
		return
	
	# Not swinging if animation player is playing. This enforces swing rate.
	if animation_player.is_playing():
		return
	
	animation_player.play(anim_action_primary)
	audio_stream_player_3d.stream = swing_sound
	audio_stream_player_3d.play()
	
	# Check the pickaxe ray, check if the body on the ray in group "Ore".
	var object = ray.get_collider();
	
	if object.is_in_group("Ore"):
		# Increment the ores "hits"
		object.hits += 1;
		
		# Check if the ore is almost "broken"
		if object.hits >= object.maxHits:
			print("Delete!");
			# Check what kind of ore it is
			var oreType = object.oreType;
			
			# Give the player the correct quantity of ores
			
			
			# Remove the ore
			object.queue_free();


func _on_body_entered(collider):
	if collider.has_signal("damage_received"):
		collider.damage_received.emit(item_reference.wieldable_damage)
