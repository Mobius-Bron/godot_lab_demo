extends CanvasLayer

@onready var time_ui: TimeUi = $TimeUi

func set_time_ui(month: int, day: int, hour: int, minute: int) -> void:
	time_ui.set_daytime(month, day, hour, minute);
