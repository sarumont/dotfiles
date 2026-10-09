# TODO

Open items carried over from the stow → chezmoi migration (completed
2026-10-08 on shiva, dadfi and ifrit). The full migration log is in git
history: `git log --all -- MIGRATION.md`.

## Machines

- [ ] **ifrit: Homebrew only.** It uses both MacPorts and Homebrew; move the
      `darwin_port` list in `home/.chezmoidata/packages.yaml` to Homebrew and
      drop MacPorts (also the MacPorts paths in `.zshenv` and `sysup`).
- [ ] **ifrit: environment secrets → 1Password** (migrate on ifrit). Pattern:
      - one template, e.g. `home/dot_local/sh/private_ifrit.secrets.zshenv.tmpl`
        (`private_` → 0600; the `*.zshenv` loader picks it up, and the
        existing `.local/sh/ifrit.*` ignore rule keeps it off other hosts);
      - each line `export FOO='{{ template "secret" (list .secrets "" "op://VAULT/ITEM/FIELD") }}'`,
        or iterate one item's fields (`onepassword "item"` → `.fields`);
      - add the target to the secrets block in `home/.chezmoiignore` so it's
        skipped, not failed, when `op` isn't signed in.
      - `secretRefs.sshConfig` is unused there (no private SSH hosts).

## Hyprland workspaces (shiva)

Named workspaces live in `home/dot_config/hypr/bindings.lua`.

- [ ] **Signal in `packages.yaml`:** installed by hand on shiva, so a fresh
      machine won't get it. Needs a desktop+personal package list first
      (`linux_personal` also reaches the dadfi server).
- [ ] **Visual overview (optional):** the useful part of OmniWM's overview,
      switching to a window by name, is done (`window-switcher`,
      SUPER+CTRL+SPACE). For a visual one: `yayuuu/hyprland-scroll-overview`
      (niri-style zoomed-out scroll view, Lua config) or a hyprexpo fork
      (hyprexpo left the official hyprland-plugins repo; `sandwichfarm/hyprexpo`
      tracks Hyprland 0.56). None search by typing. Plugins go through
      `hyprpm` (sudo, compiled against the running Hyprland) and need
      `hyprpm update` after every Hyprland bump in `omarchy update`.

## Decisions parked

- [ ] **Docker access** stays on `sudo docker`. Options and tradeoffs: README
      "Docker".
- [ ] **herdr handoff on Omarchy:** shiva keeps Omarchy's packaged herdr (no
      `--handoff`, restart after `omarchy update`). Switch to the official
      installer only if that becomes a pain.
- [ ] **`sysup` name:** looking for something snarkier.
