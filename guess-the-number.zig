//! Number Guessing Game in Zig
//! Programmed by: Shaheer Shaikh
//! Assisted & Commented by: Claude

const std = @import("std");
// Zig's equivalent of importing a module. @import is a compiler builtin
// that returns the standard library as a struct you can access fields on.

/// Generates a random number between from and to (inclusive)
fn generate_random(from: u8, to: u8) u8 {
    // u8 = unsigned 8-bit integer (0–255). Unlike most high-level languages,
    // Zig makes you choose the exact integer size. No generic 'number' or 'int'.

    // Seed the PRNG using the OS's entropy source — same concept as in any language.
    // We use u64 for the seed because DefaultPrng.init() requires a 64-bit value.
    const seed = std.crypto.random.int(u64);

    // Initialize a pseudo-random number generator with that seed.
    // Zig separates "get truly random bytes from OS" (crypto.random)
    // from "fast deterministic PRNG for general use" (DefaultPrng).
    var prng = std.Random.DefaultPrng.init(seed);
    const rand = prng.random();

    // Generate a number in [from, to] inclusive.
    // "AtMost" explicitly signals the upper bound is included —
    // no off-by-one surprises unlike many standard library conventions.
    return rand.intRangeAtMost(u8, from, to);
}

pub fn main() !void {
    // '!void' means this function returns void but can also return an error.
    // Zig has no exceptions — errors are values that propagate through return types.
    // '!void' is shorthand for 'anyerror!void' — an error union type.

    // --- OUTPUT SETUP ---

    // Zig 0.15 overhauled I/O to be explicitly buffered.
    // You provide the buffer memory yourself — nothing is hidden or heap-allocated
    // behind the scenes. This is core Zig philosophy: no surprise allocations.
    var stdout_buffer: [1024]u8 = undefined;

    // Create a buffered writer backed by our stack-allocated buffer.
    // Writes go into this buffer first, then get flushed to the OS in one syscall.
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const writer = &stdout_writer.interface;
    // .interface gives us a type-erased *Writer pointer — lets us call
    // .writeAll(), .print(), .flush() without caring about the concrete type underneath.

    // --- INPUT SETUP ---

    // Same pattern for stdin — explicit buffer, explicit reader.
    var stdin_buffer: [512]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const reader = &stdin_reader.interface;

    // --- GAME ---

    const random_num = generate_random(0, 100);

    // writeAll() for plain strings, print() for formatted output (like printf).
    // flush() is mandatory — buffered I/O means nothing hits the terminal
    // until you explicitly flush. Forgetting this is a common gotcha in Zig 0.15.
    try writer.writeAll("I have a random number, can you guess it?\n");
    try writer.flush();
    // 'try' unwraps the result or propagates the error up to the caller.
    // Equivalent to: if (err) return err; — but concise.

    while (true) {
        try writer.writeAll("Enter your guess: ");
        try writer.flush(); // flush before reading — otherwise prompt won't appear

        // takeDelimiterInclusive('\n') reads from stdin until '\n' is hit,
        // returning a slice that includes the delimiter.
        // We use Inclusive (not Exclusive) to avoid a Windows \r\n bug where
        // Exclusive would leave a phantom \r in the buffer on the next read.
        //
        // Returns an error union — the |num| syntax is the "if ok" branch,
        // else |_| is the "if error" branch. Similar to Result pattern in other languages.
        if (reader.takeDelimiterInclusive('\n')) |num| {

            // Trim whitespace including \r\n from both ends.
            // Essential on Windows where line endings are \r\n, not just \n.
            const trimmed = std.mem.trim(u8, num, " \t\r\n");

            // Parse string to integer. Base 10, target type u8.
            // Returns an error if input isn't a valid number —
            // 'try' propagates that error up, crashing with a message.
            // In a production app you'd use 'catch' here to handle it gracefully.
            const guess = try std.fmt.parseInt(u8, trimmed, 10);

            if (guess > random_num) {
                try writer.writeAll("It's a smaller number!\n");
                try writer.flush();
            } else if (guess < random_num) {
                try writer.writeAll("It's a larger number!\n");
                try writer.flush();
            } else {
                // {d} is the format specifier for integers.
                // .{guess} is an anonymous struct tuple — Zig's way of passing
                // variadic format arguments in a type-safe, comptime-checked way.
                try writer.print("BINGO!!! you found the number! it's {d}\n", .{guess});
                try writer.flush();
                break;
            }
        } else |_| {
            // |_| discards the error value — we don't need to inspect it here.
            try writer.writeAll("Please enter a valid number!\n");
            try writer.flush();
        }
    }
}
