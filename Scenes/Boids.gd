extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var fishVelocity = [];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fishies = get_children();
	
	# Loop through all fish and find total sum of positions
	var centreOfMassSum = Vector3.ZERO;
	for fish in fishies:
		centreOfMassSum += fish.global_position;
	
	# Loop through all fish and find local COM
	for fish in fishies:
		var localCentreOfMassSum = centreOfMassSum - fish.global_position;
		var localCentreOfMass = localCentreOfMassSum / (fishies.size() - 1);
		
		var movement = (localCentreOfMass - fish.global_position) / 100;
		var target = fish.global_position + movement;
		
		# Check nearby raycasts
		
		var rays = fish.get_node("Rays").get_children();
		
		for ray in rays:
			var collider = ray.get_collider();
			
			if collider:
				# Move away from the collider
				var colliderPosition = collider.global_position;
				
				# Veer away
				#target = fish.global_position - (fish.global_position - colliderPosition);
		
		# Move towards target
		
		fish.look_at(target);
		fish.global_position = target;
