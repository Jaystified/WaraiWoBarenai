extends StaticBody3D

@export var speed : float = 10.0
@export var stomping_sound_timer : float = 0.0
@export var stomping_sound_interval : float = 0.5 
@export var stomp_away_direction : Vector3 = Vector3(-1,0,0)
@export var initial_distance : float = 100
@export var relax_interval : float = 5.0
@export var room_burst_distance : float = 10.0

var is_alerted : bool = false
var relax_timer : float = 0.0

func _process(delta: float) -> void:
	var can_hear: bool = get_parent().laughRadius > global_transform.origin.distance_to(Vector3.ZERO)
	var is_in_room: bool = global_transform.origin.distance_to(Vector3.ZERO) < room_burst_distance
	if can_hear:
		relax_timer = relax_interval
	else:
		relax_timer-=delta
	if relax_timer>0:
		is_alerted = true
	else:
		is_alerted = false
	var direction : Vector3 = stomp_away_direction * -1 if is_alerted else stomp_away_direction
	var move_speed : float
	
	if is_in_room and relax_timer > 0 :
		move_speed = 0
	elif is_alerted:
		move_speed = speed * 2.0 
	else :
		move_speed =speed

	global_transform.origin += direction * delta * move_speed
	
	stomping_sound_timer += delta
	if move_speed > 0:
		if stomping_sound_timer >= stomping_sound_interval / ( 2.0 if is_alerted else 1.0):
			play_stomping_sound()
			stomping_sound_timer = 0.0
	print(transform)

func play_stomping_sound() -> void:
	var volume : float = 1.0 if is_alerted else 0.5
	$Step.volume_db = volume * 20.0
	$Step.play()

func _ready():
	transform.origin = stomp_away_direction * initial_distance
	pass