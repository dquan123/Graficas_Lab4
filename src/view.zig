const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;

/// Convierte los vértices del modelo a coordenadas de pantalla (en píxeles):
/// centra el modelo, lo escala para que quepa en la ventana, y voltea la Y.
/// Devuelve una lista nueva; el modelo original no se modifica.
pub fn fit_to_screen(
    gpa: std.mem.Allocator,
    vertices: []const Vec3,
    width: i32,
    height: i32,
) ![]Vec3 {
    // 1. Caja que contiene al modelo (en x e y)
    var min_x = vertices[0].x;
    var max_x = vertices[0].x;
    var min_y = vertices[0].y;
    var max_y = vertices[0].y;
    for (vertices) |v| {
        min_x = @min(min_x, v.x);
        max_x = @max(max_x, v.x);
        min_y = @min(min_y, v.y);
        max_y = @max(max_y, v.y);
    }

    // Centro del modelo
    const cx = (min_x + max_x) / 2;
    const cy = (min_y + max_y) / 2;

    // 2. Escala: la que haga que quepa en ambos ejes, con 10% de margen
    const w: f32 = @floatFromInt(width);
    const h: f32 = @floatFromInt(height);
    const scale = 0.9 * @min(w / (max_x - min_x), h / (max_y - min_y));

    // 3. Centrar en la ventana, y voltear Y (en pantalla crece hacia abajo)
    const out = try gpa.alloc(Vec3, vertices.len);
    for (vertices, 0..) |v, i| {
        out[i] = Vec3.init(
            (v.x - cx) * scale + w / 2,
            h / 2 - (v.y - cy) * scale,
            v.z,
        );
    }
    return out;
}
