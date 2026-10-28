const std = @import("std");
const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Vec3 = @import("vec3.zig").Vec3;
const load_obj = @import("obj.zig").load_obj;
const fit_to_screen = @import("view.zig").fit_to_screen;
const draw_line = @import("line.zig").draw_line;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;

// El .obj se mete dentro del programa al compilar (src/mono.obj)
const mono_obj = @embedFile("mono.obj");

/// Dibuja la arista entre dos vértices ya en coordenadas de pantalla.
fn draw_edge(fb: *Framebuffer, p: Vec3, q: Vec3) !void {
    try draw_line(
        fb,
        @intFromFloat(@round(p.x)),
        @intFromFloat(@round(p.y)),
        @intFromFloat(@round(q.x)),
        @intFromFloat(@round(q.y)),
    );
}

pub fn main() !void {
    const gpa = std.heap.page_allocator;

    const model = try load_obj(gpa, mono_obj);
    const screen = try fit_to_screen(gpa, model.vertices, WIDTH, HEIGHT);

    rl.setTraceLogLevel(.warning);
    rl.initWindow(WIDTH, HEIGHT, "Lab 4: Wireframe");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var fb = Framebuffer.init(WIDTH, HEIGHT, .black, .white);
    defer fb.deinit();

    // Wireframe: las 3 aristas de cada cara
    for (model.faces) |f| {
        const a = screen[f.a];
        const b = screen[f.b];
        const c = screen[f.c];
        try draw_edge(&fb, a, b);
        try draw_edge(&fb, b, c);
        try draw_edge(&fb, c, a);
    }

    // Foto del resultado para la entrega
    try fb.render_to_file("wireframe.png");

    while (!rl.windowShouldClose()) {
        try fb.swap_buffers();
    }
}
