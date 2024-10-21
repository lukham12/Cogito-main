extends Node3D

class_name Boid

@onready var rays = $Rays.get_children();

@export var maxVelocity: float = 1
@export var maxAcceleration: float = 1000

var velocity := Vector3.ZERO
var acceleration := Vector3.ZERO

var neighbors := []
var neighborsDistances := []
var timeOutOfBorders := 0.0

func _ready():
	velocity = Vector3(
		randf_range(-maxVelocity, maxVelocity),
		randf_range(-maxVelocity, maxVelocity),
		randf_range(-maxVelocity, maxVelocity)
	);

func _process(dt):
	velocity = lerp(velocity, velocity + acceleration.limit_length(maxAcceleration * dt), dt);
	
	# Advoid obstacles
	var avgNormal = Vector3.ZERO;
	var normals = 0;
	
	for ray in rays:
		var collisionNormal = ray.get_collision_normal();
		
		if collisionNormal:
			#Steer away from collision point
			normals += 1;
			avgNormal += collisionNormal;
	
	if normals > 0:
		# Steer away from object
		avgNormal /= normals;
		
		# Take dot product to find similarity between velocity 
		# and negative normal, muiltiply by factor
		var factor = -avgNormal.dot(velocity);
		velocity += avgNormal * factor * 5 * dt;
	
	#Don't point "staright up"
	var upProduct = Vector3(0, 1, 0).dot(velocity);
	if (upProduct > .5) and normals == 0:
		velocity -= Vector3(0, upProduct * dt, 0);
	
	# Limit velocity
	velocity = velocity.limit_length(maxVelocity)
	acceleration = Vector3.ZERO;
	
	position += velocity * dt;
	
	look_at(position + velocity)
