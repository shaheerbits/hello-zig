const std = @import("std");
const Allocator = std.mem.Allocator;

const Circle = struct {
    radius: f32,

    pub fn area(self: *const Circle) f32 {
        return std.math.pi * self.radius * self.radius;
    }
};

const Rectangle = struct {
    length: f32,
    breadth: f32,

    pub fn area(self: *const Rectangle) f32 {
        return self.length * self.breadth;
    }
};

const Shape = union(enum) {
    circle: Circle,
    rectangle: Rectangle,

    pub fn area(self: Shape) f32 {
        return switch (self) {
            .circle => |c| c.area(),
            .rectangle => |r| r.area(),
        };
    }
};

pub fn main() !void {
    const c1 = Shape{ .circle = .{ .radius = 3.2 } };
    const r1 = Shape{ .rectangle = .{ .length = 4, .breadth = 5.6 } };

    std.debug.print("Circle Area: {d}\nRectangle Area: {d}\n", .{ c1.area(), r1.area() });
}
