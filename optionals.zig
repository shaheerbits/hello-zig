const std = @import("std");

pub fn main() !void {
    var maybe: ?i32 = null; // An optional variable
    maybe = 89;

    // If value is defined (not null), capture it inside 'value' else print 'No value!'
    if (maybe) |value| {
        std.debug.print("The value is {d}\n", .{value});
    } else {
        std.debug.print("No value!", .{});
    }
}
