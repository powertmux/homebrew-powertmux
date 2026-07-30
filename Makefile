FORMULA := powertmux
TAP := powertmux/powertmux

.PHONY: help deps trust cleanup setup tap-syntax formulae ci

help:
	@echo "Targets: deps, trust, cleanup, setup, tap-syntax, formulae, ci"

deps:
	brew install-bundler-gems

# Homebrew's Tap-Trust feature blocks brew test-bot's install/uninstall
# cycle on a fresh checkout of this (non-core, unverified) tap; trust it
# once so `formulae` can actually build/install/test the formula.
trust:
	brew trust $(TAP) || true

cleanup:
	brew test-bot --only-cleanup-before

setup:
	brew test-bot --only-setup

# `brew test-bot --only-tap-syntax` hardcodes `brew audit --except=installed`
# with no flag to add to that list, so this replicates its steps directly
# (see Homebrew's test_bot/tap_syntax.rb) to also skip the `version` audit:
# goreleaser always emits an explicit `version` field in the formula even
# though it's derivable from the release URL, which `brew audit` otherwise
# flags as "redundant with version scanned from URL" on every release.
tap-syntax:
	brew style $(TAP)
	brew readall --aliases --os=all --arch=all $(TAP)
	brew audit --except=installed,version --tap=$(TAP)

formulae: trust
	brew test-bot --only-formulae --testing-formulae=$(FORMULA)

# `setup` runs a full `brew doctor` sweep of the whole machine, which is
# meant for ephemeral CI runners; a real dev machine's brew doctor often has
# unrelated pre-existing warnings (other taps, unlinked kegs, etc.), so the
# local convenience target skips it. `cleanup` is still included: it clears
# stray bottle/output files that a previous `make formulae` run leaves in
# this directory, which `formulae` itself checks for and fails on. Run
# `make setup` directly if you want the full CI sequence.
ci: deps cleanup tap-syntax formulae
