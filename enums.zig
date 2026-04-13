const std = @import("std");

// Enum example
const Direction = enum { north, south, east, west };

pub fn main() void {
    const direction = Direction.north;

    // In Zig, we need to handle all the possiblities
    switch (direction) {
        .north => std.debug.print("Going North!", .{}),
        .south => std.debug.print("Going South!", .{}),
        .east => std.debug.print("Going East!", .{}),
        .west => std.debug.print("Going West!", .{}),
    }
}
