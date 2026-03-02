package main


SCREEN_W :: 800
SCREEN_H :: 450

PLAYER_SIZE : i32 : 40
GRAVITY : f32 : 1000
JUMP_VEL : f32 : 580

import rl "vendor:raylib"

main :: proc()
{
	rl.InitWindow(SCREEN_W, SCREEN_H, "Flappy Bird")
	rl.SetTargetFPS(60)
	
	player_y : f32 = 200.0
	player_vel_y : f32 = 0.0
	alive := true

	for !rl.WindowShouldClose() {
		///////////////////
		// game logic update

		if alive {
			delta := rl.GetFrameTime()

			applied_gravity := GRAVITY
			if player_vel_y > -60 {
				applied_gravity *= 2.3
			}

			player_vel_y += applied_gravity * delta
			player_y += player_vel_y * delta

			if rl.IsKeyPressed(.SPACE) {
				player_vel_y = -JUMP_VEL
			}

			if player_y < 0 {
				player_y = 0
				player_vel_y = 0
			}

			if player_y + cast(f32) PLAYER_SIZE >= SCREEN_H {
				alive = false
			}
		}
		else {
            if rl.IsKeyPressed(.SPACE) {
                player_y = 200
                player_vel_y = -JUMP_VEL
                alive = true
            }
		}

		///////////////////
		// game rendering
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		rl.DrawRectangle(
			120, i32(player_y),
			PLAYER_SIZE, PLAYER_SIZE,
			rl.BLUE
		)

		rl.DrawFPS(10,10)

		if !alive {
			rl.DrawText(
				"DEAD! - Space to Restart",
				100, SCREEN_H / 2 - 20, 20, rl.RED
			)
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
