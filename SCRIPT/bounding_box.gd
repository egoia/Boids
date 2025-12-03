extends Node3D

@export var box_size : Vector3
var boids : Array[Fishoid]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boids.assign(get_children().map(func(c) : if c is Fishoid : return c as Fishoid))
	for boid in boids:
		boid.set_boids(boids)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for boid in boids:
		_keep_in_bound(boid)


func _keep_in_bound(boid : Node3D) -> void : 
	const PRECISION = 0.1
	var new_pos  = boid.global_position
	# X
	if boid.global_position.x > global_position.x + box_size.x/2  : 
		new_pos.x = boid.global_position.x - box_size.x + PRECISION
	elif boid.global_position.x < global_position.x - box_size.x/2  : 
		new_pos.x = boid.global_position.x + box_size.x - PRECISION
		
	# Y
	if boid.global_position.y > global_position.y + box_size.y/2  : 
		new_pos.y = boid.global_position.y - box_size.y + PRECISION
	elif boid.global_position.y < global_position.y - box_size.y/2  : 
		new_pos.y = boid.global_position.y + box_size.y - PRECISION
		
	# Z
	if boid.global_position.z > global_position.z + box_size.z/2  : 
		new_pos.z = boid.global_position.z - box_size.z + PRECISION
	elif boid.global_position.z < global_position.z - box_size.z/2  : 
		new_pos.z = boid.global_position.z + box_size.z - PRECISION
	
	boid.global_position = new_pos
