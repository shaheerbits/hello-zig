const std = @import("std");

const Circle = struct {
    radius: f32,

    pub fn area(self: *const Circle) f32 {
        return 2 * self.radius * self.radius;
    }
};

const Rectangle = struct {
    width: f32,
    height: f32,

    pub fn area(self: *const Rectangle) f32 {
        return self.width * self.height;
    }
};

fn areaOf(shape: anytype) !f32 {
    if (@hasDecl(shape, "area")) return shape.area();
    @compileError("Invalid Shape!");
}

pub fn main() !void {
    const c1 = Circle{ .radius = 3.2 };
    const r1 = Rectangle{ .width = 4, .height = 5.6 };

    const areaOfC1 = try areaOf(c1);
    const areaOfR1 = try areaOf(r1);

    std.debug.print("Circle Area: {d}\nRectangle Area: {d}\n", .{ areaOfC1, areaOfR1 });
}
