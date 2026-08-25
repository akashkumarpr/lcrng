# lcrng
A lightweight, Linear Congruential Generator (LCG) Pseudo-Random number generator (PRNG) built for learning using ZIG 0.16.0 .

### Features
* Safe-Range Bound: Automatic Minimum/Maximum handling using built-in std @min, @max functions.
* Overflow-Safe: Uses wrapping arithmetic opertaions (+%, *%) to avoid integer overflow in debug builds.

### Installation
Fetch and save "lcrng" as a dependency in your project's 'build.zig.zon'

```bash
$ zig fetch --save https://github.com/akashkumarpr/lcrng/archive/refs/tags/v0.1.0.tar.gz
```

### Project Setup
1. Configure build.zig

```zig 
//! Import the module from the dependency and attach it to your executable target
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Obtain the lcrng dependency
    const lcrng_dep = b.dependency("lcrng", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "my-app",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Pass the lcrng module into main.zig
    exe.root_module.addImport("lcrng", lcrng_dep.module("lcrng"));

    b.installArtifact(exe);
}
```

2. Code Example (src/main.zig)

```zig
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
```

### API Reference
* ` LCG.init(seed: u64) LCG `
Constructs a new LCG instance seeded with the provided 64-bit integer.
* ` randNext(self: *LCG) u64 `
Updates the internal state using LCG multiplier parameters and outputs the next calculated 15-bit value.
* ` randRange(self: *LCG, minimum: u64, maximum: u64) u64 `
Returns a pseudo-random integer within the inclusive range [min, max]. Automatically resolves cases where minimum > maximum.

### License
[MIT](LICENSE)
