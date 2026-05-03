extends Node2D

@export_group("Territory")
@export var camp: Node2D
@export var territory_radius: float = 200.0

@export_group("Movement")
@export var speed: float = 50.0
@export var wander_strength: float = 2.5
@export var arrived_radius: float = 40.0

@export_group("Daily Schedule")
@export var time_patrols_start: float = 0.21 # About 5 am
@export var time_patrols_end: float = 0.79 # About 7 pm

var velocity: Vector2 = Vector2.ZERO

const name_prefixes: Array[String] = ['White', 'Night', 'Rain', 'Birch', 'Cloud', 'Fern', 'Gorse', 'Moss', 'Reed', 'Willow', 'Apple', 'Dew', 'Ember', 'Feather', 'Gray', 'Hawk', 'Leaf', 'Lily', 'Red', 'Silver', 'Stone', 'Sun', 'Swift', 'Dark', 'Dawn', 'Fallow', 'Holly', 'Mist', 'Morning', 'Mud', 'Nettle', 'Owl', 'Petal', 'Rabbit', 'Robin', 'Snow', 'Sparrow', 'Splash', 'Storm', 'Thistle', 'Beech', 'Bracken', 'Bright', 'Cherry', 'Dusk', 'Fox', 'Hare', 'Honey', 'Lark', 'Mouse', 'Oak', 'Oat', 'Pine', 'Rowan', 'Smoke', 'Spider', 'Ash', 'Black', 'Brindle', 'Clover', 'Crow', 'Dapple', 'Deer', 'Eagle', 'Finch', 'Flame', 'Flower', 'Hazel', 'Ivy', 'Lightning', 'Lion', 'Little', 'Mint', 'Mole', 'Moth', 'Patch', 'Pebble', 'Prickle', 'Quail', 'Ripple', 'Running', 'Rush', 'Shade', 'Shrew', 'Snake', 'Spotted', 'Tangle', 'Thrush', 'Trout', 'Vole', 'Acorn', 'Adder', 'Amber', 'Bee', 'Beetle', 'Bird', 'Blossom', 'Bristle', 'Cedar', 'Cinder', 'Daisy', 'Dove', 'Dust', 'Echo', 'Fire', 'Fly', 'Frost', 'Grass', 'Hollow', 'Ice', 'Juniper', 'Lake', 'Lizard', 'Mallow', 'Maple', 'Marsh', 'Milk', 'Minnow', 'Pale', 'Perch', 'Pike', 'Plum', 'Poppy', 'Pounce', 'Raven', 'Sedge', 'Seed', 'Shell', 'Sky', 'Sorrel', 'Squirrel', 'Swallow', 'Tall', 'Tawny', 'Toad', 'Weasel', 'Alder', 'Ant', 'Aspen', 'Berry', 'Blizzard', 'Bloom', 'Blue', 'Boulder', 'Bramble', 'Breeze', 'Buzzard', 'Claw', 'Doe', 'Eel', 'Freckle', 'Frog', 'Golden', 'Goose', 'Green', 'Heather', 'Heron', 'Hop', 'Hound', 'Jagged', 'Jay', 'Kestrel', 'Kink', 'Larch', 'Leopard', 'Meadow', 'Mistle', 'Needle', 'One', 'Otter', 'Pigeon', 'Quick', 'Rock', 'Rose', 'Rubble', 'Rye', 'Sage', 'Sand', 'Scorch', 'Shadow', 'Shimmer', 'Slate', 'Sleek', 'Sloe', 'Small', 'Snail', 'Soft', 'Song', 'Speckle', 'Spike', 'Spire', 'Stag', 'Starling', 'Stem', 'Stoat', 'Sunny', 'Sweet', 'Talon', 'Thorn', 'Tiger', 'Tiny', 'Turtle', 'Twig', 'Vine', 'Violet', 'Wasp', 'Web', 'Wild', 'Wind', 'Wolf', 'Wood', 'Wren', 'Yellow', 'Arch', 'Badger', 'Bark', 'Bay', 'Bella', 'Big', 'Billy', 'Blaze', 'Bluebell', 'Bounce', 'Brave', 'Briar', 'Broken', 'Brook', 'Brown', 'Bubbling', 'Bug', 'Bumble', 'Chestnut', 'Chive', 'Cinnamon', 'Clear', 'Cone', 'Copper', 'Creek', 'Cricket', 'Crooked', 'Crouch', 'Curl', 'Curly', 'Cypress', 'Dandelion', 'Dangling', 'Dead', 'Down', 'Drizzle', 'Drift', 'Duck', 'Ebony', 'Elder', 'Fallen', 'Fawn', 'Fennel', 'Ferret', 'Fidget', 'Fin', 'Fir', 'Flail', 'Flash', 'Flax', 'Fleet', 'Flicker', 'Flint', 'Flip', 'Flutter', 'Fog', 'Fringe', 'Frond', 'Furze', 'Fuzzy', 'Gravel', 'Gull', 'Hail', 'Half', 'Harry', 'Harvey', 'Hatch', 'Haven', 'Hay', 'Heavy', 'Hill', 'Hoot', 'Hope', 'Jump', 'Kite', 'Lavender', 'Lichen', 'Light', 'Log', 'Long', 'Lost', 'Loud', 'Low', 'Lynx', 'Maggot', 'Marigold', 'Midge', 'Misty', 'Monkey', 'Moon', 'Mossy', 'Mottle', 'Mumble', 'Myrtle', 'Nectar', 'Newt', 'Nut', 'Odd', 'Olive', 'Parsley', 'Pear', 'Pink', 'Pod', 'Pool', 'Primrose', 'Puddle', 'Quiet', 'Ragged', 'Rat', 'Ridge', 'Riley', 'River', 'Rook', 'Root', 'Russet', 'Sandy', 'Sharp', 'Shattered', 'Sheep', 'Shining', 'Shivering', 'Short', 'Shred', 'Shy', 'Slight', 'Snap', 'Sneeze', 'Snip', 'Snook', 'Soot', 'Spark', 'Spot', 'Star', 'Stork', 'Stream', 'Strike', 'Stripe', 'Stumpy', 'Swamp', 'Swan', 'Tansy', 'Thrift', 'Thunder', 'Timber', 'Torn', 'Tulip', 'Tumble', 'Vixen', 'Wave', 'Weed', 'Wet', 'Whisker', 'Whisper', 'Whistle', 'Whorl', 'Wish', 'Woolly', 'Yarrow', 'Yew']
const name_suffixes: Array[String] = ['tail', 'fur', 'pelt', 'claw', 'heart', 'whisker', 'foot', 'wing', 'nose', 'feather', 'cloud', 'flight', 'leaf', 'flower', 'leap', 'shine', 'tooth', 'storm', 'fall', 'step', 'stripe', 'berry', 'face', 'fang', 'song', 'ear', 'dawn', 'frost', 'mist', 'splash', 'spring', 'branch', 'eye', 'fire', 'light', 'pool', 'shade', 'sky', 'spots', 'stream', 'bird', 'breeze', 'eyes', 'fern', 'scar', 'tuft', 'water', 'belly', 'brook', 'dapple', 'mask', 'moon', 'petal', 'runner', 'sight', 'snow', 'stem', 'stone', 'talon', 'thorn', 'whisper', 'willow', 'wind', 'wish', 'bark', 'beam', 'bee', 'blaze', 'bloom', 'blossom', 'briar', 'bright', 'burr', 'burrow', 'bush', 'crawl', 'creek', 'dusk', 'dust', 'eater', 'fish', 'flake', 'flame', 'gorse', 'hawk', 'haze', 'ice', 'jaw', 'leg', 'minnow', 'mouse', 'muzzle', 'needle', 'pad', 'paws', 'peak', 'poppy', 'pounce', 'puddle', 'rose', 'ripple', 'scratch', 'seed', 'shell', 'skip', 'slip', 'snout', 'speck', 'speckle', 'spirit', 'spot', 'stalk', 'strike', 'swoop', 'teeth', 'thistle', 'throat', 'toe', 'watcher', 'whistle']

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camp = get_node("/root/World/Camp")
	name = name_prefixes.pick_random() + name_suffixes.pick_random()
	$Label.text = name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.distance_to($Target.global_position) > arrived_radius:
		# 1. Calculate direction to target
		var direction: Vector2 = ($Target.global_position - global_position).normalized()
		
		# 2. Add some random wandering/meandering
		var wander: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * wander_strength
		var desired_velocity: Vector2 = (direction + wander).normalized() * speed
		
		# 3. Smoothly move toward the desired velocity
		velocity = velocity.lerp(desired_velocity, 0.05)
		
		# 4. Apply movement
		global_position += velocity * delta
	else:
		# We need a new target
		# Go home if the patrolling day has ended
		if not TimeManager.is_within_period(time_patrols_start, time_patrols_end):
			$Target.global_position = camp.global_position
		else:
			# Choose a random location within the territory
			var new_location: Vector2 = Vector2(randf_range(camp.global_position.x - territory_radius, camp.global_position.x + territory_radius), randf_range(camp.global_position.y - territory_radius, camp.global_position.y + territory_radius))
			
			# Set as new target
			$Target.global_position = new_location
		
		
