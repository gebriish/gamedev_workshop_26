package main

import rl "vendor:raylib"

GRAVITY :: 1000
JUMP_VEL :: -300

main :: proc() {

	rl.InitWindow(640, 480, "flappy bird")
	rl.SetTargetFPS(60)


	player_pos : f32 = 0
	player_vel : f32 = 0

	for !rl.WindowShouldClose() {

		dt := rl.GetFrameTime()

		if rl.IsKeyPressed(.SPACE) {
			player_vel = JUMP_VEL
		} else {
			player_vel += GRAVITY * dt
		}

		player_pos += player_vel * dt

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)


		rl.DrawRectangle(50, i32(player_pos), 60, 60, rl.RED)


		rl.EndDrawing()

	}

	rl.CloseWindow()

}