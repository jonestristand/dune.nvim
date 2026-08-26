#!/usr/bin/env python3
# dune.nvim theme ${version} - GNOME Terminal profiles.
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
${profiles}
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
