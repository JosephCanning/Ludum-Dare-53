extends Camera2D

const PIX_UNIT = 24
const SPEED = 15

var bounds_rect

# Called when the node enters the scene tree for the first time.
func _ready():
	bounds_rect = get_parent().get_used_rect()
	self.position.x = bounds_rect.get_center().x * PIX_UNIT
	self.position.y = bounds_rect.get_center().y * PIX_UNIT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	
	velocity = velocity.normalized() * SPEED
	self.position += velocity
