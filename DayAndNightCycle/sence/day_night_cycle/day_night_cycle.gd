extends CanvasModulate

## 不同天气的光照资源
const SUN = preload("res://assets/texture/sun.tres")

const MINUTES_PER_DAY = 1440 ## 每天多少分钟
const MINUTES_PER_HOUR = 60 ## 每小时多少分钟
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY ## 弧度/分钟

# 月份天数配置
const MONTH_DAYS = {
	0: 31,  # 一月
	1: 28,  # 二月
	2: 31,  # 三月
	3: 30,  # 四月
	4: 31,  # 五月
	5: 30,  # 六月
	6: 31,  # 七月
	7: 31,  # 八月
	8: 30,  # 九月
	9: 31,  # 十月
	10: 30, # 十一月
	11: 31  # 十二月
}

@export_group("时间相关属性")
@export var INGAME_SPEED = 20.0 ## 时间流速

@export_group("当前的时间")
@export var save_month = 0;
@export var save_day = 0;
@export var save_hour = 0; 
@export var save_minute = 0;

@export_group("当前天气")
@export var save_weather:GradientTexture1D = SUN;

var weather: GradientTexture1D = SUN;

var time: float : set = _set_time;
var time_value: float;

var month: int;  # 0-11
var day: int;    # 0-27/29/30
var hour: int;   # 0-23
var minute: int; # 0-59
var past_minute: int = -1

signal time_tick(day:int, hour:int, minute:int)

func _ready() -> void:
	load_data()

func _process(_delta: float) -> void:
	time += _delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED;

## 加载天气和时间数据
func load_data() -> void:
	## 加载
	#save_month = 0;
	#save_day = 0;
	#save_hour = 0; 
	#save_minute = 0;
	save_weather = SUN;
	
	## 设置当前时间
	var current_minute = MINUTES_PER_HOUR * save_hour + save_minute;
	time = INGAME_TO_REAL_MINUTE_DURATION * current_minute;
	
	month = save_month;
	day = save_day;
	hour = save_hour;
	minute = save_minute;
	
	## 设置天气
	weather = save_weather;

## 计算时间和光照
func _set_time(value: float) -> void:
	time = value;
	time_value = (sin(time - PI / 2) + 1.0) / 2.0; ## 限制在0-1之间
	self.color = weather.gradient.sample(time_value);

	var current_day_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION) % MINUTES_PER_DAY;
	
	hour = int(current_day_minutes / MINUTES_PER_HOUR);
	minute = int(current_day_minutes % MINUTES_PER_HOUR);
	
	if time >= PI * 2:
		time -= PI * 2;
		
		var prev_month = month;
		
		day += 1;
		hour = hour % 24;
		
		month += day / MONTH_DAYS[prev_month];
		day = day % MONTH_DAYS[prev_month];
	
	## 更新ui显示
	if past_minute != minute:
		past_minute = minute
		GameUi.set_time_ui(month, day, hour, minute);

## 增加时间 (用于测试或特殊事件)
func add_time(minutes_to_add: int) -> void:
	var current_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION);
	current_minutes += minutes_to_add;
	time = current_minutes * INGAME_TO_REAL_MINUTE_DURATION;

func set_date(month: int, day: int) -> void:
	self.month = month;
	self.day = day;
	past_minute = -1;

func set_time(hour: int, min: int) -> void:
	var current_minutes = hour * MINUTES_PER_HOUR + minute;
	time = current_minutes * INGAME_TO_REAL_MINUTE_DURATION;
