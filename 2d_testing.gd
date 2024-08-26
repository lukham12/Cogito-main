extends Node2D

@export var num := 100
@export var margin := 100
var screensize : Vector2
var boid = load("res://Textures/boid.tscn");

func _ready() -> void:
	screensize = get_viewport_rect().size
	randomize()
	for i in num:
		spawnBoid()


func spawnBoid() -> void:
	var boid : Area2D = boid.instantiate();
	
	$boidFolder.add_child(boid)
	boid.modulate = Color(randf(), randf(), randf(), 1)
	boid.global_position = Vector2( (randf_range(margin, screensize.x - margin)), (randf_range(margin, screensize.y - margin)) )

func _on_timer_timeout() -> void:
	var c := $boidFolder.get_child_count() 
	if c < num:
		print("too few fish :(")
		for i in floor(num - c):
			spawnBoid()
