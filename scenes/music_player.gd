extends AudioStreamPlayer

var queued_song: AudioStream = null

func _ready():
	finished.connect(on_finished)

func on_finished():
	if queued_song != null:
		stream = queued_song
		play()
		queued_song = null
	else:
		play()

func play_song(song):
	if playing:
		queued_song = song
