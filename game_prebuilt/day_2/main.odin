package main

SCREEN_W :: 800
SCREEN_H :: 450

PLAYER_SIZE : i32 : 40
GRAVITY     : f32 : 1000
JUMP_VEL    : f32 : 380

MOVE_SPEED :: 200

PIPE_WIDTH  : i32 : 60
SPAWN_TIME  : f32 : 2.0 // in seconds

import rl "vendor:raylib"
import "core:math/rand"

Player :: struct {
	position : f32,
	velocity : f32,
	alive    : bool,
}

Pipe :: struct {
	x : f32,
	y : f32,
}

jump :: proc(player: ^Player) {
	player.velocity = -JUMP_VEL
}

move_player :: proc(player: ^Player, dt: f32) {
	applied_gravity := GRAVITY

	if player.velocity > -60 {
		applied_gravity *= 2.4
	}

	player.velocity += applied_gravity * dt
	player.position += player.velocity * dt
}

resolve_collisions :: proc(player: ^Player) {
	if player.position < 0 {
		player.position = 0
		player.velocity = 0
	}

	if player.position + cast(f32) PLAYER_SIZE >= SCREEN_H {
		player.alive = false
	}
}

main :: proc()
{
	rl.InitWindow(SCREEN_W, SCREEN_H, "Flappy Bird")
	rl.SetTargetFPS(60)

	player : Player
	player.position = 200
	player.alive = true

	pipe_list : [dynamic] Pipe
	spawn_timer : f32 = 0
	
	for !rl.WindowShouldClose() {

		///////////////////

		if player.alive {
			delta := rl.GetFrameTime()

			spawn_timer += delta

			if spawn_timer >= SPAWN_TIME {
				p := Pipe {
					x = SCREEN_W,
					y = rand.float32_range(20, SCREEN_H - 200)
				} 
				append(&pipe_list, p)
				spawn_timer = 0
			}

			for &pipe, i in pipe_list {
				pipe.x -= delta * MOVE_SPEED

				if pipe.x + f32(PIPE_WIDTH) <= 0 {
					unordered_remove(&pipe_list, i)
				}
			}

			move_player(&player, delta)
			if rl.IsKeyPressed(.SPACE) do jump(&player)
			resolve_collisions(&player)
		}
		else {
			if rl.IsKeyPressed(.SPACE) {
				player.position = 200
				player.velocity = -JUMP_VEL
				player.alive = true
				clear(&pipe_list)
			}
		}

		///////////////////

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		rl.DrawRectangle(
			120,
			i32(player.position),
			PLAYER_SIZE,
			PLAYER_SIZE,
			rl.BLUE
		)

		for pipe in pipe_list {
			rl.DrawRectangle(
				i32(pipe.x),
				0,
				PIPE_WIDTH,
				i32(pipe.y),
				rl.VIOLET
			)

			rl.DrawRectangle(
				i32(pipe.x),
				i32(pipe.y) + 120,
				PIPE_WIDTH,
				SCREEN_H - i32(pipe.y),
				rl.VIOLET
			)
		}

		rl.DrawFPS(10, 10)

		if !player.alive {
			rl.DrawText(
				"DEAD! - Space to Restart",
				100,
				SCREEN_H / 2 - 20,
				20,
				rl.RED
			)
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
