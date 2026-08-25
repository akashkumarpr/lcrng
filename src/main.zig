// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Akash Kumar P R

const std = @import("std");
const lcrng = @import("lcrng");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    // Seed PRNG with the current nanosecond timestamp
    const now = std.Io.Clock.now(.real, io);
    const seed: u64 = @truncate(@as(u96, @bitCast(now.toNanoseconds())));

    var prng = lcrng.LCG.init(seed);

    const min: u64 = 1;
    const max: u64 = 50;

    try stdout.print("5 random numbers between {d} and {d}:\n", .{ min, max });
    for (0..5) |i| {
        const val = prng.randRange(min, max);
        try stdout.print("  [{d}] -> {d}\n", .{ i + 1, val });
    }
    try stdout.flush();
}