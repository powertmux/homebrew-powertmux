class Powertmux < Formula
  desc "Drop-in tmux.conf with a styled status bar, window tabs, and sane defaults"
  homepage "https://github.com/napalm255/powertmux"
  url "https://github.com/napalm255/powertmux/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5d9e2cb32e2b3f71c3232eb1b4a0fc3fd20bc9da23530c7f1e8a5748492781c7"

  depends_on "tmux"

  def install
    pkgshare.install "tmux.conf"
  end

  def xdg_tmux_conf
    config_home = ENV["XDG_CONFIG_HOME"]
    config_home = "#{Dir.home}/.config" if config_home.blank?
    Pathname.new(config_home)/"tmux/tmux.conf"
  end

  def post_install
    target = xdg_tmux_conf
    target.dirname.mkpath

    if target.symlink? || target.exist?
      if target.symlink? && target.realpath.to_s.start_with?("#{opt_prefix}/")
        target.delete
      else
        backup = Pathname.new("#{target}.pre-powertmux")
        target.rename(backup)
        opoo "Existing #{target} backed up to #{backup}"
      end
    end

    target.make_symlink(opt_pkgshare/"tmux.conf")
  end

  def caveats
    <<~EOS
      tmux.conf has been symlinked to:
        #{xdg_tmux_conf}

      If a pre-existing config was found there, it was backed up to:
        #{xdg_tmux_conf}.pre-powertmux

      `brew uninstall powertmux` cannot remove this symlink automatically
      (Homebrew formulas have no post-uninstall hook). After uninstalling,
      remove it yourself if it's now dangling:
        rm #{xdg_tmux_conf}
    EOS
  end

  test do
    system formula_opt_bin("tmux")/"tmux", "-f", pkgshare/"tmux.conf",
           "new-session", "-d", "-s", "powertmux_test"
    system formula_opt_bin("tmux")/"tmux", "kill-session", "-t", "powertmux_test"
  end
end
