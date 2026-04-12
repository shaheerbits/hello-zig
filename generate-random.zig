const std = @import("std");

pub fn main() !void {
    const secure_random_num = std.crypto.random.intRangeAtMost(u8, 0, 100);
    std.debug.print("Secure Random number: {d}\n", .{secure_random_num});

    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));

    var prng = std.Random.DefaultPrng.init(seed);
    const rand = prng.random();

    const random_number = rand.intRangeAtMost(u8, 0, 100);
    std.debug.print("Random number: {d}\n", .{random_number});
}
