extends CharacterBody2D

const SPEED = 150
const SPRINT_MULTIPLIER = 1.5
const JUMP_VELOCITY = -280
const MAX_JUMPS = 2  
const DASH_SPEED = 400
const DASH_DURATION = 0.2
const GRAVITY = 700 
const SHAKE_STRENGHT = 1.5   

@onready var camera: Camera2D = $Camera2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

var in_air = false
var jump_count = 0
var is_dashing = false
var is_flipped : bool
var dash_time = 0.0
var dash_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor() and !is_dashing:
		velocity.y += GRAVITY * delta
		
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		print(actionables)
		if actionables.size() > 0:
			actionables[0].action()
			
			
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		jump_count = 0
		animated_sprite_2d.play("idle")
		if in_air:
			in_air = false
			camera.start_shake(SHAKE_STRENGHT, 1)
	else:
		in_air = true
		
		
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

	if Input.is_action_just_pressed("ui_dash") and not is_dashing:
		is_dashing = true
		dash_time = DASH_DURATION
		animated_sprite_2d.play("dash")

		if input_direction != 0:
			dash_direction = Vector2(input_direction, 0).normalized()
		else:
			var is_flipped = animated_sprite_2d.flip_h
			dash_direction = Vector2(-1 if is_flipped else 1, 0)

		velocity.y = 0

	if is_dashing:
		velocity.x = dash_direction.x * DASH_SPEED
		velocity.y = dash_direction.y * DASH_SPEED

		dash_time -= delta
		if dash_time <= 0:
			is_dashing = false

	move_and_slide()
