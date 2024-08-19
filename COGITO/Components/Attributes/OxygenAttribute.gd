extends CogitoAttribute;
class_name CogitoOxygeAttribute;

@export var suffocate = true;
@export var decreaseRate = 10;
@export var suffocationRate = 1;

@onready var healthAttribute = get_parent().find_child("HealthAttribute");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_current = value_start
	#attribute_reached_zero.connect(suffocate)
	attribute_changed.connect(on_oxygen_changed)
	attribute_changed.emit(attribute_name,value_current,value_max,true)

func on_oxygen_changed(_name, _newValue, _maxValue, _boolean):
	pass;

func _process(dt):
	if suffocate:
		subtract(dt * decreaseRate)
	
	if value_current == 0:
		healthAttribute.subtract(dt * suffocationRate);
