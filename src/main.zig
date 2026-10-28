const std = @import("std");
const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const load_obj = @import("obj.zig").load_obj;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;

// El .obj se mete dentro del programa al compilar (src/mono.obj)
const mono_obj = @embedFile("mono.obj");

pub fn main() !void {
    const model = try load_obj(std.heap.page_allocator, mono_obj);

    const v0 = model.vertices[0];
    const f0 = model.faces[0];
    std.debug.print("vertices: {d}  caras: {d}\n", .{ model.vertices.len, model.faces.len });
    std.debug.print("v0 = ({d}, {d}, {d})\n", .{ v0.x, v0.y, v0.z });
    std.debug.print("f0 = {d} {d} {d}\n", .{ f0.a, f0.b, f0.c });

    rl.setTraceLogLevel(.warning);
    rl.initWindow(WIDTH, HEIGHT, "Lab 4: Wireframe");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var fb = Framebuffer.init(WIDTH, HEIGHT, .black, .white);
    defer fb.deinit();

    while (!rl.windowShouldClose()) {
        try fb.swap_buffers();
    }
}
