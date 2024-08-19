extends CanvasLayer

#-> Varibles

@onready var Hotbar = $Hotbar;
@onready var Inventory = $Inventory;

#-> Hotbar functions



#-> Inventory functions

func openInventory():
	if _G.paused or Inventory.visible: return;
	
	# Pause game
	
	_G.paused = true;
	
	# Enable UI
	
	Inventory.visible = true;
	
	# Release mouse
	
	_G.mouseCaptured = false;

func closeInventory():
	if !Inventory.visible: return;
	
	# Unpause game
	
	_G.paused = false;
	
	# Disable UI
	
	Inventory.visible = false;
	
	# Capture mouse
	
	_G.mouseCaptured = true;

func inventoryToggle():
	if Inventory.visible:
		closeInventory();
	else:
		openInventory();

#-> Main functions

func _process(dt):
	# Check for inventory key
	
	if Input.is_action_just_pressed("inventory"):
		inventoryToggle();

func _ready():
	# Close inventory if menu is opened
	
	_G.connect("menuSignal", func(menuOpened):
		if menuOpened:
			closeInventory();
	);
