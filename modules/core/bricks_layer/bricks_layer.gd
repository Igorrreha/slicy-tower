extends Area2D


enum State {
	GRABBED,
	FLYING_DOWN,
}


@export var _fly_down_speed := 675.0
@export var _arm_signals_channel: ArmSignalsChannel

var _cur_state: State = State.GRABBED


func _ready() -> void:
	_arm_signals_channel.grabber_relaxed.connect(_on_grabber_relaxed)


func _process(delta: float) -> void:
	if _cur_state == State.FLYING_DOWN:
		position.y += _fly_down_speed * delta


func _on_grabber_relaxed() -> void:
	if _cur_state == State.GRABBED:
		_cur_state = State.FLYING_DOWN
	
	_arm_signals_channel.grabber_relaxed.disconnect(_on_grabber_relaxed)
