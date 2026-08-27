#!/usr/bin/env python3
# dune.nvim theme 0.2.2 - GNOME Terminal profiles.
# Generated from lua/dune/palettes.lua - do not edit by hand.
#
# Creates one GNOME Terminal profile per house. The UUIDs are fixed, so
# re-running updates the same profiles in place. Afterwards, pick a profile in
# Preferences -> Profiles (the default profile is not changed).
#
#   python3 install.py                install every house
#   python3 install.py dune-fremen    install only the named houses

import ast
import subprocess
import sys

PROFILES = {
    "dune-atreides": {
        "uuid": "a8c7ff56-0dbf-4cfc-86f4-ddc59c66935b",
        "display": "Dune Atreides",
        "bg": "#141B2A",
        "fg": "#EAD9B4",
        "cursor": "#EAD9B4",
        "selection": "#2C3B4D",
        "palette": ["#1E2938", "#CB6854", "#7FA871", "#DDB05E", "#649CD6", "#A188CC", "#8AC6BF", "#C9B58B", "#7C8899", "#CB6854", "#7FA871", "#DDB05E", "#649CD6", "#A188CC", "#8AC6BF", "#EAD9B4"],
    },
    "dune-harkonnen": {
        "uuid": "7795e815-84fe-49d9-99d8-786fc9abd7f6",
        "display": "Dune Harkonnen",
        "bg": "#111113",
        "fg": "#EEEDEA",
        "cursor": "#EEEDEA",
        "selection": "#29292E",
        "palette": ["#1B1B1E", "#D05837", "#7E8D80", "#C4AE62", "#7E99B4", "#A188CC", "#E4F1FF", "#C9C7C2", "#7E7D82", "#D05837", "#7E8D80", "#C4AE62", "#7E99B4", "#A188CC", "#E4F1FF", "#EEEDEA"],
    },
    "dune-corrino": {
        "uuid": "10e5618c-d90f-4597-ac31-44b2e5fdd0c7",
        "display": "Dune Corrino",
        "bg": "#1D1318",
        "fg": "#F2E2B8",
        "cursor": "#EFB63B",
        "selection": "#5A4526",
        "palette": ["#2A1C22", "#CE5B6B", "#99A75E", "#D4A63F", "#7290D9", "#A188CC", "#87A0AD", "#CFBC96", "#9A8781", "#CE5B6B", "#99A75E", "#D4A63F", "#7290D9", "#A188CC", "#87A0AD", "#F2E2B8"],
    },
    "dune-fremen": {
        "uuid": "9805b14b-1d91-4e99-8bb4-0951c0a59f1e",
        "display": "Dune Fremen",
        "bg": "#1B1710",
        "fg": "#E6D5A9",
        "cursor": "#E6D5A9",
        "selection": "#362E20",
        "palette": ["#272117", "#CC6341", "#98A967", "#D2A855", "#5D9BC8", "#A188CC", "#C9D2D4", "#C6B287", "#928463", "#CC6341", "#98A967", "#D2A855", "#5D9BC8", "#A188CC", "#C9D2D4", "#E6D5A9"],
    },
    "dune-tleilaxu": {
        "uuid": "3d85a4c4-6229-49d2-8754-10480d07646e",
        "display": "Dune Tleilaxu",
        "bg": "#131813",
        "fg": "#CDD5C2",
        "cursor": "#CDD5C2",
        "selection": "#283128",
        "palette": ["#1C241C", "#CC6055", "#7EA770", "#BDB47B", "#98BDB8", "#A188CC", "#85B7AE", "#A7B09B", "#788574", "#CC6055", "#7EA770", "#BDB47B", "#98BDB8", "#A188CC", "#85B7AE", "#CDD5C2"],
    },
}

LIST_SCHEMA = "org.gnome.Terminal.ProfilesList"
PROFILE_SCHEMA = (
    "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:%s/"
)


def gsettings(*args):
    return subprocess.check_output(("gsettings",) + args, text=True).strip()


def profile_list():
    raw = gsettings("get", LIST_SCHEMA, "list")
    if raw.startswith("@as"):  # typed empty list: "@as []"
        raw = raw[3:]
    return ast.literal_eval(raw)


def install(name, p):
    def set_key(key, value):
        gsettings("set", PROFILE_SCHEMA % p["uuid"], key, value)

    set_key("visible-name", p["display"])
    set_key("palette", str(p["palette"]))
    set_key("background-color", p["bg"])
    set_key("foreground-color", p["fg"])
    set_key("cursor-colors-set", "true")
    set_key("cursor-background-color", p["cursor"])
    set_key("cursor-foreground-color", p["bg"])
    set_key("highlight-colors-set", "true")
    set_key("highlight-background-color", p["selection"])
    set_key("highlight-foreground-color", p["fg"])
    set_key("use-theme-colors", "false")
    set_key("bold-is-bright", "false")


def main():
    names = sys.argv[1:] or list(PROFILES)
    unknown = [n for n in names if n not in PROFILES]
    if unknown:
        sys.exit("unknown house(s): %s\nvalid: %s"
                 % (", ".join(unknown), ", ".join(PROFILES)))
    for name in names:
        install(name, PROFILES[name])
        print("installed " + name)
    current = profile_list()
    missing = [PROFILES[n]["uuid"] for n in names
               if PROFILES[n]["uuid"] not in current]
    if missing:
        gsettings("set", LIST_SCHEMA, "list", str(current + missing))
    print("done - pick a profile under Preferences -> Profiles")


if __name__ == "__main__":
    main()
