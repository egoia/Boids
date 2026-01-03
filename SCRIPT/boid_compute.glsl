layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

//input positions and directions
layout(set = 0, binding = 0, std430) readonly buffer InputBuffer {
	vec3 input_vectors[];
};

//input states
layout(set = 0, binding = 1, std430) readonly buffer StateInputBuffer {
    int boid_states[];
};


//output
layout(set = 0, binding = 2, std430) writeonly buffer OutputBuffer {
	vec3 output_directions[];
};
		
layout(set = 0, binding = 3, std140) uniform Stats {
	float min_fov_angle;
	float alignment_distance;
	float alignment_factor;
	float cohesion_distance;
    
	float cohesion_factor;
	float repulsion_distance;
	float repulsion_factor;
	float _pad;
} babyStats;

layout(set = 0, binding = 4, std140) uniform Stats {
    float min_fov_angle;
    float alignment_distance;
    float alignment_factor;
    float cohesion_distance;

    float cohesion_factor;
    float repulsion_distance;
    float repulsion_factor;
    float _pad;
} adultStats;

layout(set = 0, binding = 5, std140) uniform Stats {
    float min_fov_angle;
    float alignment_distance;
    float alignment_factor;
    float cohesion_distance;

    float cohesion_factor;
    float repulsion_distance;
    float repulsion_factor;
    float _pad;
} oldStats;

bool is_in_sight(vec3 boid_position){
	return dot(params.direction,normalize(boid_position - params.position))>params.min_fov_angle;
}

vec3 cohesion(t_boid boids, int count){
	if(count == 0) return vec3(0.);
	vec3 avg_pos = vec3(0.);
	for(int i = 0; i < count; i++) {
		avg_pos+=boids[i].position;
	}
	avg_pos/=count;
	return normalize(avg_pos - );
}

vec3 repulsion(t_boid boids, int count){
	if(count == 0) return vec3(0,0,0);
	vec3 avg_pos = vec3(0,0,0);
	for(int i = 0; i < count; i++) {
		avg_pos+=boids[i].position - params.position;
	}
	avg_pos/=count;
	return normalize(avg_pos);
}

vec3 find_direction(t_boid_stats boidStats){
	t_boid alignment_boids[input_positions.length];
	int alignment_count = 0;
	t_boid repulsion_boids[input_positions.length];
	int repulsion_count = 0;
	t_boid cohesion_boids[input_positions.length];
	int cohesion_count = 0;
		
	for (int i = 0; i < input_positions.length; i++) {
	   if(is_in_sight(input_positions[i])){
			t_boid b;
			b.position = input_positions[i];
			b.direction = input_directions[i];
			if(distance(input_positions[i], params.position)<=params.alignment_distance){
				alignment_boids[alignment_count] = b;
				alignment_count+=1;
			}
			if(distance(input_positions[i], params.position)<=params.cohesion_distance){
				cohesion_boids[cohesion_count] = b;
				cohesion_count+=1;
			}
			if(distance(input_positions[i], params.position)<=params.repulsion_distance){
				repulsion_boids[repulsion_count] = b;
				repulsion_count+=1;
			}
	   }
	}
}

void main() {
	if(gl_InvocationID.x>input_positions.length)return; 
	
	
}
