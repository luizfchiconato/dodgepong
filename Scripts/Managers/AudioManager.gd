extends Node

#This class preloads all of our sound effects so that they can be played at a momets notice
#region New Code Region

const PLAYER_ATTACK_HIT = preload("res://Art/Audio/Effects/PongHit.ogg")
const PLAYER_ATTACK_SWING = preload("res://Art/Audio/Effects/AttackSwing.ogg")
const ENEMY_HIT = preload("res://Art/Audio/Effects/EnemyHit.ogg")
const BLOODY_HIT = preload("res://Art/Audio/Effects/bloody_hit.ogg")
const COIN_PICK = preload("res://Art/Audio/Effects/coin_pick.ogg")
const QUEST_SOUND = preload("res://Art/Audio/Effects/QuestSound.ogg")
const BALL_HIT = preload("res://Art/Audio/Effects/BallHit.ogg")
const BOWLING_FALL = preload("res://Art/Audio/Effects/BowlingFall.ogg")
const ENEMY_HIT_DEFAULT = preload("res://Art/Audio/Effects/EnemyHit.ogg")
const ENEMY_HIT_BOWLING = preload("res://Art/Audio/Effects/EnemyHitBowling.ogg")
const PLAYER_HURT = preload("res://Art/Audio/Effects/PlayerHurt.ogg")
const DASH = preload("res://Art/Audio/Effects/Dash.ogg")

#endregion
var audio_player : AudioStreamPlayer 
var audio_player2 : AudioStreamPlayer 
var audio_player3 : AudioStreamPlayer 
var audio_player4 : AudioStreamPlayer 
var audio_player5 : AudioStreamPlayer 

var audioStreams = []
var NUM_AUDIO_STREAMS = 5

#Play a sound, call this function from anywhere
#offset lets you start the sound with an offset, like starting the sound at 0.1s into the clip
#Arguments(audio_clip, offset, volume)
#Example when calling this function:
#AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.25, 1)
func play_sound(audiostream : AudioStreamOggVorbis, offset : float, volume : float, pitch: float = randf_range(0.9, 1.1)):
	if(audioStreams.size() == 0):
		initiate_audio_stream()
	
	#Play the second audioplayer if the first is already busy
	var player = null
	for audioStream in audioStreams:
		if(audioStream.playing == false):
			player = audioStream
	if (player == null):
		player = audioStreams[0]

	player.stream = audiostream
	player.pitch_scale = pitch
	player.volume_db = volume
	player.play(offset)

#Instantiate two audiostreams into the scene, this only happens if none already exists
func initiate_audio_stream():
	for i in range(NUM_AUDIO_STREAMS):
		audio_player = AudioStreamPlayer.new()
		audioStreams.push_back(audio_player)
		add_child(audio_player)
