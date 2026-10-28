const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;

/// Una cara triangular: índices (empezando en 0) de sus tres vértices.
pub const Face = struct { a: usize, b: usize, c: usize };

pub const Model = struct {
    vertices: []Vec3,
    faces: []Face,
};

/// Lee el contenido de un archivo .obj (ya en memoria) y devuelve el modelo.
/// Solo usa las líneas "v" y "f"; ignora todo lo demás.
pub fn load_obj(gpa: std.mem.Allocator, text: []const u8) !Model {
    var vertices: std.ArrayList(Vec3) = .empty;
    var faces: std.ArrayList(Face) = .empty;
    errdefer {
        vertices.deinit(gpa);
        faces.deinit(gpa);
    }

    var lines = std.mem.splitScalar(u8, text, '\n');
    while (lines.next()) |raw| {
        // Quita espacios y el '\r' de los finales de línea de Windows
        const line = std.mem.trim(u8, raw, " \t\r");

        if (std.mem.startsWith(u8, line, "v ")) {
            // Vértice: "v x y z"
            var tok = std.mem.tokenizeScalar(u8, line[2..], ' ');
            const x = try std.fmt.parseFloat(f32, tok.next() orelse return error.BadVertex);
            const y = try std.fmt.parseFloat(f32, tok.next() orelse return error.BadVertex);
            const z = try std.fmt.parseFloat(f32, tok.next() orelse return error.BadVertex);
            try vertices.append(gpa, Vec3.init(x, y, z));
        } else if (std.mem.startsWith(u8, line, "f ")) {
            // Cara: "f 47/1/1 3/2/1 45/3/1" -> solo nos importa el número antes de la primera '/'
            var tok = std.mem.tokenizeScalar(u8, line[2..], ' ');
            var idx: [3]usize = undefined;
            for (&idx) |*slot| {
                const grupo = tok.next() orelse return error.NotTriangulated;
                var partes = std.mem.splitScalar(u8, grupo, '/');
                const n = try std.fmt.parseInt(usize, partes.next().?, 10);
                if (n == 0 or n > vertices.items.len) return error.BadFaceIndex;
                slot.* = n - 1; // el .obj cuenta desde 1; nosotros desde 0
            }
            if (tok.next() != null) return error.NotTriangulated; // tenía más de 3 vértices
            try faces.append(gpa, .{ .a = idx[0], .b = idx[1], .c = idx[2] });
        }
    }

    return .{
        .vertices = try vertices.toOwnedSlice(gpa),
        .faces = try faces.toOwnedSlice(gpa),
    };
}
