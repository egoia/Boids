extends Node3D
class_name Fishoid

enum State{
	BABY, ADULT, OLD
}
var birthdate : float
var current_state : State 
@export var  adult_age : float
@export var old_age : float
@export var death_age : float
@export var baby_stats : BoidStats
@export var adult_stats : BoidStats
@export var old_stats : BoidStats
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D




var direction : Vector3
var boids : Array[Fishoid]

func _ready() -> void:
	direction  = -transform.basis.z
	mesh_instance_3d.set_surface_override_material(0, baby_stats.material)
	birthdate = Time.get_ticks_msec()/1000
	current_state = State.BABY
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var stats
	match current_state :
		State.OLD : stats = old_stats
		State.ADULT : stats = adult_stats
		State.BABY : stats = baby_stats
		
	var steering_direction = find_direction(stats)
	global_position += direction * stats.speed * delta
	direction += stats.steering_speed * steering_direction * delta
	look_at(global_position + direction, transform.basis.y)
	
	if Time.get_ticks_msec()/1000 - birthdate > death_age:
		queue_free()
	if Time.get_ticks_msec()/1000 - birthdate > old_age and current_state != State.OLD:
		current_state = State.OLD
		mesh_instance_3d.set_surface_override_material(0, old_stats.material)
	elif Time.get_ticks_msec()/1000 - birthdate > adult_age and current_state != State.ADULT:
		current_state = State.ADULT
		mesh_instance_3d.set_surface_override_material(0, adult_stats.material)
	

func find_direction(stats : BoidStats) -> Vector3 :
	#filter with boid fov and distance
	var alignment_boids : Array[Fishoid] = []
	var repulsion_boids : Array[Fishoid] = []
	var cohesion_boids : Array[Fishoid] = []
	
	for boid in boids : 
		if(is_in_sight(boid, stats)) :
			if(global_position.distance_to(boid.global_position)<=stats.alignment_distance):
				alignment_boids.append(boid)
			if(global_position.distance_to(boid.global_position)<=stats.repulsion_distance):
				repulsion_boids.append(boid)
			if(global_position.distance_to(boid.global_position)<=stats.cohesion_distance):
				cohesion_boids.append(boid)
				
	var target_direction = (stats.cohesion_factor*cohesion(cohesion_boids) + stats.alignment_factor*alignment(alignment_boids) + stats.repulsion_factor*repulsion(repulsion_boids)).normalized()
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
	
func is_in_sight(boid : Node3D, stats : BoidStats) -> bool:
	return direction.dot((boid.global_position - global_position).normalized())>stats.min_fov_angle
	
func set_boids(boids : Array[Fishoid]) -> void:
	self.boids = boids.filter(func(b) : return b!=self)
	assert(self.boids.size() == boids.size()-1)
