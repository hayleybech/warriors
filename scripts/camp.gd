extends Location

@export var territory_radius: float = 500.00

var clan_members: Array[Warrior]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeManager.day_began.connect(handle_new_day)
	
	# Store references to all clan members
	for child in get_children():
		if child is Warrior:
			clan_members.append(child)

	handle_new_day()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _draw() -> void:
	const center = Vector2(0, 0) # Position relative to the node
	const start_angle = 0
	const end_angle = TAU # TAU is 2 * PI (full circle)
	const point_count = 64 # Increase for a smoother circle
	const color = Color.RED
	const thickness = 0.5 # Outline thickness
	const antialiased = true

	draw_arc(center, territory_radius, start_angle, end_angle, point_count, color, thickness, antialiased)
	
func handle_new_day() -> void:
	assign_patrols()

# Patrol assignment happens at midnight
# It doesn't need to be midnight, because patrolling logic supports going overnight
# But patrol assignment should happen between patrols or at the end of a patrol,
func assign_patrols() -> void:
	EventManager.log_event.emit(EventManager.EventType.Patrol, 'Assigning Patrols')
	
	var patrol_leader_weightings: Dictionary[Warrior.Rank, int] = {
		Warrior.Rank.Leader: 500,
		Warrior.Rank.Deputy: 900,
		Warrior.Rank.SeniorWarrior: 1000,
		Warrior.Rank.Warrior: 700,
		Warrior.Rank.Apprentice: 100,
	}
	
	# Assign weightings
	var warriors_can_patrol: Array[Warrior] = clan_members\
		.filter(func(warrior: Warrior) -> bool: return patrol_leader_weightings.has(warrior.rank))
	var weights: PackedFloat32Array = PackedFloat32Array(warriors_can_patrol\
		.map(func(warrior: Warrior) -> int: return patrol_leader_weightings[warrior.rank])
	)
	
	# Choose a leader for every patrol, using the weightings
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var patrol_leaders: Array[Warrior]
	for patrol: Warrior.Patrol in Warrior.Patrol.values().filter(func(patrol: Warrior.Patrol) -> bool: return patrol != Warrior.Patrol.None):
		var chosen_key: int = rng.rand_weighted(weights)
		var leader: Warrior = warriors_can_patrol[chosen_key]
		EventManager.log_event.emit(EventManager.EventType.Patrol, 'The '+ Warrior.Patrol.find_key(patrol) + ' patrol will be led by ' + leader.get_warrior_name())
		
		leader.scheduled_patrol = patrol
		leader.patrol_mode = Warrior.PatrolMode.Leader
		
		patrol_leaders.append(leader)
		warriors_can_patrol.remove_at(chosen_key)
		weights.remove_at(chosen_key)
	
	# Assign remaining warriors to patrols (large clans can give some members a break)
	for leader: Warrior in patrol_leaders:
		leader.patrol_mode = Warrior.PatrolMode.Leader
		
		if warriors_can_patrol.size() <= 0:
			return
	
		# Assign 1 warrior to the patrol (a more realistic patrol would have multiple)
		var chosen_key: int = randi() % warriors_can_patrol.size()
		var warrior: Warrior = warriors_can_patrol[chosen_key]
		
		warrior.leader = leader
		warrior.scheduled_patrol = leader.scheduled_patrol
		warrior.patrol_mode = Warrior.PatrolMode.Follower
		
		EventManager.log_event.emit(EventManager.EventType.Patrol, warrior.get_warrior_name() + ' will join the ' + Warrior.Patrol.find_key(warrior.scheduled_patrol) + ' patrol.')
		
		warriors_can_patrol.remove_at(chosen_key)
	
	# Finally, any other warriors may rest
	for warrior: Warrior in warriors_can_patrol:
		warrior.leader = warrior
		warrior.scheduled_patrol = Warrior.Patrol.None
		EventManager.log_event.emit(EventManager.EventType.Patrol, warrior.get_warrior_name() + ' has the day off.')
		
	return
