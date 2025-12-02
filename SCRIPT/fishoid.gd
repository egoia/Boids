extends Node3D
class_name Fishoid

@export var  speed : float = 5.0
@export var steering_speed = 2.0

@export_group("Cohesion")
@export var cohesion_distance : float = 1.0
@export_range(0, 1) var cohesion_factor : float = 0

@export_group("Repulsion")
@export var repulsion_distance : float = 1.0
@export_range(0, 1) var repulsion_factor : float = 0

@export_group("Alignment")
@export var alignment_distance : float = 1.0
@export_range(0, 1) var alignment_factor : float = 0




var direction : Vector3
var boids : Array[Fishoid]

func _ready() -> void:
	direction  = -transform.basis.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta

func find_direction() -> void :
	#filter with boid fov and distance
	var alignment_boids = []
	var repulsion_boids = []
	var cohesion_boids = []
	
	for boid in boids : 
		if(is_in_sight(boid)) :
			if(global_position.distance_to(boid.global_position)<=alignment_distance):
				alignment_boids.append(boid)
			if(global_position.distance_to(boid.global_position)<=repulsion_distance):
				repulsion_boids.append(boid)
			if(global_position.distance_to(boid.global_position)<=cohesion_distance):
				cohesion_boids.append(boid)
	
	var target_direction = cohesion_factor*cohesion(cohesion_boids) + alignment_factor*alignment(alignment_boids) + repulsion_factor*repulsion(repulsion_boids)
	var steering_direction = (target_direction - direction).normalized()
	direction += steering_speed * steering_direction

func cohesion(boids : Array[Fishoid]) -> Vector3: #TODO
	return Vector3.ZERO
	
func repulsion(boids : Array[Fishoid]) -> Vector3: #TODO
	return Vector3.ZERO
	
func alignment(boids : Array[Fishoid]) -> Vector3: #TODO
	return Vector3.ZERO
	
func is_in_sight(boid : Node3D) -> bool: #TODO
	return true
	
