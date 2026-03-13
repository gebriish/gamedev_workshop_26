package main

import rl "vendor:raylib"

PLAYER_SCREEN_X :: 130
PLAYER_SIZE :: 80

GRAVITY :: 1200
PLAYER_JUMP_VEL :: -490

Player :: struct {
	position: f32,
	velocity: f32,
	rotation: f32,
	score: uint,
	dead : bool,
}

player_locomote :: proc(player: ^Player, dt: f32) {
	if rl.IsKeyPressed(.SPACE) {
		player.velocity = PLAYER_JUMP_VEL
	}

	player.velocity += GRAVITY * dt * 1.1 if player.velocity > -60 else 1.0
	player.position += player.velocity * dt 

	player_box := get_player_box(player^);

	if player_box.min.y < 0 {
		player.position = PLAYER_SIZE * 0.5
		player.velocity = 0
	} else if player_box.max.y > SCREEN_H {
		player.dead = true
		return
	}

	player_update_animations(player, dt)
}

player_update_animations :: proc(player: ^Player, dt: f32) {
	MAX_UP_ROT   :: -30
	MAX_DOWN_ROT :: 20
	ROT_SPEED :: 7

	target_rot := player.velocity * 0.08
	target_rot = clamp(target_rot, MAX_UP_ROT, MAX_DOWN_ROT)
	player.rotation += (target_rot - player.rotation) * ROT_SPEED * dt
}

get_player_box :: proc(player: Player) -> (box: Box)
{
	box.min = vec2 {PLAYER_SCREEN_X, player.position}  - PLAYER_SIZE * 0.5
	box.max = box.min + PLAYER_SIZE
	// vec2 + float, float will be applied to both x and y
	return
}
