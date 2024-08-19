extends CanvasLayer

func _on_resume_button_down():
	if not visible: return;
	
	# Close menu
	
	_G.closeMenu();

func _on_quit_button_down():
	# Quit the game
	
	get_tree().quit();

func _on_settings_button_down():
	# TODO: Implement settings
	pass;
