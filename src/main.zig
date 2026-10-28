const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const draw_line = @import("line.zig").draw_line;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;

pub fn main() !void {
    rl.setTraceLogLevel(.warning);
    rl.initWindow(WIDTH, HEIGHT, "Lab 4: Wireframe");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var fb = Framebuffer.init(WIDTH, HEIGHT, .black, .white);
    defer fb.deinit();

    // Puntos de destino; todas las líneas salen del centro (400, 300)
    const destinos = [_][2]i32{
        .{ 700, 300 }, // horizontal derecha
        .{ 100, 300 }, // horizontal izquierda
        .{ 400, 50 }, // vertical arriba
        .{ 400, 550 }, // vertical abajo
        .{ 600, 100 }, // diagonal
        .{ 200, 100 },
        .{ 200, 500 },
        .{ 600, 500 },
        .{ 750, 350 }, // poco inclinada
        .{ 430, 40 }, // muy empinada
        .{ 1000, 900 }, // se sale de la pantalla
    };

    for (destinos) |d| {
        try draw_line(&fb, 400, 300, d[0], d[1]);
    }

    while (!rl.windowShouldClose()) {
        try fb.swap_buffers();
    }
}
