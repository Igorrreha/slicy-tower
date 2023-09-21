class_name BricksLayer
extends CharacterBody2D


enum State {
	GRABBED,
	FALLING_DOWN,
	LANDED,
	BROKEN,
}


@export var _fly_down_speed := 675.0
@export var _arm_signals_channel: ArmSignalsChannel
@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel
@export var _bricks_slots: Array[Node2D]

var bricks: Array[Brick]
var _cur_state: State = State.GRABBED

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _valid_collision_detector: RayCast2D = $ValidCollisionDetector


func setup(brick_1: Brick, brick_2: Brick, brick_3: Brick) -> void:
	_bricks_slots[0].add_child(brick_1)
	_bricks_slots[1].add_child(brick_2)
	_bricks_slots[2].add_child(brick_3)
	bricks.append(brick_1)
	bricks.append(brick_2)
	bricks.append(brick_3)


func _ready() -> void:
	_arm_signals_channel.grabber_relaxed.connect(_on_grabber_relaxed)


func _exit_tree() -> void:
	if _arm_signals_channel.grabber_relaxed.is_connected(_on_grabber_relaxed):
		_arm_signals_channel.grabber_relaxed.disconnect(_on_grabber_relaxed)


func _physics_process(delta: float) -> void:
	if _cur_state != State.FALLING_DOWN:
		return
	
	velocity.y = _fly_down_speed
	move_and_slide()
	
	if is_on_floor():
		set_collision_layer_value(4, false) # remove this shit
		set_collision_layer_value(3, false) # remove this shit
		if _valid_collision_detector.is_colliding():
			_land()
		else:
			_broke()


func _broke() -> void:
	_cur_state = State.BROKEN
	_bricks_layers_signals_channel.layer_broken.emit(self)
	queue_free()


func _land() -> void:
	_cur_state = State.LANDED
	_bricks_layers_signals_channel.layer_landed.emit(self)


func _on_grabber_relaxed() -> void:
	if _cur_state == State.GRABBED:
		_cur_state = State.FALLING_DOWN
	
	_arm_signals_channel.grabber_relaxed.disconnect(_on_grabber_relaxed)
