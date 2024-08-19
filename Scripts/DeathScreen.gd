extends CanvasLayer

func die():
	visible = true;

func _ready():
	# On signal, die.
	
	_G.connect("deathSignal", die);
