const std = @import("std");
const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const load_obj = @import("obj.zig").load_obj;
const fit_to_screen = @import("view.zig").fit_to_screen;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;

// El .obj se mete dentro del programa al compilar (src/mono.obj)
const mono_obj = @embedFile("mono.obj");

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

    // Prueba: un puntito de 2x2 píxeles por cada vértice
    for (screen) |p| {
        const x: i32 = @intFromFloat(p.x);
        const y: i32 = @intFromFloat(p.y);
        try fb.set_pixel(x, y);
        try fb.set_pixel(x + 1, y);
        try fb.set_pixel(x, y + 1);
        try fb.set_pixel(x + 1, y + 1);
    }

    while (!rl.windowShouldClose()) {
        try fb.swap_buffers();
    }
}
