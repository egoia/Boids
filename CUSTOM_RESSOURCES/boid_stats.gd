extends Resource
class_name BoidStats

@export var  speed : float = 5.0
@export var steering_speed = 2.0
@export var size = Vector3(1,1,1)
@export_range(-1,1) var min_fov_angle : float = -1 
@export var material : Material

@export_group("Cohesion")
@export var cohesion_distance : float = 1.0
@export_range(0, 1) var cohesion_factor : float = 0

@export_group("Repulsion")
@export var repulsion_distance : float = 1.0
@export_range(0, 1) var repulsion_factor : float = 0

@export_group("Alignment")
@export var alignment_distance : float = 1.0
@export_range(0, 1) var alignment_factor : float = 0
