extends CharacterBody2D

const SPEED = 100
const SPRINT_MULTIPLIER = 1.8
const JUMP_VELOCITY = -210
const MAX_JUMPS = 2  
const DASH_SPEED = 400
const DASH_DURATION = 0.2
const SHAKE_STRENGHT = 1.5   
const GRAVITY = 700  
const WALL_SLIDE_GRAVITY = 20
const WALL_PUSHBACK = 400

const DASH_COOLDOWN = 3.0

@onready var camera: Camera2D = $Camera2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var point_light: PointLight2D = $PointLight2D

@export var particle_scene: PackedScene

var should_shake = false
var jump_count = 0
var is_dashing = false
var is_wall_sliding = false
var dash_time = 0.0
var dash_direction = Vector2.ZERO
var dash_cooldown_timer = 0.0

func _physics_process(delta: float) -> void:
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if is_on_floor():
		jump_count = 0
		animated_sprite_2d.play("idle")
		if should_shake:
			camera.start_shake(SHAKE_STRENGHT, 1)
			should_shake = false
		
	if is_on_floor() and Input.is_action_just_pressed("ui_dash") :
		jump_count = 0
		animated_sprite_2d.play("dash")

	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump")
			jump_count += 1
		elif jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("double_jump")
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

	if Input.is_action_just_pressed("ui_dialogue"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor() and is_dashing:
		jump_count = 0
		animated_sprite_2d.play("ui_dash")
	elif is_on_floor() and !is_dashing:
		jump_count = 0
		animated_sprite_2d.play("idle")

	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump")
			jump_count += 1
		elif jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("double_jump")
			jump_count += 1

	var current_speed = SPEED
	if Input.is_action_pressed("ui_sprint"):
		current_speed *= SPRINT_MULTIPLIER
		animated_sprite_2d.play("run")

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

	move_and_slide()
	

func wall_slide(delta: float) -> void:
	if is_on_wall() and not is_on_floor():
		is_wall_sliding = true
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += WALL_SLIDE_GRAVITY * delta
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)
