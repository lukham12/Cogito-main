extends CanvasLayer

# -> Varibles

@onready var healthBar = $MainControl/HealthBar;
@onready var oxygenBar = $MainControl/OxygenBar;

# -> Functions

# Health

func updateHealth(newHealth):
	healthBar.value = newHealth;

func updateMaxHealth(newMaxHealth):
	healthBar.max_value = newMaxHealth;

# Oxygen

func updateOxygen(newOxygen):
	oxygenBar.value = newOxygen;

func updateMaxOxygen(newMaxOxygen):
	oxygenBar.max_value = newMaxOxygen;

# -> Main Functions

func _ready():
	# Health connections
	
	_G.connect("healthUpdateSignal", updateHealth);
	_G.connect("maxHealthUpdateSignal", updateMaxHealth);
	
	# Oxygen connections
	
	_G.connect("oxygenUpdateSignal", updateOxygen);
	_G.connect("maxOxygenUpdateSignal", updateMaxOxygen);
	
	# Inital firing
	
	updateHealth(_G.health);
	updateMaxHealth(_G.maxHealth);
	
	updateOxygen(_G.oxygen);
	updateMaxOxygen(_G.maxOxygen);
