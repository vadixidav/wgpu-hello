struct VertexInput {
    position: vec2<f32>,
    color: vec3<f32>,
};

// struct VertexInput {
//     @location(0) position: vec2<f32>,
//     @location(1) color: vec3<f32>,
// };

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec3<f32>,
};

@group(0) @binding(0)
var<storage, read> vs_draw_vertices: array<VertexInput>;

@group(0) @binding(0)
var<storage, read_write> cs_draw_vertices: array<VertexInput>;

@vertex
fn vs_main(@builtin(vertex_index) ix: u32) -> VertexOutput {
    var out: VertexOutput;
    out.color = vs_draw_vertices[ix].color;
    out.clip_position = vec4<f32>(vs_draw_vertices[ix].position, 0.0, 1.0);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(in.color, 1.0);
}

const NUM_TRIANGLES: u32 = 8u;

@compute @workgroup_size(1) 
fn cs_main(@builtin(global_invocation_id) invocation_id: vec3<u32>) {
    var ix = invocation_id.x;
    var t1 = f32(ix) / f32(NUM_TRIANGLES);
    var rad1 = t1 * 2.0 * 3.14159;
    var t2 = f32(ix + 1u) / f32(NUM_TRIANGLES);
    var rad2 = t2 * 2.0 * 3.14159;
    
    cs_draw_vertices[ix * 3u].position = vec2<f32>(0.0, 0.0);
    cs_draw_vertices[ix * 3u].color = vec3<f32>(1.0, 0.0, 0.0);
    cs_draw_vertices[ix * 3u + 1u].position = vec2<f32>(cos(rad1), sin(rad1));
    cs_draw_vertices[ix * 3u + 1u].color = vec3<f32>(mix(1.0, 0.0, t1), mix(0.0, 1.0, t1), 0.0);
    cs_draw_vertices[ix * 3u + 2u].position = vec2<f32>(cos(rad2), sin(rad2));
    cs_draw_vertices[ix * 3u + 2u].color = vec3<f32>(mix(1.0, 0.0, t2), mix(0.0, 1.0, t2), 0.0);
    return;
}
