const std = @import("std");
const exactEqual = std.testing.expectEqual;

test "Basic vector usage" {
    const a = @Vector(4, i32){ 1, 2, 6, 3 };
    const b = @Vector(4, i32){ 4, 7, 1, 9 };

    const c = a + b;

    try exactEqual(5, c[0]);
    try exactEqual(9, c[1]);
    try exactEqual(7, c[2]);
    try exactEqual(12, c[3]);
}

pub fn main() void {}
