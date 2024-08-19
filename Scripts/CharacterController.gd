extends CharacterBody3D

var SPEED = _G.speed;
var JUMP_VELOCITY = _G.jumpVelocity;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") / 5;

@onready var head := $Head;
@onready var camera := $Head/Camera;
@onready var ray := $Head/RayCast3D;
@onready var itemLabel = $Pickup/Control/ItemLabel;

#-> Mouse Movement

func _unhandled_input(event):
	# Mouse locking
	
	if event is InputEventMouseButton and _G.mouseCaptured != true and !_G.paused:
		_G.mouseCaptured = true;
		
		_G.closeMenu();
	elif event.is_action_pressed("ui_cancel"):
		if _G.Menu.visible:
			# Close menu
			
			_G.mouseCaptured = true;
			
			_G.closeMenu();
		else:
			# Open menu
			
			_G.mouseCaptured = false;
			
			_G.openMenu();
	
	if _G.paused: return;
	
	# Camera rotation
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.01);
		
		head.rotate_x(-event.relative.y * 0.01);
		
		head.rotation.x = clamp(head.rotation.x, -1, 1);

#-> Player movement

func _physics_process(delta):
	if _G.paused: return;
	
	# Sink and Float
	if Input.is_action_pressed("Sink"):
		velocity.y = move_toward(velocity.y, -gravity, delta);
	elif Input.is_action_pressed("Float"):
		velocity.y = move_toward(velocity.y, gravity, delta);
	else:
		velocity.y = move_toward(velocity.y, 0, delta);
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(direction.x, SPEED, delta)
		velocity.z = move_toward(direction.z, SPEED, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, delta)
		velocity.z = move_toward(velocity.z, 0, delta)
	
	move_and_slide()

#-> Oxygen decreasing

func _process(dt):
	if _G.paused: return;
	
	# Picking up items
	
	var collider = ray.get_collider();
	
	if collider and collider.is_in_group("Item"):
		# Display picking up text
		
		itemLabel.visible = true;
		
		# Position item label
		
		itemLabel.position = camera.unproject_position(
			collider.global_position
		);
		
		# Set item label name
		
		itemLabel.text = "F: " + collider.name;
		
		if Input.is_action_pressed("Pickup"):
			_G.giveItem(collider.name);
			
			collider.get_parent().queue_free();
	else:
		# Remove picking up text
		
		itemLabel.visible = false;
	
	# Oxygen decreasing
	
	var underwater = true; #TODO: Check if we are underwater or not.
	
	if underwater:
		_G.oxygen -= dt * _G.oxygenDecreasingRate;
	else:
		_G.oxygen += dt * _G.oxygenIncreasingRate;
