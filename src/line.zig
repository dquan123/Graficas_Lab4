const Framebuffer = @import("framebuffer.zig").Framebuffer;

/// Dibuja una línea entre (x0, y0) y (x1, y1) con el algoritmo de Bresenham.
/// Usa el color actual del framebuffer. Los píxeles fuera de pantalla se ignoran.
pub fn draw_line(fb: *Framebuffer, x0: i32, y0: i32, x1: i32, y1: i32) !void {
    var x = x0;
    var y = y0;

    // Distancia horizontal y vertical entre los extremos
    const dx: i32 = @intCast(@abs(x1 - x0));
    const dy: i32 = @intCast(@abs(y1 - y0));

    // Dirección en la que avanzamos en cada eje
    const sx: i32 = if (x0 < x1) 1 else -1;
    const sy: i32 = if (y0 < y1) 1 else -1;

    // Desviación acumulada respecto a la línea ideal
    var err: i32 = dx - dy;

    while (true) {
        // Solo pintamos si el píxel está dentro de la pantalla
        if (x >= 0 and x < fb.width and y >= 0 and y < fb.height) {
            try fb.set_pixel(x, y);
        }

        if (x == x1 and y == y1) break;

        const e2 = 2 * err;
        if (e2 > -dy) { // toca avanzar en x
            err -= dy;
            x += sx;
        }
        if (e2 < dx) { // toca avanzar en y
            err += dx;
            y += sy;
        }
    }
}
