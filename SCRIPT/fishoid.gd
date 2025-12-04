extends Node3D
class_name Fishoid

@export var  speed : float = 5.0
@export var steering_speed = 2.0
@export_range(-1,1) var min_fov_angle : float = -1 

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
	var steering_direction = find_direction()
	global_position += direction * speed * delta
	direction += steering_speed * steering_direction * delta
	look_at(global_position + direction, transform.basis.y)

func find_direction() -> Vector3 :
	#filter with boid fov and distance
	var alignment_boids : Array[Fishoid] = []
	var repulsion_boids : Array[Fishoid] = []
	var cohesion_boids : Array[Fishoid] = []
	
	for boid in boids : 
		if(is_in_sight(boid)) :
			if(global_position.distance_to(boid.global_position)<=alignment_distance):
				alignment_boids.append(boid)
			if(global_position.distance_to(boid.global_position)<=repulsion_distance):
				repulsion_boids.append(boid)
			if(global_position.distance_to(boid.global_position)<=cohesion_distance):
				cohesion_boids.append(boid)
				
	var target_direction = (cohesion_factor*cohesion(cohesion_boids) + alignment_factor*alignment(alignment_boids) + repulsion_factor*repulsion(repulsion_boids)).normalized()
	if target_direction==Vector3.ZERO :
		return Vector3.ZERO
	var steering_direction = (target_direction - direction).normalized()
	return steering_direction
	
func cohesion(boids : Array[Fishoid]) -> Vector3: 
	if boids.size() == 0 :
		return Vector3()
	return (boids.reduce(func(acc, b) : return acc+b.global_position, Vector3())/boids.size() - global_position).normalized()
	
func repulsion(boids : Array[Fishoid]) -> Vector3: 
	if boids.size() == 0 :
		return Vector3()
	return -(boids.reduce(func(acc, b) : return b.global_position - global_position +acc, Vector3())/boids.size()).normalized()
	
func alignment(boids : Array[Fishoid]) -> Vector3: 
	if boids.size() == 0 :
		return Vector3()
	return boids.reduce(func(acc, b) : return acc+b.direction, Vector3())/boids.size()
	
func is_in_sight(boid : Node3D) -> bool:
	return direction.dot((boid.global_position - global_position).normalized())>min_fov_angle
	
func set_boids(boids : Array[Fishoid]) -> void:
	self.boids = boids.filter(func(b) : return b!=self)
	assert(self.boids.size() == boids.size()-1)
