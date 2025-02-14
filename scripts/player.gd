extends CharacterBody2D

const SPEED = 100
const SPRINT_MULTIPLIER = 1.8
const JUMP_VELOCITY = -290
const MAX_JUMPS = 2  
const DASH_SPEED = 400
const DASH_DURATION = 0.2
const SHAKE_STRENGHT = 1.5   
const GRAVITY = 700  
const WALL_SLIDE_GRAVITY = 20
const WALL_PUSHBACK = 400

const DASH_COOLDOWN = 0.6

@export var use_light: bool = false
@onready var camera: Camera2D = $player_camera
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var point_light: PointLight2D = $PointLight2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var menu: Control = $Screen/Menu

@export var particle_scene: PackedScene

var should_shake = false
var jump_count = 0
var is_dashing = false
var is_wall_sliding = false
var dash_time = 0.0
var dash_direction = Vector2.ZERO
var dash_cooldown_timer = 0.0
var popup = false
var in_game_menu_opened = false

func _ready() -> void:
	add_to_group("player")
	

func _physics_process(delta: float) -> void:
	$PointLight2D.visible = use_light
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if is_on_floor():
		jump_count = 0
		if should_shake:
			camera.start_shake(SHAKE_STRENGHT, 1)
			should_shake = false
		
	if is_on_floor() and Input.is_action_just_pressed("ui_dash") :
		jump_count = 0
		animated_sprite_2d.play("dash")

	if Input.is_action_just_pressed("ui_up") and (not is_on_wall() or is_on_floor()):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		elif jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			should_shake = true
			
	wall_slide(delta)

	if not is_on_floor() and not is_dashing:
		velocity.y += GRAVITY * delta

	if is_on_wall():
		if Input.is_action_just_pressed("ui_right"):
			velocity.y = JUMP_VELOCITY * 1.5
			velocity.x = -WALL_PUSHBACK
			
		elif Input.is_action_just_pressed("ui_left"):
			velocity.y = JUMP_VELOCITY * 1.5
			velocity.x = WALL_PUSHBACK
		else:
			animated_sprite_2d.play("wall_cling_right")
			

	if Input.is_action_just_pressed("ui_dialogue"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			if actionables[0].is_in_group("teleport"):
				actionables[0].teleport(self)
			elif actionables[0].is_in_group("rocket"):
				if not popup:
					actionables[0].popup(true)
					popup = true
				else:
					actionables[0].popup(false)
					popup = false
					
			else:
				actionables[0].action()
	
	if not popup:
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta

		if is_on_floor():
			jump_count = 0
			if should_shake:
				camera.start_shake(SHAKE_STRENGHT, 1)
				audio_stream_player_2d_2.play()
				should_shake = false
			
		if is_on_floor() and Input.is_action_just_pressed("ui_dash") :
			jump_count = 0
			animated_sprite_2d.play("dash")

		if Input.is_action_just_pressed("ui_up") and (not is_on_wall() or is_on_floor()):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_count += 1
				
			elif jump_count < MAX_JUMPS:
				velocity.y = JUMP_VELOCITY
				jump_count += 1
				should_shake = true
				
		wall_slide(delta)

		if not is_on_floor() and not is_dashing:
			velocity.y += GRAVITY * delta

		if is_on_wall():
			if Input.is_action_just_pressed("ui_right"):
				velocity.y = JUMP_VELOCITY * 1.5
				velocity.x = -WALL_PUSHBACK
				audio_stream_player_2d.play(1.2)
				
			elif Input.is_action_just_pressed("ui_left"):
				velocity.y = JUMP_VELOCITY * 1.5
				velocity.x = WALL_PUSHBACK
				audio_stream_player_2d.play(1.2)
			else:
				animated_sprite_2d.play("wall_cling_right")
				
		

		var direction = Input.get_axis("ui_left", "ui_right")
		
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		var current_speed = SPEED

		if is_on_floor() and is_dashing:
			jump_count = 0
			animated_sprite_2d.play("dash")
		elif is_on_floor():
			jump_count = 0
			if Input.is_action_pressed("ui_sprint"):
				current_speed *= SPRINT_MULTIPLIER
				animated_sprite_2d.play("run")
			elif direction!=0:
				animated_sprite_2d.play("walk")
			else:
				animated_sprite_2d.play("idle")
		
		if Input.is_action_just_pressed("ui_up") and (not is_on_wall() or is_on_floor()):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_count += 1
			elif jump_count < MAX_JUMPS:
				velocity.y = JUMP_VELOCITY
				jump_count += 1
			audio_stream_player_2d.play(1.2)
			

		

		var input_direction = Input.get_axis("ui_left", "ui_right")
		if not is_dashing:
			if input_direction != 0:
				velocity.x = input_direction * current_speed
				animated_sprite_2d.flip_h = (input_direction < 0)
			else:
				velocity.x = move_toward(velocity.x, 0, current_speed)

		if Input.is_action_just_pressed("ui_dash") and not is_dashing and dash_cooldown_timer <= 0:
			is_dashing = true
			dash_time = DASH_DURATION
			dash_cooldown_timer = DASH_COOLDOWN  # Reset cooldown timer.
			animated_sprite_2d.play("dash")
			if input_direction != 0:
				dash_direction = Vector2(input_direction, 0).normalized()
			else:
				dash_direction = Vector2(-1 if animated_sprite_2d.flip_h else 1, 0)
			velocity.y = 0  

		if is_dashing:
			velocity.x = dash_direction.x * DASH_SPEED
			velocity.y = dash_direction.y * DASH_SPEED
			dash_time -= delta
			if dash_time <= 0:
				is_dashing = false
		
		if !is_on_wall() and !is_on_floor():
			if jump_count >= MAX_JUMPS:
				animated_sprite_2d.play("double_jump")
			else:
				animated_sprite_2d.play("jump")
			
		
		move_and_slide()
	

func wall_slide(delta: float) -> void:
	if is_on_wall() and not is_on_floor():
		velocity.y += WALL_SLIDE_GRAVITY * delta
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_menu"):
		menu.visible = true
		
