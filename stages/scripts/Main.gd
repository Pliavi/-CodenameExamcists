extends Node2D

export var sound_test: AudioStream

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		SoundController.play_sound(sound_test)
	
	if Input.is_action_just_pressed("ui_down"):
		var current_volume = SoundController.get_volume("FX")
		SoundController.set_volume("FX", current_volume - 10)

	if Input.is_action_just_pressed("ui_up"):
		var current_volume = SoundController.get_volume("FX")
		SoundController.set_volume("FX", current_volume + 10)
