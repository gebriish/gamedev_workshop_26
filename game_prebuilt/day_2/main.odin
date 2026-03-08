package main

import rl "vendor:raylib"
import "core:math/rand"

SCREEN_W :: 800
SCREEN_H :: 450

PLAYER_SIZE :: 40
GRAVITY     :: 1000.0
JUMP_VEL    :: 380.0
MOVE_SPEED  :: 200.0

PIPE_WIDTH  :: 60
SPAWN_TIME  :: 2.0

Player :: struct {
	pos : f32,
	vel : f32,
	alive : bool,
}

Pipe :: struct {
	x, y : f32,
}

main :: proc() {
	rl.InitWindow(SCREEN_W, SCREEN_H, "Flappy Bird")
	rl.SetTargetFPS(60)

	player := Player{pos = 200, alive = true}
	pipes  : [dynamic]Pipe
	timer  : f32

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		if player.alive {
			timer += dt
			if timer >= SPAWN_TIME {
				append(&pipes, Pipe{
					x = SCREEN_W,
					y = rand.float32_range(20, SCREEN_H-200),
				})
				timer = 0
			}

			#reverse for &pipe, i in pipes {
				pipe.x -= MOVE_SPEED * dt
				if pipe.x <= 0 {
					unordered_remove(&pipes, i)
				}
			}

			g : f32 = GRAVITY
			if player.vel > -60 do g *= 2.4

			player.vel += g * dt
			player.pos += player.vel * dt

			if rl.IsKeyPressed(.SPACE) do player.vel = -JUMP_VEL

			if player.pos < 0 {
				player.pos = 0
				player.vel = 0
			}

			if player.pos + PLAYER_SIZE >= SCREEN_H {
				player.alive = false
			}
		} else if rl.IsKeyPressed(.SPACE) {
			player = Player{pos = 200, vel = -JUMP_VEL, alive = true}
			clear(&pipes)
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		rl.DrawRectangle(120, i32(player.pos), PLAYER_SIZE, PLAYER_SIZE, rl.BLUE)

		for p in pipes {
			rl.DrawRectangle(i32(p.x), 0, PIPE_WIDTH, i32(p.y), rl.VIOLET)
			rl.DrawRectangle(i32(p.x), i32(p.y)+120, PIPE_WIDTH, SCREEN_H-i32(p.y), rl.VIOLET)
		}

		rl.DrawFPS(10, 10)

		if !player.alive {
			rl.DrawText("DEAD! - Space to Restart", 100, SCREEN_H/2-20, 20, rl.RED)
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
