extends MeshInstance3D
@export var tile_width_u:=1

#first ray pointing fully forward
var start1: Vector3
var end1: Vector3

#second ray, starting at the end of the first, and pointing downward
var start2: Vector3
var end2: Vector3

func _ready():
	start1 = position
	end1 = start1 + (basis.z*tile_width_u)
	
	start2 = end1
	end2 = end1 - (basis.y*tile_width_u)

func _physics_process(delta):
	#get the state of 3d space
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(start1,end1)
	var result = space_state.intersect_ray(query)
	
	if result:
		print("hit")
	#else:
		#print("no hit")
