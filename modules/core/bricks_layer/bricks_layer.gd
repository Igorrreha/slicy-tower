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

var _cur_state: State = State.GRABBED

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _valid_collision_detector: RayCast2D = $ValidCollisionDetector


func _ready() -> void:
	_arm_signals_channel.grabber_relaxed.connect(_on_grabber_relaxed)


func _physics_process(delta: float) -> void:
	if _cur_state != State.FALLING_DOWN:
		return
	
	if is_on_floor():
		if _valid_collision_detector.is_colliding():
			_cur_state = State.LANDED
			_bricks_layers_signals_channel.layer_landed.emit(self)
		else:
			_broke()
	
	velocity.y = _fly_down_speed
	move_and_slide()


func _broke() -> void:
	_cur_state = State.BROKEN
	_bricks_layers_signals_channel.layer_broken.emit(self)
	queue_free()


func _on_grabber_relaxed() -> void:
	if _cur_state == State.GRABBED:
		_cur_state = State.FALLING_DOWN
	
	_arm_signals_channel.grabber_relaxed.disconnect(_on_grabber_relaxed)
