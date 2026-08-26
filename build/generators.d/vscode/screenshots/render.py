#!/usr/bin/env python3
"""Render the marketplace screenshots into ../dune.nvim-site/public/vscode/.

The PNGs are hosted by the showcase site (committed there, served by
Cloudflare Pages) rather than in this repo, so plugin managers don't pull
them down with every Neovim install; the extension README references them
by absolute URL (https://dune-nvim.tdjones.ca/vscode/dune-<house>.png).
Neither repo's `just check` covers them. After changing
lua/dune/palettes.lua (or this script):

    python3 build/generators.d/vscode/screenshots/render.py
    # then commit and push dune.nvim-site

Requires a sibling checkout of dune.nvim-site (the same convention its
build uses to read this repo's palettes); without one, this errors out
rather than writing anywhere else. Needs nvim (palette dump) and
rsvg-convert. The SVG names locally installed fonts (MonoLisa, then
FiraCode Nerd Font / Noto Sans Mono), so a machine with different fonts
renders slightly different pixels - only re-render when the palettes or
the mockup actually change.
"""

import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
SITE = ROOT.parent / "dune.nvim-site"
OUT_DIR = SITE / "public" / "vscode"
FONT_STACK = "MonoLisa, FiraCode Nerd Font, Noto Sans Mono, monospace"

# geometry (logical px; rendered at --zoom 2)
W = 740
TITLE_H = 32
TAB_H = 34
LINE_H = 20
FONT_SIZE = 13
GUTTER_W = 54
CODE_PAD_X = 14
CODE_PAD_Y = 10
STATUS_H = 24
CURSOR_LINE = 17  # 1-based line the cursor sits on


def char_width() -> float:
    """Advance width of the first font in FONT_STACK at FONT_SIZE px."""
    try:
        from PIL import ImageFont

        file = subprocess.run(
            ["fc-match", "MonoLisa:style=Regular", "--format=%{file}"],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
        if "monolisa" not in file.lower():
            raise LookupError(file)
        return ImageFont.truetype(file, FONT_SIZE).getlength("M")
    except Exception:
        return FONT_SIZE * 0.6


def palettes() -> dict:
    out = subprocess.run(
        ["nvim", "-l", str(HERE / "dump.lua")],
        capture_output=True, text=True, check=True, cwd=ROOT,
    ).stdout
    return json.loads(out)


# one token: (role, text). Roles resolve to colour/weight/slant per house.
def sample(house: str, tagline: str) -> list[list[tuple[str, str]]]:
    return [
        [("c", f"# dune-{house} — {tagline}")],
        [("k", "from"), ("v", " arrakis "), ("k", "import"), ("v", " "),
         ("t", "Carryall"), ("p", ","), ("v", " wormsign")],
        [],
        [("C", "HARVEST_QUOTA"), ("v", " "), ("o", "="), ("n", " 0.82")],
        [("C", "BANNER"), ("v", " "), ("o", "="), ("v", " "),
         ("s", '"Arrakis '), ("e", "\\u2694"), ("s", " Dune "), ("e", "\\u2694"),
         ("s", ' Desert Planet"')],
        [],
        [("k", "class"), ("v", " "), ("t", "SpiceHarvester"), ("p", "("),
         ("t", "Carryall"), ("p", "):")],
        [("s", '    """Crawl the open sand and watch for wormsign."""')],
        [],
        [("v", "    "), ("k", "def"), ("v", " "), ("f", "__init__"), ("p", "("),
         ("v", "self"), ("p", ","), ("v", " "), ("P", "crew"), ("p", ":"),
         ("v", " "), ("T", "list"), ("p", "["), ("T", "str"), ("p", "],"),
         ("v", " "), ("P", "spice"), ("p", ":"), ("v", " "), ("T", "float"),
         ("v", " "), ("o", "="), ("v", " "), ("n", "0.0"), ("p", "):")],
        [("v", "        self"), ("p", "."), ("v", "crew "), ("o", "="),
         ("v", " "), ("P", "crew")],
        [("v", "        self"), ("p", "."), ("v", "spice "), ("o", "="),
         ("v", " "), ("P", "spice")],
        [],
        [("v", "    "), ("k", "def"), ("v", " "), ("f", "sweep"), ("p", "("),
         ("v", "self"), ("p", ","), ("v", " "), ("P", "dunes"), ("p", ":"),
         ("v", " "), ("T", "int"), ("p", ")"), ("v", " "), ("o", "->"),
         ("v", " "), ("T", "bool"), ("p", ":")],
        [("v", "        "), ("k", "for"), ("v", " dune "), ("k", "in"),
         ("v", " "), ("F", "range"), ("p", "("), ("P", "dunes"), ("p", "):")],
        [("v", "            reading "), ("o", "="), ("v", " wormsign"),
         ("p", "."), ("F", "sample"), ("p", "("), ("v", "dune"), ("p", ")"),
         ("v", " "), ("o", "*"), ("v", " "), ("C", "HARVEST_QUOTA")],
        [("v", "            "), ("k", "if"), ("v", " reading "), ("o", ">"),
         ("v", " self"), ("p", "."), ("v", "spice"), ("p", ":")],
        [("v", "                "), ("F", "print"), ("p", "("), ("k", "f"),
         ("s", '"wormsign! reading '), ("e", "{"), ("v", "reading"),
         ("e", ":.3f"), ("e", "}"), ("s", '"'), ("p", ")")],
        [("v", "                "), ("k", "return"), ("v", " "), ("C", "True")],
        [("v", "        self"), ("p", "."), ("v", "spice "), ("o", "+="),
         ("v", " "), ("C", "HARVEST_QUOTA")],
        [("v", "        "), ("k", "return"), ("v", " "), ("C", "False")],
    ]


def styles(c: dict) -> dict:
    """role -> (colour, bold, italic), mirroring the slot logic in vscode.lua."""
    bones = c.get("bones", False)
    gilded = c.get("gilded", False)
    kw_bold = bones or c.get("kw_bold", False)
    op = c.get("ghola_op") or (c.get("gilt_leaf") if gilded else c["fg_dim"])
    punct = c.get("ghola_op") or (c.get("gilt_leaf") if gilded else c["fg"])
    return {
        "c": (c["muted"], False, True),
        "k": (c["kw"], kw_bold, False),
        "s": (c["str"], False, False),
        "n": (c["num"], False, False),
        "C": (c["kw"] if gilded else c["num"], bones, False),
        "f": (c["fn"], False, False),
        "F": (c.get("ghola_fn") or c["fn"], False, False),
        "t": (c["ty"], False, False),
        "T": (c.get("ghola_ty") or c["ty"], False, True),
        "o": (op, False, False),
        "p": (punct, False, False),
        "v": (c["fg"], False, False),
        "P": (c["fg_dim"], False, True),
        "e": (c["special"], False, False),
    }


def esc(s: str) -> str:
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def render(house: str, meta: dict, c: dict, cw: float) -> str:
    tagline = meta["ghostty_comment"]
    lines = sample(house, tagline)
    style = styles(c)
    gilded = c.get("gilded", False)
    line_active = c["kw"] if gilded else c["num"]
    cursor = c["kw"] if gilded else c["fg"]
    statusbar_fg = c["num"] if gilded else c["fg_dim"]

    code_y = TITLE_H + TAB_H
    code_h = 2 * CODE_PAD_Y + LINE_H * len(lines)
    h = code_y + code_h + STATUS_H
    code_x = GUTTER_W + CODE_PAD_X
    ui_font = f'font-family="{FONT_STACK}"'

    p = []
    p.append(
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{h}" '
        f'viewBox="0 0 {W} {h}">'
    )
    p.append(
        f'<defs><clipPath id="win"><rect width="{W}" height="{h}" rx="10"/>'
        "</clipPath></defs>"
    )
    p.append(f'<g clip-path="url(#win)">')
    p.append(f'<rect width="{W}" height="{h}" fill="{c["bg"]}"/>')

    # title bar + tab strip
    p.append(f'<rect width="{W}" height="{TITLE_H + TAB_H}" fill="{c["bg_dim"]}"/>')
    for i, dot in enumerate((c["err"], c["num"], c["add"])):
        p.append(f'<circle cx="{22 + i * 18}" cy="{TITLE_H / 2}" r="5" fill="{dot}"/>')
    p.append(
        f'<text x="{W / 2}" y="{TITLE_H / 2 + 4}" text-anchor="middle" {ui_font} '
        f'font-size="11" fill="{c["fg_dim"]}">harvester.py — dune.nvim</text>'
    )
    # active tab (kw accent on top) and one inactive tab
    tab_w = 132
    p.append(
        f'<rect x="0" y="{TITLE_H}" width="{tab_w}" height="{TAB_H}" fill="{c["bg"]}"/>'
        f'<rect x="0" y="{TITLE_H}" width="{tab_w}" height="2" fill="{c["kw"]}"/>'
    )
    p.append(
        f'<text x="{tab_w / 2}" y="{TITLE_H + TAB_H / 2 + 4}" text-anchor="middle" '
        f'{ui_font} font-size="11.5" fill="{c["fg"]}">harvester.py</text>'
    )
    p.append(
        f'<text x="{tab_w + 66}" y="{TITLE_H + TAB_H / 2 + 4}" text-anchor="middle" '
        f'{ui_font} font-size="11.5" fill="{c["muted"]}">stillsuit.py</text>'
    )

    # cursor line highlight (editor.lineHighlightBackground = surface@80)
    cur_y = code_y + CODE_PAD_Y + (CURSOR_LINE - 1) * LINE_H
    p.append(
        f'<rect x="{GUTTER_W}" y="{cur_y}" width="{W - GUTTER_W}" height="{LINE_H}" '
        f'fill="{c["surface"]}" fill-opacity="0.8"/>'
    )

    # indent guides (editorIndentGuide = surface); blank lines bridge
    # their neighbours' guides the way VS Code draws them
    raw = ["".join(t for _, t in line) for line in lines]
    depth = [(len(t) - len(t.lstrip(" "))) // 4 if t.strip() else None for t in raw]

    def guide_depth(i: int) -> int:
        if depth[i] is not None:
            return depth[i]
        before = next((d for d in reversed(depth[:i]) if d is not None), 0)
        after = next((d for d in depth[i + 1:] if d is not None), 0)
        return min(before, after)

    for i in range(len(lines)):
        indent = guide_depth(i)
        y = code_y + CODE_PAD_Y + i * LINE_H
        for level in range(1, indent):
            gx = code_x + level * 4 * cw
            p.append(
                f'<rect x="{gx:.1f}" y="{y}" width="1" height="{LINE_H}" '
                f'fill="{c["surface"]}"/>'
            )

    # line numbers + code
    for i, line in enumerate(lines):
        n = i + 1
        y = code_y + CODE_PAD_Y + i * LINE_H + 14
        num_fill = line_active if n == CURSOR_LINE else c["muted"]
        p.append(
            f'<text x="{GUTTER_W - 14}" y="{y}" text-anchor="end" {ui_font} '
            f'font-size="{FONT_SIZE}" fill="{num_fill}">{n}</text>'
        )
        if not line:
            continue
        spans = []
        for role, text in line:
            fill, bold, italic = style[role]
            attrs = f' fill="{fill}"'
            if bold:
                attrs += ' font-weight="bold"'
            if italic:
                attrs += ' font-style="italic"'
            spans.append(f"<tspan{attrs}>{esc(text)}</tspan>")
        p.append(
            f'<text x="{code_x}" y="{y}" {ui_font} font-size="{FONT_SIZE}" '
            f'xml:space="preserve">{"".join(spans)}</text>'
        )

    # cursor at the end of its line
    cur_len = len("".join(t for _, t in lines[CURSOR_LINE - 1]))
    p.append(
        f'<rect x="{code_x + cur_len * cw:.1f}" y="{cur_y + 2}" width="2" '
        f'height="{LINE_H - 4}" fill="{cursor}"/>'
    )

    # status bar
    sy = h - STATUS_H
    p.append(f'<rect y="{sy}" width="{W}" height="{STATUS_H}" fill="{c["bg_dim"]}"/>')
    p.append(
        f'<text x="14" y="{sy + STATUS_H / 2 + 3.5}" {ui_font} font-size="10.5" '
        f'fill="{statusbar_fg}">main</text>'
    )
    p.append(
        f'<text x="{W - 14}" y="{sy + STATUS_H / 2 + 3.5}" text-anchor="end" '
        f'{ui_font} font-size="10.5" fill="{statusbar_fg}">'
        f'Ln {CURSOR_LINE}, Col {cur_len + 1}  Spaces: 4  UTF-8  '
        f'Python  {esc(meta["display"])}</text>'
    )

    p.append("</g>")
    p.append(f'<rect x="0.5" y="0.5" width="{W - 1}" height="{h - 1}" rx="10" '
             f'fill="none" stroke="{c["overlay"]}"/>')
    p.append("</svg>")
    return "\n".join(p)


def main() -> None:
    if not (SITE / "public").is_dir():
        sys.exit(
            f"error: {SITE}/public not found - screenshots are hosted by the\n"
            "showcase site, so a dune.nvim-site checkout must sit beside this\n"
            "repo. Refusing to write outside it; clone the site repo and re-run."
        )
    OUT_DIR.mkdir(exist_ok=True)
    data = palettes()
    cw = char_width()
    for house in data["house_order"]:
        svg = render(house, data["houses"][house], data["palettes"][house], cw)
        out = OUT_DIR / f"dune-{house}.png"
        subprocess.run(
            ["rsvg-convert", "--zoom", "2", "-o", str(out)],
            input=svg.encode(), check=True,
        )
        print(f"rendered {out.relative_to(SITE.parent)}")


if __name__ == "__main__":
    main()
