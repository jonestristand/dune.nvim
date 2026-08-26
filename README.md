<!-- Generated from build/generators.d/readme/README.md - edit that file, not this one. -->

<p align="center">
  <a href="https://dune-nvim.tdjones.ca"><img src="assets/banner.webp" alt="dune.nvim — Dune-inspired colourschemes for Neovim" width="880"/></a>
</p>

<p align="center">
  <a href="https://github.com/jonestristand/dune.nvim/actions/workflows/check.yml"><img alt="check" src="https://github.com/jonestristand/dune.nvim/actions/workflows/check.yml/badge.svg"/></a>
  <img alt="version" src="https://img.shields.io/badge/version-0.2.0-DDB05E"/>
  <a href="https://dune-nvim.tdjones.ca"><img alt="showcase site" src="https://img.shields.io/badge/showcase-dune--nvim.tdjones.ca-E5913A"/></a>
  <img alt="Neovim colourscheme" src="https://img.shields.io/badge/Neovim-colourscheme-649CD6?logo=neovim&logoColor=white"/>
  <a href="LICENSE"><img alt="MIT license" src="https://img.shields.io/badge/license-MIT-A188CC"/></a>
  <img alt="made in Canada" src="https://img.shields.io/badge/made%20in-Canada%20🍁-CB6854"/>
  <!-- classic-red variant: <img alt="made in Canada" src="https://img.shields.io/badge/made%20in-Canada%20🍁-D52B1E"/> -->
</p>

# The Dune.nvim Colourscheme Series

Four colourschemes from the Dune universe, each house rendered in the
light of its own world. Violet (`#A188CC`) appears in every
palette, because the Sisterhood operates in every corner of the
Imperium...

See every house side by side on the showcase site:
[dune-nvim.tdjones.ca](https://dune-nvim.tdjones.ca).

| House     | Home       | Character                          |
|-----------|-------------|------------------------------------|
| Atreides  | Caladan → Arrakis | cold sea, hot sand           |
| Harkonnen | Giedi Prime | colourless industry, furnace glow    |
| Corrino   | Kaitain     | porphyry and gold           |
| Fremen    | The sietch  | carved stone, hoarded water        |

# Ports

## Neovim

The repository root is the Neovim plugin (`colors/`, `lua/`). Install like any
colourscheme plugin (lazy.nvim):

```lua
{ "jonestristand/dune.nvim", name = "dune.nvim", priority = 1000 }
```

Then `:colorscheme dune-atreides` (or `dune-harkonnen`, `dune-corrino`,
`dune-fremen`). Each house registers as an ordinary colourscheme, so the
series browses and previews in any picker — such as 
[peacock.nvim](https://github.com/jonestristand/peacock.nvim).

Styled out of the box: treesitter, native LSP & diagnostics, `:terminal`,
nvim-cmp / blink.cmp, Telescope, the snacks.nvim picker, gitsigns,
which-key, lazy.nvim, mason, neo-tree, nvim-notify / noice, and
indent-blankline. Anything else falls back to Neovim's linked defaults.

### [peacock.nvim](https://github.com/jonestristand/peacock.nvim) Support

With peacock's self-describing-theme protocol, all five houses work
**zero-config**: each ships `lua/dune-<house>/peacock.lua`, which peacock's
harmony discovers automatically —

```lua
-- lua/dune-atreides/peacock.lua
return {
  palette = require("dune.palettes").atreides,
  mapping = require("dune.peacock_mapping"),
}
```

The shared mapping pins the slots that matter (base00→bg, base05→fg,
base08→err, base0b→str, base0d→fn, base0e→ty, ...) and lets closest-ΔE fill
the rest. On an older peacock without the protocol, add the equivalent
harmony entries in `opts` per the peacock.nvim documentation.


## Terminals (`extras/`)

Every terminal port shares the ANSI slot mapping in `lua/dune/ansi.lua`,
so `:terminal`, VS Code's integrated terminal, and these files all agree.
Swap `atreides` for any house.

### Ghostty (`extras/ghostty/`)

Copy the theme files into your ghostty themes directory (e.g.
`~/.config/ghostty/themes/`), then:

```
theme = dune-atreides
```

### kitty (`extras/kitty/`)

Copy a theme next to your `kitty.conf`, then:

```
include dune-atreides.conf
```

### Alacritty (`extras/alacritty/`)

Copy a theme into `~/.config/alacritty/`, then in `alacritty.toml`:

```toml
[general]
import = ["~/.config/alacritty/dune-atreides.toml"]
```

(On Alacritty ≤ 0.13, `import` is top-level instead of under `[general]`.)

### WezTerm (`extras/wezterm/`)

Copy a theme into `~/.config/wezterm/colors/`, then:

```lua
config.color_scheme = "dune-atreides"
```

### foot (`extras/foot/`)

Copy a theme into `~/.config/foot/`, then in `foot.ini`:

```ini
[main]
include=~/.config/foot/dune-atreides.ini
```

### Konsole (`extras/konsole/`)

Copy a scheme into `~/.local/share/konsole/`, then pick it under
Profile → Edit → Appearance. Pairs with the Plasma schemes below.

### Windows Terminal (`extras/windows-terminal/`)

Paste the file's contents into the `"schemes"` array of your
`settings.json`, then set the profile's `"colorScheme": "dune-atreides"`.

### iTerm2 (`extras/iterm2/`)

Settings → Profiles → Colors → Color Presets… → Import, choose
`dune-atreides.itermcolors`, then select it from the same menu.

### GNOME Terminal (`extras/gnome-terminal/`)

GNOME Terminal has no theme files (profiles live in dconf) so this port
is an installer (requires `gsettings` python library):

```
python3 extras/gnome-terminal/install.py
```

One profile per house/subtheme, under fixed UUIDs: re-running updates in place, 
and your own profiles are never touched. Pick a house under Preferences →
Profiles; `uninstall.py` removes them again. Pass house names to either
script to limit it (`install.py dune-fremen`).

## tmux (`extras/tmux/`)

Colours only — status style, pane borders, copy mode — no status-line
content, so your own layout survives:

```
source-file ~/.config/tmux/dune-atreides.conf
```

## KDE Plasma (`extras/kde/`)

Copy a scheme into your color-schemes directory, then pick it in System
Settings → Colors & Themes → Colors:

```
cp extras/kde/dune-atreides.colors ~/.local/share/color-schemes/
```

## VS Code (`extras/vscode/dune.nvim/`)

Install from the Visual Studio Code extension marketplace (or Open VSX for VSCodium),
or by copying it manually into your extensions directory:

```
cp -r extras/vscode/dune.nvim ~/.vscode/extensions/jonestristand.dune.nvim-0.1.0
```

## Building

`lua/dune/palettes.lua` is the source of truth for palette colours.
The per-house Neovim files (`colors/dune-<house>.lua`, `lua/dune-<house>/`),
everything under `extras/`, and this README are generated from it:

```
just build    # regenerate everything (nvim -l build/generate.lua)
just check    # fail if any generated file is stale
```

The showcase site ([dune-nvim.tdjones.ca](https://dune-nvim.tdjones.ca))
lives in its own repository at 
([dune.nvim-site](https://github.com/jonestristand/dune.nvim-site)),
which reads `lua/dune/palettes.lua` and `build/meta.lua` from a sibling
checkout of this repo (or fetches them from GitHub) and builds its file separately.

Generators live in `build/generators.d/` — either a bare script
(`ghostty.lua`, `nvim.lua`) or a `<name>/<name>.lua` directory with its
templates beside it (`kde/`, `readme/`, `vscode/`); `build/generate.lua`
runs every entry. Names, taglines, and role labels live in `build/meta.lua`. Run
`just install-hooks` once per clone to get a pre-commit freshness check. The 
GitHub CI runs the same check.

## Palette roles

Every palette exposes the same keys (`lua/dune/palettes.lua`): `bg_dim`, `bg`,
`surface`, `overlay`, `fg`, `fg_dim`, `muted`, `kw`, `num`, `str`, `fn`, `ty`,
`err`, `special`, `add`: handy for extending to other tools (fzf, lazygit)
from one source of truth. Simply drop a new generator into `build/generators.d/`!

## The houses

Four colourschemes, one series: **atreides** (the shoreline of two worlds),
**harkonnen** (the black sun), **corrino** (the golden lion throne), and
**fremen** (the desert hides its life). One colour crosses every palette
unchanged: `sisterhoodViolet #A188CC`, on types. It exists in the open desert 
as well, under the name `reverendViolet`.

There is no fifth theme. Do not load `dune-tleilaxu`. It does not exist,
and it will work perfectly.

## Artwork

The hero images on the [showcase site](https://dune-nvim.tdjones.ca) are
AI-generated. Drawing is not (remotely) a talent of mine, so each house's
artwork was generated from a prompt describing that house's identity and its
list of palette colours, then curated by hand. If anyone is interested in
submitting original artwork for the theme, I would very much welcome it.

## Palette capabilities

Optional keys a palette may set (the engine handles the rest):

- `bones = true` — keywords carried by weight (bold), not hue; in VS Code
  it also bolds constants and tags. Named for the
  [zenbones](https://github.com/zenbones-theme/zenbones.nvim) family, which
  made "bones" the shorthand for weight-led, hue-starved themes
- `kw_bold = true` — bold keywords without the rest of the bones contract
- `gilded = true` (+ `burnish = "#hex"`) — the accent metal owns operators,
  delimiters, constants, and the UI frame; search/folds/selection sink into
  burnish
- `ghola_fn`, `ghola_ty`, `ghola_op` — dim twins for call sites, builtin
  types, and punctuation: originals declare; gholas repeat
- `ansi = { yellow = "#hex", ... }` — terminal-only hue overrides by ANSI
  name (red/green/yellow/blue/magenta/cyan): TUIs read meaning in slot
  numbers, so a monochrome house may concede hue in the terminal
  (harkonnen's tarnished-brass yellow)

## Palettes

### Atreides — the shoreline of two worlds

| | colour | hex | role |
|:-:|---|---|---|
| ![](assets/swatches/0D121D.svg) | midnightSea | `#0D121D` | dim panels |
| ![](assets/swatches/141B2A.svg) | inkWater | `#141B2A` | editor bg |
| ![](assets/swatches/1E2938.svg) | swell | `#1E2938` | popups · panels |
| ![](assets/swatches/2C3B4D.svg) | reefShadow | `#2C3B4D` | selection · overlay |
| ![](assets/swatches/EAD9B4.svg) | crestSand | `#EAD9B4` | foreground |
| ![](assets/swatches/C9B58B.svg) | driftSand | `#C9B58B` | secondary fg |
| ![](assets/swatches/7C8899.svg) | seaMist | `#7C8899` | comments |
| ![](assets/swatches/E5913A.svg) | spice | `#E5913A` | keywords |
| ![](assets/swatches/DDB05E.svg) | melange | `#DDB05E` | numbers · constants · warnings |
| ![](assets/swatches/74B0A0.svg) | caladan | `#74B0A0` | strings |
| ![](assets/swatches/649CD6.svg) | deepCurrent | `#649CD6` | functions |
| ![](assets/swatches/A188CC.svg) | sisterhoodViolet | `#A188CC` | types · classes |
| ![](assets/swatches/CB6854.svg) | hawkRed | `#CB6854` | errors · exceptions |
| ![](assets/swatches/8AC6BF.svg) | foam | `#8AC6BF` | escapes · special |
| ![](assets/swatches/7FA871.svg) | bannerGreen | `#7FA871` | diff added |

### Harkonnen — under the black sun

| | colour | hex | role |
|:-:|---|---|---|
| ![](assets/swatches/0A0A0B.svg) | voidBlack | `#0A0A0B` | dim panels |
| ![](assets/swatches/111113.svg) | giediNight | `#111113` | editor bg |
| ![](assets/swatches/1B1B1E.svg) | machineShadow | `#1B1B1E` | popups · panels |
| ![](assets/swatches/29292E.svg) | furnaceSmoke | `#29292E` | selection · overlay |
| ![](assets/swatches/EEEDEA.svg) | harshLight | `#EEEDEA` | foreground |
| ![](assets/swatches/C9C7C2.svg) | ashDrift | `#C9C7C2` | secondary fg |
| ![](assets/swatches/7E7D82.svg) | smog | `#7E7D82` | comments |
| ![](assets/swatches/F4F3EF.svg) | glare | `#F4F3EF` | keywords |
| ![](assets/swatches/B4B2AC.svg) | pewter | `#B4B2AC` | numbers · constants · warnings |
| ![](assets/swatches/98968F.svg) | static | `#98968F` | strings |
| ![](assets/swatches/7E99B4.svg) | coolant | `#7E99B4` | functions |
| ![](assets/swatches/A188CC.svg) | sisterhoodViolet | `#A188CC` | types · classes |
| ![](assets/swatches/D05837.svg) | ember | `#D05837` | errors · exceptions |
| ![](assets/swatches/E4F1FF.svg) | arcLight | `#E4F1FF` | escapes · special |
| ![](assets/swatches/7E8D80.svg) | oxide | `#7E8D80` | diff added |

Keywords are **bold** (`bones`): weight, not hue.

### Corrino — the golden lion throne

| | colour | hex | role |
|:-:|---|---|---|
| ![](assets/swatches/150E12.svg) | porphyryDeep | `#150E12` | dim panels |
| ![](assets/swatches/1D1318.svg) | kaitainDusk | `#1D1318` | editor bg |
| ![](assets/swatches/2A1C22.svg) | marbleShadow | `#2A1C22` | popups · panels |
| ![](assets/swatches/3A2730.svg) | courtVeil | `#3A2730` | selection · overlay |
| ![](assets/swatches/F2E2B8.svg) | alabaster | `#F2E2B8` | foreground |
| ![](assets/swatches/CFBC96.svg) | agedMarble | `#CFBC96` | secondary fg |
| ![](assets/swatches/9A8781.svg) | courtier | `#9A8781` | comments |
| ![](assets/swatches/EFB63B.svg) | throneGold | `#EFB63B` | keywords |
| ![](assets/swatches/D4A63F.svg) | gilt | `#D4A63F` | numbers · constants · warnings |
| ![](assets/swatches/53A874.svg) | emerald | `#53A874` | strings |
| ![](assets/swatches/7290D9.svg) | sapphire | `#7290D9` | functions |
| ![](assets/swatches/A188CC.svg) | sisterhoodViolet | `#A188CC` | types · classes |
| ![](assets/swatches/CE5B6B.svg) | ruby | `#CE5B6B` | errors · exceptions |
| ![](assets/swatches/87A0AD.svg) | coldIron | `#87A0AD` | escapes · special |
| ![](assets/swatches/99A75E.svg) | laurel | `#99A75E` | diff added |
| ![](assets/swatches/5A4526.svg) | burnish | `#5A4526` | search glow · folds · selection |
| ![](assets/swatches/B99441.svg) | giltLeaf | `#B99441` | operators · punctuation |

Keywords are **bold gold** (`kw_bold` + `gilded`): the metal owns operators, constants, and the UI frame.

### Fremen — the desert hides its life

| | colour | hex | role |
|:-:|---|---|---|
| ![](assets/swatches/151109.svg) | openNight | `#151109` | dim panels |
| ![](assets/swatches/1B1710.svg) | duneside | `#1B1710` | editor bg |
| ![](assets/swatches/272117.svg) | leeward | `#272117` | popups · panels |
| ![](assets/swatches/362E20.svg) | windward | `#362E20` | selection · overlay |
| ![](assets/swatches/E6D5A9.svg) | moonlitSand | `#E6D5A9` | foreground |
| ![](assets/swatches/C6B287.svg) | wornSand | `#C6B287` | secondary fg |
| ![](assets/swatches/928463.svg) | dust | `#928463` | comments |
| ![](assets/swatches/E08A35.svg) | spiceThread | `#E08A35` | keywords |
| ![](assets/swatches/D2A855.svg) | duneGold | `#D2A855` | numbers · constants · warnings |
| ![](assets/swatches/7FAC7C.svg) | prophecyGreen | `#7FAC7C` | strings |
| ![](assets/swatches/5D9BC8.svg) | ibadBlue | `#5D9BC8` | functions |
| ![](assets/swatches/A188CC.svg) | reverendViolet | `#A188CC` | types · classes |
| ![](assets/swatches/CC6341.svg) | wormsign | `#CC6341` | errors · exceptions |
| ![](assets/swatches/C9D2D4.svg) | moonSilver | `#C9D2D4` | escapes · special |
| ![](assets/swatches/98A967.svg) | greening | `#98A967` | diff added |

### T̶l̶e̶i̶l̶a̶x̶u̶ — _[this section intentionally left blank]_

| | colour | hex | role |
|:-:|---|---|---|
| ![](assets/swatches/0D110D.svg) | sealedDark | `#0D110D` | dim panels |
| ![](assets/swatches/131813.svg) | warren | `#131813` | editor bg |
| ![](assets/swatches/1C241C.svg) | vatGlass | `#1C241C` | popups · panels |
| ![](assets/swatches/283128.svg) | membrane | `#283128` | selection · overlay |
| ![](assets/swatches/CDD5C2.svg) | pallor | `#CDD5C2` | foreground |
| ![](assets/swatches/A7B09B.svg) | fadedLinen | `#A7B09B` | secondary fg |
| ![](assets/swatches/788574.svg) | whisper | `#788574` | comments |
| ![](assets/swatches/DBD8B0.svg) | waxBone | `#DBD8B0` | keywords |
| ![](assets/swatches/BDB47B.svg) | oldBrass | `#BDB47B` | numbers · constants · warnings |
| ![](assets/swatches/8AB37D.svg) | axlotl | `#8AB37D` | strings |
| ![](assets/swatches/98BDB8.svg) | scalpel | `#98BDB8` | functions |
| ![](assets/swatches/A188CC.svg) | sisterhoodViolet | `#A188CC` | types · classes |
| ![](assets/swatches/CC6055.svg) | gholaRed | `#CC6055` | errors · exceptions |
| ![](assets/swatches/85B7AE.svg) | quicksilver | `#85B7AE` | escapes · special |
| ![](assets/swatches/7EA770.svg) | graft | `#7EA770` | diff added |
| ![](assets/swatches/999770.svg) | waxBone ghola | `#999770` | operators · punctuation |
| ![](assets/swatches/827A52.svg) | oldBrass ghola | `#827A52` | inactive UI |
| ![](assets/swatches/54754C.svg) | axlotl ghola | `#54754C` | inactive UI |
| ![](assets/swatches/628980.svg) | scalpel ghola | `#628980` | function call sites |
| ![](assets/swatches/7563A6.svg) | sisterhoodViolet ghola | `#7563A6` | builtin types |
| ![](assets/swatches/763A30.svg) | gholaRed ghola | `#763A30` | inactive UI |
| ![](assets/swatches/527A72.svg) | quicksilver ghola | `#527A72` | inactive UI |
| ![](assets/swatches/506D47.svg) | graft ghola | `#506D47` | inactive UI |

Keywords are **bold** (`bones`). Originals declare; gholas repeat. This table does not exist.

## License

[MIT](LICENSE).
