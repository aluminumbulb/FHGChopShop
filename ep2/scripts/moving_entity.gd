extends MeshInstance3D
##An entity capable of checking valid floorspace and moving to it
##

@export var step_dist:=1 ##distance we expect the entity to move each step

##first ray pointing fully forward
var start1: Vector3
var end1: Vector3

##second ray, starting at the end of the first, and pointing downward
var start2: Vector3
var end2: Vector3

var floor_exists:= false ##determines if a floor exists in front of entity

func _ready():
	#first ray/offset setup
	start1 = position
	end1 = start1 + (basis.z*step_dist)
	
	#second ray setup
	start2 = end1
	end2 = end1 - (basis.y*1000)#cast down an arbitrarily large #

func _physics_process(delta):
	#get the state of 3d space
	var space_state = get_world_3d().direct_space_state
	
	#floorcheck
	#query it along ray
	var query = PhysicsRayQueryParameters3D.create(start2,end2)
	#get query result
	var result = space_state.intersect_ray(query)
	
	if result:
		floor_exists = true
	else:
		floor_exists = false
		



func move_impulse():
	pass
