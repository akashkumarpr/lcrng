// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Akash kumar P R

const std = @import("std");

pub const LCG = struct {
    a: u64,
    c: u64,
    m: u64,
    state: u64,

    pub fn init(seed: u64) LCG {
        return LCG {
            .a = 1103515245,
            .c = 12345,
            .m = 2147483647,
            .state = seed,
        };
    }

    pub fn randNext(self: *LCG) u64 {
        self.state = (self.a *% self.state +% self.c) & self.m;
        return (self.state >> 16) & 0x7FFF;
    }

    pub fn randRange(self: *LCG, minimum: u64, maximum: u64) u64 {
        const min = @min(minimum, maximum);
        const max = @max(minimum, maximum);
        const r = self.randNext();
        return (r % (max - min + 1)) + min;
    }
};