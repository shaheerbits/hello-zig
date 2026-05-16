const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            next: ?*Node,
        };

        const Self = @This();

        head: ?*Node,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .head = null,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            var temp = self.head;
            while (temp) |ptr| {
                const next_ptr = ptr.next;
                self.allocator.destroy(ptr);
                temp = next_ptr;
            }
        }

        pub fn addToEnd(self: *Self, item: T) !void {
            const new_node = try self.allocator.create(Node);
            new_node.* = .{ .value = item, .next = null };

            if (self.head == null) {
                self.head = new_node;
                return;
            }

            var temp = self.head.?;

            while (temp.next) |next| {
                temp = next;
            }

            temp.next = new_node;
        }

        pub fn print(self: *const Self) void {
            var temp = self.head;

            while (temp) |ptr| {
                std.debug.print("{} -> ", .{ptr.value});
                temp = ptr.next;
            }

            std.debug.print("null\n", .{});
        }

        pub fn addToStart(self: *Self, item: T) !void {
            const new_node = try self.allocator.create(Node);
            new_node.* = .{ .value = item, .next = null };

            if (self.head == null) {
                self.head = new_node;
            } else {
                new_node.next = self.head;
                self.head = new_node;
            }
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list = LinkedList(i32).init(allocator);
    defer list.deinit();

    try list.addToEnd(10);
    try list.addToEnd(23);
    try list.addToStart(5);
    try list.addToEnd(87);

    list.print();
}
