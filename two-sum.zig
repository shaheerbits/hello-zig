const std = @import("std");
const ArrayList = std.ArrayList;

pub fn twoSum(allocator: std.mem.Allocator, nums: ArrayList(i32), target: i32) !?ArrayList(usize) {
    var i: usize = 0;
    const items = nums.items;
    const length = items.len;
    while (i < length - 1) : (i += 1) {
        var j: usize = i + 1;
        while (j < length) : (j += 1) {
            if (items[i] + items[j] == target) {
                var list: ArrayList(usize) = try .initCapacity(allocator, 2);
                try list.appendSlice(allocator, &[_]usize{ i, j });
                return list;
            }
        }
    }

    return null;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var nums: ArrayList(i32) = .empty;
    defer nums.deinit(allocator);
    try nums.appendSlice(allocator, &[_]i32{ 3, 7, 1, 9, 4, 2 });

    if (try twoSum(allocator, nums, 16)) |value| {
        var list = value;
        defer list.deinit(allocator);
        std.debug.print("Result: {any}\n", .{value.items});
    } else {
        std.debug.print("Result: null\n", .{});
    }
}
