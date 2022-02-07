const std = @import("std");
const lame = @import("lame.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const lib = lame.create(b, target, mode);
    lib.step.install();
}
