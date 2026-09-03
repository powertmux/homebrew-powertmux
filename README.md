# powertmux/homebrew-powertmux

> [!IMPORTANT]
> **powertmux is retired and no longer maintained.**
>
> This tap is frozen at v1.1.2 and will receive no further releases. The
> release automation that published this formula has been shut down.
>
> The `tmux.conf` now lives in [napalm255/dotfiles](https://github.com/napalm255/dotfiles) at
> `dot_config/tmux/tmux.conf`, managed with [chezmoi](https://chezmoi.io).
> Copy it from there; it is the same file, still maintained, just no longer
> wrapped in a CLI, a tap, an org and a domain.
>
> Existing releases stay downloadable, but there will be no new ones.
> [powertmux.org](https://powertmux.org) goes offline when the domain
> expires on **29 November 2026**. This repository is archived and read-only.

## How do I install these formulae?

`brew install powertmux/powertmux/powertmux`

Or `brew tap powertmux/powertmux` and then `brew install powertmux`.

## Maintenance

`Formula/powertmux.rb` is published automatically by [goreleaser](https://goreleaser.com)
from [napalm255/powertmux](https://github.com/napalm255/powertmux) on every tagged
release (see `.goreleaser.yml` and `.github/workflows/release.yml` there). Don't
hand-edit the formula here — any manual change will be overwritten on the next release.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
