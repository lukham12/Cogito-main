extends Node

# Player control varibles

var speed = 5;
var jumpVelocity = 10;

# General functions

func findFirstFreeIndex(array):
	var _lowestIndex;
	
	print(len(array));

# Oxygen

var oxygenDecreasingRate = 1;
var oxygenIncreasingRate = 1;

signal oxygenUpdateSignal;
signal maxOxygenUpdateSignal;

var maxOxygen = 10:
	set(newValue) :
		maxOxygen = max(0, newValue);
		
		maxOxygenUpdateSignal.emit(maxOxygen)

var oxygen = 10 : 
	set(newValue):
		oxygen = clamp(newValue, 0, maxOxygen);
		
		oxygenUpdateSignal.emit(oxygen);

# Death

signal deathSignal;
var dead = false;

func die():
	if dead: return;
	
	# Set mouse
	
	forceMouseMode(false);
	
	# Set dead
	
	dead = true;
	
	# Pause game
	
	paused = true;
	
	# Send death signal
	
	deathSignal.emit();

# Health

signal healthUpdateSignal;
signal maxHealthUpdateSignal;

var maxHealth = 100:
	set(newValue) :
		maxHealth = max(0, newValue);
		
		maxHealthUpdateSignal.emit(maxHealth)

var health = 100 : 
	set(newValue):
		health = clamp(newValue, 0, maxHealth);
		
		healthUpdateSignal.emit(health);
		
		if health == 0:
			die();

# Game paused

var pauseCounter = 0;
var paused = false :
	set(newPauseValue):
		if newPauseValue:
			pauseCounter += 1;
		else:
			pauseCounter -= 1;
		
		paused = (pauseCounter != 0);

# Menu

signal menuSignal;

@onready var Menu = get_tree().current_scene.find_child("Menu");

func openMenu():
	if Menu.visible || dead:
		return;
	
	paused = true;
	
	Menu.visible = true;
	
	menuSignal.emit(true);

func closeMenu():
	if !Menu.visible:
		return;
	
	paused = false;
	
	Menu.visible = false;
	
	menuSignal.emit(false);

# Mouse captured

var mouseLocked = false;
var captureCounter = 0;
var mouseCaptured = false :
	set(newValue):
		if not mouseLocked:
			if newValue:
				captureCounter += 1;
			else:
				captureCounter -= 1;
		
		mouseCaptured = (captureCounter != 0);
		
		if mouseCaptured:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func forceMouseMode(newValue):
	mouseLocked = true;
	
	if newValue:
		captureCounter = 1;
		
		mouseCaptured = true;
	else:
		captureCounter = 0;
		
		mouseCaptured = false;

# Inventory

var Inventory3 = [];
var Hotbar = [];

func addItemToInventory(item):
	if Inventory3.length() > 100:
		print("WARNING: Inventory full, cannot add items. Item will be disguarded.")
		
		pass;
	
	Inventory3.append(item);

func addItemToHotbar(_hotbarItem):
	if Hotbar.length() > 10:
		print("WARNING: Hotbar full, cannot add items. Item will be disguarded.")
		
		pass;
	
	# Find first free slot
	
	var _highestIndex = 0;
	
	#for 

# Items

func getItem(itemName):
	if Hotbar.length():
		addItemToHotbar(itemName);
	else:
		addItemToInventory(itemName);

# Game loop

func _process(dt):
	if paused: return;
	
	# Oxygen
	
	if oxygen == 0:
		# Do damage to the player
		
		health -= dt * 10;

# Ready func

func _ready():
	connect("deathSignal", closeMenu);
