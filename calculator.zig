const std = @import("std");

fn calculate(fnum: f32, operator: u8, snum: f32) !f32 {
    return switch (operator) {
        '+' => fnum + snum,
        '-' => fnum - snum,
        '*' => fnum * snum,
        '/' => if (snum == 0) error.DivisionByZero else fnum / snum,
        else => error.InvalidOperation,
    };
}

pub fn main() !void {
    // defining a stdout writer
    var stdout_buffer_frame: [1024]u8 = undefined;
    var stdout_writer_frame = std.fs.File.stdout().writer(&stdout_buffer_frame);
    const writer = &stdout_writer_frame.interface;
    // defining a stdin reader
    var stdin_buffer_frame: [512]u8 = undefined;
    var stdin_reader_frame = std.fs.File.stdin().reader(&stdin_buffer_frame);
    const reader = &stdin_reader_frame.interface;

    var first_num: f32 = undefined;
    var second_num: f32 = undefined;
    var operator: u8 = undefined;

    while (true) {
        try writer.writeAll("Enter the first number: ");
        try writer.flush();

        const input = try reader.takeDelimiterInclusive('\n');
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        first_num = std.fmt.parseFloat(f32, trimmed) catch {
            try writer.writeAll("\nPlease enter a valid number!\n");
            try writer.flush();
            continue;
        };
        break;
    }

    while (true) {
        try writer.writeAll("Enter the operation (+ | - | / | *): ");
        try writer.flush();

        const input = try reader.takeDelimiterInclusive('\n');
        operator = std.mem.trim(u8, input, &std.ascii.whitespace)[0];
        switch (operator) {
            '+' => break,
            '-' => break,
            '/' => break,
            '*' => break,
            else => {
                try writer.writeAll("\nPlease enter a valid operation!\n");
                try writer.flush();
                continue;
            },
        }
    }

    while (true) {
        try writer.writeAll("Enter the second number: ");
        try writer.flush();

        const input = try reader.takeDelimiterInclusive('\n');
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        second_num = std.fmt.parseFloat(f32, trimmed) catch {
            try writer.writeAll("\nPlease enter a valid number!\n");
            try writer.flush();
            continue;
        };
        break;
    }

    const result = calculate(first_num, operator, second_num) catch |err| {
        switch (err) {
            error.DivisionByZero => {
                try writer.writeAll("Error: Division by zero!\n");
                try writer.flush();
            },
            error.InvalidOperation => {
                try writer.print("Error: Invalid operation '{}'!\n", .{operator});
                try writer.flush();
            },
            else => return err,
        }
        return;
    };

    std.debug.print("Result: {d}\n", .{result});
}
