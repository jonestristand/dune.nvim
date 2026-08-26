default: build

# regenerate the nvim files, everything under extras/, and README
build:
    nvim -l build/generate.lua

# fail (exit 1) if any generated file is out of date
check:
    nvim -l build/generate.lua --check

# Needs watchexec (pacman -S watchexec / brew install watchexec).
# rebuild whenever a source file changes (ctrl-c to stop)
watch:
    watchexec -w build -w lua/dune -- just build

# Checks the INDEX - what the commit will actually contain - not the working tree.
# install the pre-commit freshness check into .git/hooks
install-hooks:
    #!/usr/bin/env sh
    set -e
    cat > .git/hooks/pre-commit <<'HOOK'
    #!/bin/sh
    # verify generated files are fresh as STAGED (not as on disk)
    set -e
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    git checkout-index --prefix="$tmp/" -a
    cd "$tmp" && nvim -l build/generate.lua --check
    HOOK
    chmod +x .git/hooks/pre-commit
    echo "pre-commit hook installed"

# package the VS Code extension into a .vsix
vsix:
    cd extras/vscode/dune.nvim && npx @vscode/vsce package

# Refuses to run on a dirty tree so the release commit contains nothing
# but the bump. Afterwards: git push && git push --tags
# cut a release: bump the version (patch/minor/major or x.y.z), rebuild, commit, tag
bump level="patch":
    #!/usr/bin/env sh
    set -e
    if [ -n "$(git status --porcelain)" ]; then
        echo "working tree not clean - commit or stash first" >&2
        exit 1
    fi
    cur=$(cat VERSION)
    case "{{level}}" in
        major) new=$(echo "$cur" | awk -F. '{print $1+1".0.0"}') ;;
        minor) new=$(echo "$cur" | awk -F. '{print $1"."$2+1".0"}') ;;
        patch) new=$(echo "$cur" | awk -F. '{print $1"."$2"."$3+1}') ;;
        *) new="{{level}}" ;;
    esac
    echo "$new" > VERSION
    just build
    git add -A
    git commit -m "release v$new"
    git tag "v$new"
    echo "v$cur -> v$new. push with: git push && git push --tags"
