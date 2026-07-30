class Powertmux < Formula
  desc "Drop-in tmux.conf with a styled status bar, window tabs, and sane defaults"
  homepage "https://github.com/napalm255/powertmux"
  url "https://github.com/napalm255/powertmux/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5d9e2cb32e2b3f71c3232eb1b4a0fc3fd20bc9da23530c7f1e8a5748492781c7"
  license "Unlicense"

  depends_on "tmux"

  def install
    pkgshare.install "tmux.conf"
  end

  def caveats
    <<~EOS
      tmux.conf has been installed to:
        #{opt_pkgshare}/tmux.conf

      tmux looks for $XDG_CONFIG_HOME/tmux/tmux.conf (falling back to
      ~/.config/tmux/tmux.conf) before ~/.tmux.conf. To use powertmux there,
      symlink it in:
        mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
        ln -sf "#{opt_pkgshare}/tmux.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
    EOS
  end

  test do
    tmux = formula_opt_bin("tmux")/"tmux"
    system tmux, "-f", pkgshare/"tmux.conf", "new-session", "-d", "-s", "powertmux_test"
    system tmux, "kill-session", "-t", "powertmux_test"
  end
end
