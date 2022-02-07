const std = @import("std");
const Self = @This();

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

const root_path = root() ++ "/";
pub const include_dir = root_path ++ "include";

pub const Library = struct {
    step: *std.build.LibExeObjStep,

    pub fn link(self: Library, other: *std.build.LibExeObjStep) void {
        other.addIncludeDir(include_dir);
        other.linkLibrary(self.step);
    }
};

pub fn create(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) Library {
    const ret = b.addStaticLibrary("mp3lame", null);
    ret.setTarget(target);
    ret.setBuildMode(mode);
    ret.linkLibC();
    ret.addIncludeDir(include_dir);
    ret.addIncludeDir(root_path ++ "lame/lame");
    ret.addIncludeDir(root_path ++ "lame/mpglib");
    ret.addIncludeDir(root_path ++ "lame/libmp3lame");
    ret.addIncludeDir(root_path ++ "lame/include");
    ret.addIncludeDir(root_path ++ "config");
    ret.addCSourceFiles(&.{
        root_path ++ "lame/libmp3lame/VbrTag.c",
        root_path ++ "lame/libmp3lame/bitstream.c",
        root_path ++ "lame/libmp3lame/encoder.c",
        root_path ++ "lame/libmp3lame/fft.c",
        root_path ++ "lame/libmp3lame/gain_analysis.c",
        root_path ++ "lame/libmp3lame/id3tag.c",
        root_path ++ "lame/libmp3lame/lame.c",
        root_path ++ "lame/libmp3lame/mpglib_interface.c",
        root_path ++ "lame/libmp3lame/newmdct.c",
        root_path ++ "lame/libmp3lame/presets.c",
        root_path ++ "lame/libmp3lame/psymodel.c",
        root_path ++ "lame/libmp3lame/quantize.c",
        root_path ++ "lame/libmp3lame/quantize_pvt.c",
        root_path ++ "lame/libmp3lame/reservoir.c",
        root_path ++ "lame/libmp3lame/set_get.c",
        root_path ++ "lame/libmp3lame/tables.c",
        root_path ++ "lame/libmp3lame/takehiro.c",
        root_path ++ "lame/libmp3lame/util.c",
        root_path ++ "lame/libmp3lame/vbrquantize.c",
        root_path ++ "lame/libmp3lame/vector/xmm_quantize_sub.c",
        root_path ++ "lame/libmp3lame/version.c",
        root_path ++ "lame/mpglib/common.c",
        root_path ++ "lame/mpglib/dct64_i386.c",
        root_path ++ "lame/mpglib/decode_i386.c",
        root_path ++ "lame/mpglib/interface.c",
        root_path ++ "lame/mpglib/layer1.c",
        root_path ++ "lame/mpglib/layer2.c",
        root_path ++ "lame/mpglib/layer3.c",
        root_path ++ "lame/mpglib/tabinit.c",
    }, &.{
        "-DHAVE_CONFIG_H",
    });

    return Library{ .step = ret };
}
