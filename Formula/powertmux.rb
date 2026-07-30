class Powertmux < Formula
  desc "Drop-in tmux.conf with a styled status bar, window tabs, and sane defaults"
  homepage "https://github.com/napalm255/powertmux"
  url "https://github.com/napalm255/powertmux/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5d4984490ce2832f87fa203bd9f01d083e73ed4c3994b7de224f1c70f0a05ef0"
  license "Unlicense"

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = %W[
      -s -w
      -X github.com/napalm255/powertmux/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    pkgshare.install "tmux.conf"
  end

  def caveats
    <<~EOS
      Run `powertmux install` to install tmux.conf to the standard XDG path
      ($XDG_CONFIG_HOME/tmux/tmux.conf, falling back to
      ~/.config/tmux/tmux.conf) — this is the recommended way to use powertmux.

      tmux.conf was also installed read-only to:
        #{opt_pkgshare}/tmux.conf

      To symlink that copy in manually instead:
        mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
        ln -sf "#{opt_pkgshare}/tmux.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
    EOS
  end

  test do
    system bin/"powertmux", "--version"

    tmux = formula_opt_bin("tmux")/"tmux"
    system tmux, "-f", pkgshare/"tmux.conf", "new-session", "-d", "-s", "powertmux_test"
    system tmux, "kill-session", "-t", "powertmux_test"
  end
end
