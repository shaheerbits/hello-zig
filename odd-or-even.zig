const std = @import("std");

// Use *const [4:0]u8 if you want to be extremely specific,
// but []const u8 is the standard way to pass strings around.
fn oddOrEven(number: i32) []const u8 {
    // These strings are stored in the binary's data section,
    // so returning a slice to them is safe.

    // @rem is used when you want to test on negative numbers also (@mod can also be used here)
    if (@rem(number, 2) == 0) return "Even";
    return "Odd";
}

pub fn main() void {
    const numbers = [_]i32{ 1, -5, 2, 14, 0, 15 };
    for (numbers) |num| {
        // We use {s} for strings (slices of u8)
        std.debug.print("{d} is an {s} number.\n", .{ num, oddOrEven(num) });
    }
}
