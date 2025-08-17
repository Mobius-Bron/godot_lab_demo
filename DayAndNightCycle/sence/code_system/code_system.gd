extends Control

@onready var line_edit: LineEdit = $HBoxContainer/LineEdit

## 解读字符串指令
func procees_command(command: String) -> void:
	var parts: PackedStringArray = command.split(" ")
	if parts.size() <= 0:
		return
	
	var cmd: String = parts[0]
	var args: PackedStringArray = parts.slice(1, parts.size())
	
	if not has_method(cmd):
		push_error("没有找到匹配的方法：",cmd)
		return
	
	callv(cmd, args)


func _on_button_button_down() -> void:
	procees_command(line_edit.text);

func weather_on(type: String) -> void:
	WeatherManager.weather_on(type);

func weather_off(type: String) -> void:
	WeatherManager.weather_off(type);

func set_date(_month: String, _day: String) -> void:
	var month = int(_month)-1;
	var day = int(_day)-1;
	
	if month < 0 or month > 11:
		return;
	if day < 0 or day > 30:
		return;
	
	DayNightCycle.set_date(month, day);

func set_time(_hour: String, _minute: String) -> void:
	var hour = int(_hour);
	var minute = int(_minute);
	
	if hour < 0 or hour > 23:
		return;
	if minute < 0 or minute > 60:
		return;
	
	DayNightCycle.set_time(hour, minute);
