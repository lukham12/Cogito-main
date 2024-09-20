extends Node3D

# REDUCE ALL VALUES
@export var visualRange: float = 2
@export var separationDistance: float = 0.4;
@export var predatorMinDist: float = 1
@onready var boids = get_children();
@onready var predators = get_tree().get_first_node_in_group("Predators").get_children();

@export var cohesionWeight: float = 0.5
@export var separationWeight: float = 50
@export var alignmentWeight: float = .5

@export var obstacleWeight: float = 300
@export var predatorWeight: float = 500
@export var maxPlayerDistance: float = 10;

var playerRef;

func _ready():
	playerRef = get_tree().get_nodes_in_group("Player")[0];

func _process(_delta: float) -> void:
	detectNeighbors();
	
	cohesion();
	seperation();
	alignment();
	ceiling();
	
	escapePredator();

func escapePredator():
	for boid in boids:
		for predator in predators:
			var dist = boid.get_position().distance_to(predator.get_position());
			
			if dist < predatorMinDist:
				var dir = (boid.get_position() - predator.get_position()).normalized();
				var multiplier = sqrt(1 - (dist / predatorMinDist));
				
				boid.acceleration += dir * multiplier * predatorWeight;
			else:
				var playerDist = boid.get_position().distance_to(playerRef.get_position());
				
				if playerDist < maxPlayerDistance:
					var _dir = (boid.get_position() - playerRef.get_position()).normalized();
					"""
					var multiplier = sqrt(1 - (dist / maxPlayerDistance));
					
					boid.acceleration += dir * multiplier * predatorWeight;
					"""

#TEST

func ceiling():
	for boid in boids:
		var height = boid.position.y;
		var downwardForce = -height / 50;
		
		if downwardForce < -5:
			continue;
		
		boid.acceleration += Vector3(0, downwardForce, 0);

func detectNeighbors():
	for boid in boids:
		boid.neighbors.clear();
		boid.neighborsDistances.clear();
	
	for boid in boids:
		for boid2 in boids:
			var distance = boid.get_position().distance_to(boid2.get_position());
			
			if distance <= visualRange:
				boid.neighbors.append(boid2);
				boid2.neighbors.append(boid);
				
				boid.neighborsDistances.append(distance);
				boid2.neighborsDistances.append(distance);

func alignment():
	for i in range(boids.size()):
		var neighbors = boids[i].neighbors;
		
		if neighbors.is_empty():
			continue;
		
		var averageVelocity = Vector3.ZERO;
		
		for j in range(neighbors.size()):
			averageVelocity += neighbors[j].velocity;
		
		averageVelocity /= neighbors.size();
		
		boids[i].acceleration += averageVelocity * alignmentWeight;

func seperation():
	for boid in boids:
		var neighbors = boid.neighbors;
		var distances = boid.neighborsDistances;
		
		if neighbors.is_empty():
			continue;
		
		for i in range(neighbors.size()):
			if (distances[i] >= separationDistance):
				continue;
			
			var distanceMultipler = 1 - (distances[i] / separationDistance);
			var direction = boid.get_position() - neighbors[i].get_position();
			direction = direction.normalized();
			
			boid.acceleration += direction * distanceMultipler * separationWeight;

func cohesion():
	for boid in boids:
		var neighbors = boid.neighbors;
		
		if (neighbors.is_empty()):
			continue;
		
		var avgPosition = Vector3.ZERO;
		
		for nearbyBoid in neighbors:
			avgPosition += nearbyBoid.get_position();
		
		avgPosition /= neighbors.size();
		
		var direction = avgPosition - boid.get_position();
		boid.acceleration += direction * cohesionWeight;
