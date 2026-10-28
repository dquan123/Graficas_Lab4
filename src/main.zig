const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;

pub fn main() !void {
    rl.setTraceLogLevel(.warning);
    rl.initWindow(WIDTH, HEIGHT, "Lab 4: Wireframe");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var fb = Framebuffer.init(WIDTH, HEIGHT, .black, .white);
    defer fb.deinit();

    // Prueba: cuadrado blanco de 100x100 en el centro
    var y: i32 = 250;
    while (y < 350) : (y += 1) {
        var x: i32 = 350;
        while (x < 450) : (x += 1) {
            try fb.set_pixel(x, y);
        }
    }

    while (!rl.windowShouldClose()) {
        try fb.swap_buffers();
    }
}