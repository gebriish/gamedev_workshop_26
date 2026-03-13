package main

PIPE_WIDTH :: 100
PIPE_GAP   :: 200
PIPE_SPAWN_TIME :: 1.5 // seconds
PIPE_SPEED :: 400

Pipe :: struct {
	x_position : f32,
	gap_y_position : f32,
	behind_player : bool
}

get_pipe_boxes :: proc(p: Pipe) -> (upper, lower: Box) {

	upper.min = vec2 { p.x_position, 0 }
	upper.max = upper.min + vec2 { PIPE_WIDTH, p.gap_y_position }

	lower.min = vec2 { p.x_position, p.gap_y_position + PIPE_GAP }
	lower.max = lower.min + vec2 { PIPE_WIDTH, SCREEN_H - p.gap_y_position - PIPE_GAP }

	return // automatically returns upper and lower
}


