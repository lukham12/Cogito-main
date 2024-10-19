extends Control

@export var recipePrefab : PackedScene;
@export var ingredientPrefab : PackedScene;

@onready var mainContainer = $MainPanel/ScrollContainer/Container;
@onready var player = get_tree().get_first_node_in_group("Player");
@onready var playerData = player.inventory_data;

var recipesDirectory = DirAccess.open("res://Recipes");

func attemptCraft(recipe):
	#-> Check if the player has the required resources
	# Loop through all the ingredients and get their respective names
	var playerSlots = [];
	
	for ingredient in recipe.ingredients:
		var ingredientName = ingredient.inventory_item.name;
		var ingredientQuantity = ingredient.quantity;
		var found = false;
		
		# Loop through the players inventory inventory to see if we have the ingredient
		for slot in playerData.inventory_slots:
			# Check if the name is the same, if it is then we have the ingredient. 
			# Furthermore, check we have the required quantity of the ingredient.
			if slot.inventory_item.name == ingredientName and slot.quantity >= ingredientQuantity:
				playerSlots.append(slot); # Add the slot to an array that we can use later
				
				found = true;
				break; # We do not need to keep searching as this ingredient has already been found
		
		if not found:
			# We cannot craft the item.
			return;
	
	# Remove the ingredient from the players inventory
	var ingredientCount = 0;
	for ingredient in recipe.ingredients:
		var playerSlot = playerSlots[ingredientCount];
		
		# Check if the player will have any left after the required are removed
		var quantityNeeded = ingredient.quantity;
		var playerQuantity = playerSlot.quantity;
		
		if playerQuantity == quantityNeeded:
			# We need to completly remove the slot from the players inventory
			playerData.remove_slot_data(playerSlot);
		else:
			# Simply decrease the quantity
			playerSlot.quantity -= quantityNeeded;
		
		ingredientCount += 1;
	
	# Add the product to the players inventory
	playerData.pick_up_slot_data(recipe.product);
	
	# Update the players inventory data
	playerData.inventory_updated.emit(playerData);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#-> Display recipes
	
	# Loop through all recipes in folder
	recipesDirectory.list_dir_begin()
	for file: String in recipesDirectory.get_files():
		# Load the recipe resource
		var resource := load(recipesDirectory.get_current_dir() + "/" + file);
		
		# Create a new recipe prefab and add it to the container
		var newRecipe = recipePrefab.instantiate();
		mainContainer.add_child(newRecipe);
		
		# Add title to recipe
		newRecipe.get_node("Title").text = resource.product.inventory_item.name;
		
		# Add product iamge
		newRecipe.get_node("Product").get_node("Image").texture = resource.product.inventory_item.icon;
		
		# Loop through all ingredient
		for ingredient in resource.ingredients:
			# Create a new ingredient prefab and add it to the horizontal frame
			var newIngredient = ingredientPrefab.instantiate();
			newRecipe.get_node("Ingredients").add_child(newIngredient);
			
			# Add an image to the ingredient
			newIngredient.get_node("Image").texture = ingredient.inventory_item.icon;
			
			# Add quanity text to ingredient (if the quanity isn't 1). Quantity should be in form x[X] e.g. x1 x6 x78
			if ingredient.quantity != 1:
				newIngredient.get_node("Quantity").text = "x" + str(ingredient.quantity);
		
		# Connect to craft button
		newRecipe.get_node("Craft").get_node("Button").connect("pressed", func():
			attemptCraft(resource);
		);


func _on_button_pressed() -> void:
	# Close crafting UI
	visible = false;
	
	# Resume player movement
	player._on_resume_movement();
