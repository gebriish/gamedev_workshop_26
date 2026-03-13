package main

import "core:math/rand"

Box :: struct { // used for rendering and physics
	min, max: vec2
}

aabb_intersects :: proc(a, b: Box) -> bool {
    if a.max.x < b.min.x || a.min.x > b.max.x {
        return false
    }

    if a.max.y < b.min.y || a.min.y > b.max.y {
        return false
    }

    return true
}

World :: struct {
	
	player : Player,
	pipes  : [dynamic] Pipe,

	pipe_swan_timer : f32,

}

world_update :: proc(world: ^World, dt: f32)
{
	world.pipe_swan_timer += dt;
	if world.pipe_swan_timer > PIPE_SPAWN_TIME
	{
		append(&world.pipes, Pipe {
			x_position = SCREEN_W,
			gap_y_position = rand.float32_range(50, SCREEN_H - PIPE_GAP - 50)
		})

		world.pipe_swan_timer = 0;
	}

	player_locomote(&world.player, dt)

	player_box := get_player_box(world.player)

	#reverse for &pipe, i in world.pipes {
		pipe.x_position -= PIPE_SPEED * dt;
		
		if pipe.x_position < PLAYER_SCREEN_X && !pipe.behind_player {
			pipe.behind_player = true;
			world.player.score += 1
		}

		if pipe.x_position < -PIPE_WIDTH {
			unordered_remove(&world.pipes, i)
		}

		u, l := get_pipe_boxes(pipe)

		if (aabb_intersects(player_box, u) || aabb_intersects(player_box, l))
		{
			world.player.dead = true
			return;
		}
	}
}

world_restart :: proc(world: ^World)
{
	world.player = {
		position = f32(SCREEN_H - PLAYER_SIZE) / 2.0,
		dead = false,
		velocity = PLAYER_JUMP_VEL,
		score = 0
	}

	clear(&world.pipes)

}
