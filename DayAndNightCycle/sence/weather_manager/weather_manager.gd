extends Node2D

@onready var rain: GPUParticles2D = $Rain
@onready var snow: GPUParticles2D = $Snow

func _ready() -> void:
	self.global_position = Vector2(640, 360);

func weather_on(type: String) -> void:
	match type:
		"rain":
			rain.emitting = true;
		"snow":
			snow.emitting = true;
		_:
			pass

func weather_off(type: String) -> void:
	match type:
		"rain":
			rain.emitting = false;
		"snow":
			snow.emitting = false;
		_:
			pass
