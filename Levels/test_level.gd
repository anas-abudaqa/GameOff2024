extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("TestTimeline")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_dialogic_signal(argument: String):
	if argument == "cum":
		print("wow this works")
