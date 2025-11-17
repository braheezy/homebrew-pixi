class PixiEditor < Formula
  desc "Cross-platform pixel art and animation editor written in Zig"
  homepage "https://github.com/foxnne/pixi"
  url "https://github.com/braheezy/pixi", branch: "homebrew", using: :git
  version "HEAD"
  license "MIT"

  depends_on "sdl3"
  depends_on "zig" => :build

  def install
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end
    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    zig_out = buildpath/"zig-out"
    system "zig", "build", *args, *std_zig_args(prefix: zig_out)

    bin.install zig_out/"bin/Pixi"

    assets_source = zig_out/"bin/assets"
    if assets_source.directory?
      (bin/"assets").install Dir[assets_source/"*"]
    end

    prefix.install "LICENSE", "readme.md"
  end
end
