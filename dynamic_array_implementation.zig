const std = @import("std");

pub fn Vector(comptime T: type) type {
    return struct {
        var Buffer: []T = &[_]T{};
        const Self = @This();

        allocator: std.mem.Allocator,
        len: usize,
        capacity: usize,

        pub fn init(allocator: std.mem.Allocator) error{OutOfMemory}!Self {
            Buffer = try allocator.alloc(T, 2);

            return .{
                .allocator = allocator,
                .len = 0,
                .capacity = 2,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(Buffer);
        }

        pub fn ensureCapacity(self: *Self) error{OutOfMemory}!void {
            if (self.len == self.capacity) {
                self.capacity *= 2;
                Buffer = try self.allocator.realloc(Buffer, self.capacity);
            }
        }

        pub fn append(self: *Self, item: T) error{OutOfMemory}!void {
            try self.ensureCapacity();
            Buffer[self.len] = item;
            self.len += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.len == 0) return null;
            self.len -= 1;
            return Buffer[self.len];
        }

        pub fn items(self: *const Self) []T {
            return Buffer[0..self.len];
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var vector = try Vector(i32).init(allocator);
    defer vector.deinit();

    try vector.append(12);
    try vector.append(23);
    try vector.append(34);
    try vector.append(45);

    if (vector.pop()) |popped| {
        std.debug.print("Popped: {d}\n", .{popped});
    }

    for (vector.items()) |item| {
        std.debug.print("{d}\n", .{item});
    }
}
