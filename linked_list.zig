const std = @import("std");
const Allocator = std.mem.Allocator;

fn LinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            next: ?*Node,
        };

        const Self = @This();

        head: ?*Node = null,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Self {
            
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
}
