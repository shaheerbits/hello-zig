const std = @import("std");

fn mergeSort(comptime T: type, array: []T, temp: []T) void {
    const length = array.len;
    if (length <= 1) return;

    const middle_index = length / 2;
    const left_array = array[0..middle_index];
    const right_array = array[middle_index..];

    const temp_left = temp[0..middle_index];
    const temp_right = temp[middle_index..];

    mergeSort(T, left_array, temp_left);
    mergeSort(T, right_array, temp_right);

    merge(T, left_array, right_array, array);
}

fn merge(comptime T: type, left: []T, right: []T, dest: []T) void {
    var i: usize = 0;
    var l: usize = 0;
    var r: usize = 0;

    const scratch = std.heap.page_allocator.alloc(T, dest.len) catch unreachable;
    defer std.heap.page_allocator.free(scratch);

    while (l < left.len and r < right.len) : (i += 1) {
        if (left[l] <= right[r]) {
            scratch[i] = left[l];
            l += 1;
        } else {
            scratch[i] = right[r];
            r += 1;
        }
    }

    while (l < left.len) : ({
        i += 1;
        l += 1;
    }) scratch[i] = left[l];

    while (r < right.len) : ({
        i += 1;
        r += 1;
    }) scratch[i] = right[r];

    std.mem.copyForwards(T, dest, scratch);
}

pub fn main() void {
    var nums = [_]i32{ 9, 5, 4, 2, 6, 3, 1, 8 };
    var temp = nums;
    mergeSort(i32, &nums, &temp);
    std.debug.print("{any}\n", .{nums});
}
