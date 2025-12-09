extends MeshInstance3D

@export var materials : Array[Material]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var random_mat = materials[(randi()%(materials.size()))]
	#set_surface_override_material(0,random_mat)
