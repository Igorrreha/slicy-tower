class_name ChannelSignalsTransmitter
extends Node


@export var _signals_channel: SignalsChannel


func transmit(signal_name: StringName) -> void:
	_signals_channel.emit_signal(signal_name)
