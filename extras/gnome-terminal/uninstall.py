#!/usr/bin/env python3
# dune.nvim theme 0.2.0 - remove the GNOME Terminal profiles that
# install.py created. Generated from lua/dune/palettes.lua - do not edit
# by hand.
#
#   python3 uninstall.py                remove every house
#   python3 uninstall.py dune-fremen    remove only the named houses

import ast
import subprocess
import sys

UUIDS = {
    "dune-atreides": "a8c7ff56-0dbf-4cfc-86f4-ddc59c66935b",
    "dune-harkonnen": "7795e815-84fe-49d9-99d8-786fc9abd7f6",
    "dune-corrino": "10e5618c-d90f-4597-ac31-44b2e5fdd0c7",
    "dune-fremen": "9805b14b-1d91-4e99-8bb4-0951c0a59f1e",
    "dune-tleilaxu": "3d85a4c4-6229-49d2-8754-10480d07646e",
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


def main():
    names = sys.argv[1:] or list(UUIDS)
    unknown = [n for n in names if n not in UUIDS]
    if unknown:
        sys.exit("unknown house(s): %s\nvalid: %s"
                 % (", ".join(unknown), ", ".join(UUIDS)))
    targets = [UUIDS[n] for n in names]
    current = profile_list()
    for name in names:
        uuid = UUIDS[name]
        if uuid in current:
            gsettings("reset-recursively", PROFILE_SCHEMA % uuid)
            print("removed " + name)
    remaining = [u for u in current if u not in targets]
    gsettings("set", LIST_SCHEMA, "list", str(remaining))
    default = gsettings("get", LIST_SCHEMA, "default").strip("'")
    if default in targets:
        if remaining:
            gsettings("set", LIST_SCHEMA, "default", remaining[0])
            print("default profile was a dune house - now " + remaining[0])
        else:
            print("warning: no profiles left; GNOME Terminal will recreate "
                  "a default on next launch")


if __name__ == "__main__":
    main()
