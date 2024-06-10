class_name MovingEntity
extends MeshInstance3D
 
##An entity capable of checking valid floorspace and moving to it
##

signal floor_status_change(fl_stat_ch) ##signals change in floor tile availability
signal obst_status_change(obst_stat_ch) ##signals change in obstruction

@export var step_dist:=1 ##distance we expect the entity to move each step

##first ray pointing fully forward
var start1: Vector3
var end1: Vector3

##second ray, starting at the end of the first, and pointing downward
var start2: Vector3
var end2: Vector3

var entity_blocking:= false ##is another entity or object blocking?
var floor_exists:= false ##is there a floor tile where we would like to move?

func _process(delta):
	if Input.is_action_just_pressed("forward_motion"):
		move_impulse()
		
	if Input.is_action_just_pressed("cw_rot"):
		transform.basis = transform.basis.rotated(basis.y,-(PI/2))
		
	if Input.is_action_just_pressed("ccw_rot"):
		transform.basis = transform.basis.rotated(basis.y,(PI/2))

func _ready():
	pass

func _physics_process(delta):
	#first ray/offset setup
	start1 = position
	end1 = start1 + (basis.z*step_dist)
	
	#second ray setup
	start2 = end1
	end2 = end1 - (basis.y*1000)#cast down an arbitrarily large #
	
	other_entity_check()
	floor_check()
	pass

##Alters truthyness of entity_blocking and sends signal if it has changed
##since the last frame
func other_entity_check():
	#get the state of 3d space
	var space_state = get_world_3d().direct_space_state
	#query it along ray
	var query = PhysicsRayQueryParameters3D.create(start1,end1)
	#get query result
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
		
	if result:
		#there is something in our way
		if(not entity_blocking):
			entity_blocking = true
			obst_status_change.emit(entity_blocking)
	else:
		#there is not
		if(entity_blocking):
			entity_blocking = false
			obst_status_change.emit(entity_blocking)

##Alters truthyness of floor_exists and sends signal if it has changed
##since the last frame
func floor_check():
	#get the state of 3d space
	var space_state = get_world_3d().direct_space_state
	
	#floorcheck
	var query = PhysicsRayQueryParameters3D.create(start2,end2)
	var result = space_state.intersect_ray(query)
	
	if result:
		#there will be a floor
		if(not floor_exists):
			floor_exists = true
			floor_status_change.emit(floor_exists)
	else:
		if(floor_exists):
			floor_exists = false
			floor_status_change.emit(floor_exists)

##Checks if conditions are right before allowing motion, 
##performs this motion itself
func move_impulse():
	if(not entity_blocking and floor_exists):
		position+=basis.z
