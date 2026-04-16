const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // Deallocating the gpa
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list: std.ArrayList(i32) = .empty; // Initializing the ArrayList()
    defer list.deinit(allocator); // Deallocation requires the allocator

    try list.append(allocator, 23);
    try list.append(allocator, 11);
    try list.append(allocator, 97);

    // ArrayList.items returns all items
    std.debug.print("Items: {any}\n", .{list.items});

    // Accessing individual elements
    for (list.items) |item| {
        std.debug.print("{d}\n", .{item});
    }
} 
