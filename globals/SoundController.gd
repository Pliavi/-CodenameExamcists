extends Node

var fx_player = {"volume": 100, "instances": [], "bus_name": "FX"}
var music_player = {"volume": 100, "instances": [AudioStreamPlayer.new()], "bus_name": "Music"}
var players = {"FX": fx_player, "Music": music_player}


func start(audio_node: Node, num_sound_instances: int = 4) -> void:
	__check_buses()
	for _i in range(num_sound_instances):
		var new_fx_player = AudioStreamPlayer.new()
		new_fx_player.bus = "FX"
		fx_player.instances.push_front(new_fx_player)
		audio_node.add_child(new_fx_player)

	music_player.bus = "Music"
	audio_node.add_child(music_player.instances[-1])


func __check_buses() -> void:
	assert(AudioServer.get_bus_index("Music") != -1, "BusNotFound: Create a bus with name 'Music'")
	assert(AudioServer.get_bus_index("FX") != -1, "BusNotFound: Create a bus with name 'FX'")


func set_volume(bus_name: String, volume: int) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	assert(bus_index != -1)
	var clamped_volume = clamp(volume, 0, 100)
	var interpolated_volume = lerp(-80, 0, clamped_volume / 100.0)

	AudioServer.set_bus_volume_db(bus_index, interpolated_volume)
	players[bus_name].volume = clamped_volume


func get_volume(bus_name: String) -> int:
	var bus_index = AudioServer.get_bus_index(bus_name)
	assert(bus_index != -1)
	return players[bus_name].volume


func play_sound(sound: AudioStream) -> void:
	var current_player
	for player in fx_player.instances:
		if ! player.playing:
			current_player = player
			break
	current_player.stream = sound
	current_player.play()


func play_music(music: AudioStream) -> void:
	var player = music_player.instances.pop_back()
	player.stream = music
	player.play()
