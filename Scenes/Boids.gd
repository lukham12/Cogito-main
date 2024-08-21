extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var fishVelocity = {};

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fishies = get_children();
	
	# Loop through all fish and find total sum of positions
	var centreOfMassSum = Vector3.ZERO;
	for fish in fishies:
		centreOfMassSum += fish.global_position;
	
	# Loop through all velocities
	var sumOfVelocity = Vector3.ZERO;
	for velocity in fishVelocity:
		sumOfVelocity += velocity;
	
	# Loop through all fish and find local COM
	for fish in fishies:
		var localCentreOfMassSum = centreOfMassSum - fish.global_position;
		var localCentreOfMass = localCentreOfMassSum / (fishies.size() - 1);
		
		var netVelocity = (localCentreOfMass - fish.global_position) / 100;
		
		# Check nearby raycasts
		
		var rays = fish.get_node("Rays").get_children();
		var v2 = Vector3.ZERO;
		
		for ray in rays:
			var collider = ray.get_collider();
			
			if collider:
				# Move away from the collider
				var colliderPosition = collider.global_position;
				
				# Veer away
				netVelocity += (fish.global_position - colliderPosition);
				#target = fish.global_position - (fish.global_position - colliderPosition);
		
		# Match velocity of nearby fish
		
		if not fishVelocity[fish.get_instance_id()]:
			fishVelocity[fish.get_instance_id()] = Vector3.ZERO;
		
		var localVelocity = sumOfVelocity - fishVelocity[fish.get_instance_id()];
		var localAverageVelocity = localVelocity - (fishies.size() - 1);
		
		netVelocity += (localAverageVelocity - fishVelocity[fish.get_instance_id()]) / 8;
		
		# Move towards target
		var target = fish.global_position + netVelocity;
		
		fishVelocity[fish.get_instance_id()] = netVelocity;
		
		fish.look_at(target);
		fish.global_position = target;
