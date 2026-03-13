package main

import "core:fmt"
import rl "vendor:raylib"

vec2 :: [2]f32

SCREEN_W :: 1200
SCREEN_H :: 800

@(rodata) bg_img_data := #load("background.png", []u8)
@(rodata) bird_img_data := #load("bird.png", []u8) 

main :: proc() {
	rl.InitWindow(SCREEN_W, SCREEN_H, "FlappyBird")
	defer rl.CloseWindow()

	game_world := World{}
	world_restart(&game_world)

	bg_offset: f32 = 0
	score_y: f32 = 20

	BG_SPEED :: 60
	SMOOTH_SPEED :: 6.0

	bg_texture := rl.LoadTextureFromImage(
		rl.LoadImageFromMemory(
			".png", raw_data(bg_img_data), i32(len(bg_img_data)),
		),
	)

	bird_texture := rl.LoadTextureFromImage(
		rl.LoadImageFromMemory(
			".png", raw_data(bird_img_data), i32(len(bird_img_data))
		)
	)

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)

		dt := rl.GetFrameTime()

		if !game_world.player.dead {
			world_update(&game_world, dt)
			bg_offset += BG_SPEED * dt
			if bg_offset > SCREEN_W {
				bg_offset = 0
			}
		} else {
			if rl.IsKeyPressed(.SPACE) {
				world_restart(&game_world)
			}
		}

		font_size: i32 = 60

		target_y: f32
		if game_world.player.dead {
			target_y = SCREEN_H * 0.5 - (auto_cast font_size)
		} else {
			target_y = 20
		}

		score_y += (target_y - score_y) * SMOOTH_SPEED * dt

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		rl.DrawTexture(bg_texture, i32(-bg_offset), 0, rl.WHITE)
		rl.DrawTexture(bg_texture, i32(-bg_offset) + SCREEN_W, 0, rl.WHITE)

		player_box := get_player_box(game_world.player)

		player_rect := rl.Rectangle{
			(player_box.max.x + player_box.min.x) * 0.5 - 20,
			(player_box.max.y + player_box.min.y) * 0.5 - 20,
			PLAYER_SIZE + 40,
			PLAYER_SIZE + 40,
		}

		rl.DrawTexturePro(
			bird_texture, {0, 0, 120, 120}, player_rect,
			PLAYER_SIZE * 0.5,
			game_world.player.rotation,
			rl.WHITE,
		)

		for pipe in game_world.pipes {
			u, l := get_pipe_boxes(pipe)

			rl.DrawRectangle(
				auto_cast u.min.x,
				auto_cast u.min.y,
				auto_cast (u.max.x - u.min.x),
				auto_cast (u.max.y - u.min.y),
				rl.DARKPURPLE,
			)

			rl.DrawRectangle(
				auto_cast l.min.x,
				auto_cast l.min.y,
				auto_cast (l.max.x - l.min.x),
				auto_cast (l.max.y - l.min.y),
				rl.DARKPURPLE,
			)
		}

		score_text := fmt.ctprintf("%d", game_world.player.score)
		text_w := rl.MeasureText(score_text, font_size)
		x := (SCREEN_W - text_w) / 2

		rl.DrawText(score_text, x, i32(score_y), font_size, rl.WHITE)

		if game_world.player.dead {
			go_font: i32 = 80
			go_text : cstring = "Game Over"
			go_w := rl.MeasureText(go_text, go_font)
			go_x := (SCREEN_W - go_w) / 2
			go_y := i32(score_y) + font_size + 40
			rl.DrawText(go_text, go_x, go_y, go_font, rl.RED)
		}

		rl.EndDrawing()
	}
}
