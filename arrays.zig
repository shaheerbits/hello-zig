const print = @import("std").debug.print;
const assert = @import("std").debug.assert;

pub fn main() void {
    const nums = [_]i32{ 23, 71, 42, 59 };

    for (nums) |num| {
        print("{d} x 2 = {d}\n", .{ num, num * 2 });
    }

    var optional_array: ?[5]u8 = null;
    optional_array = [5]u8{ 'H', 'E', 'L', 'L', 'O' };

    if (optional_array) |value| {
        print("Optional Array: {s}", .{value});
    }
}
