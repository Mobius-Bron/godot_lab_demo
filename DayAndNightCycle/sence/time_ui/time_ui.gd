class_name TimeUi
extends Control

@onready var arrow: TextureRect = %Arrow
@onready var date_label: Label = %DateLabel
@onready var time_label: Label = %TimeLabel

var month_str: Dictionary = {
	1: "Jan",
	2: "Feb",
	3: "Mac",
	4: "Apr",
	5: "May",
	6: "Jun",
	7: "Jul",
	8: "Aug",
	9: "Sep",
	10: "Oct",
	11: "Dec",
	12: "Nov",
}

func set_daytime(month: int, day: int, hour: int, minute: int) -> void:
	date_label.text = month_str[month + 1] + "." + str(day + 1);
	
	time_label.text = _hour(hour) + ":" + _minute(minute);
	
	if hour <= 12:
		arrow.rotation_degrees = _remap_rangef(hour, 0, 12, -90, 90);
	else:
		arrow.rotation_degrees = _remap_rangef(hour, 13, 23, 90, -90);


func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute);
	return str(minute);

func _hour(hour:int) -> String:
	if hour < 10:
		return "0" + str(hour);
	return str(hour);

func _remap_rangef(input:float, minInput:float, maxInput:float, minOutput:float, maxOutput:float):
	return float(input - minInput) / float(maxInput - minInput) * float(maxOutput - minOutput) + minOutput;
