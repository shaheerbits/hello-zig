const std = @import("std");

pub fn main() void {
    var a: i32 = 10;
    var b: i32 = 99;

    std.debug.print("Before swap: a = {d}, b = {d}\n", .{ a, b });

    // const temp = a;
    // a = b;
    // b = temp;

    const temp = a;
    a, b = .{ b, temp };

    std.debug.print("After swap:  a = {d}, b = {d}\n", .{ a, b });
}
