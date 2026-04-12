// importing the std @ inbuild function
const std = @import("std");

// declaring a struct: Point
const Point = struct {
    x: f32,
    y: f32,

    /// finds the difference between self and other point
    fn distanceTo(self: Point, other: Point) f32 {
        const dx = self.x - other.x;
        const dy = self.y - other.y;

        return std.math.sqrt(dx * dx + dy * dy);
    }
};

pub fn main() void {
    // creating objects using structs
    const p1 = Point{ .x = 0, .y = 0 };
    const p2 = Point{ .x = 3, .y = 4 };

    // printing to the debug console
    std.debug.print("The distance from p1 to p2 is {d}\n", .{p1.distanceTo(p2)});
}
