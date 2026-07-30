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

tap-syntax:
	brew test-bot --only-tap-syntax

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
