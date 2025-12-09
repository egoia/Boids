extends Node3D

@export var box_size : Vector3

@export var max_boids_number : int = 200
@export var boid_spawn_number : int = 20
@export var boid_spawn_elpased_time : float = 2
var boids : Array[Fishoid]
var timer : float = 0


const FISHOID = preload("res://SCENES/fishoid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer>= boid_spawn_elpased_time && boids.size()<max_boids_number:
		timer = 0
		for i in range(boid_spawn_number):
			_spawn_boid()
		boids.assign(get_children().map(func(c) : if c is Fishoid : return c as Fishoid))
		for boid in boids:
			boid.set_boids(boids)
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
	
func _spawn_boid() -> void :
	var boid_position = _random_point_in_box()
	var boid = FISHOID.instantiate()
	add_child(boid)
	boid.global_position = boid_position
	boid.rotation = Vector3(randf(), randf(), randf())*2*PI
	
func _random_point_in_box() -> Vector3:
	var x = (randf()-0.5) * box_size.x;
	var y = (randf()-0.5) * box_size.y
	var z =(randf()-0.5) * box_size.z
	return global_position + Vector3(x,y,z);


func _on_child_exiting_tree(node: Node) -> void:
	boids.erase(node)
	for boid in boids:
		boid.set_boids(boids)
