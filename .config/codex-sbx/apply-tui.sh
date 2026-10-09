
#!/usr/bin/env bash
set -euo pipefail

SANDBOX="${SBX_SANDBOX_NAME:?SBX_SANDBOX_NAME is not set}"
TUI_CONFIG="${HOME}/.config/codex-sbx/tui.toml"
TARGET_CONFIG="/home/agent/.codex/config.toml"

if [[ ! -f "$TUI_CONFIG" ]]; then
    echo "ERROR: TUI config not found: $TUI_CONFIG" >&2
    exit 1
fi

command -v sbx >/dev/null 2>&1 || {
    echo "ERROR: sbx CLI not found" >&2
    exit 1
}

echo "Applying Codex TUI settings to: $SANDBOX"

# Copy configuration into sandbox
sbx cp "$TUI_CONFIG" "${SANDBOX}:/tmp/codex-tui.toml"

# Apply configuration inside sandbox
sbx exec "$SANDBOX" bash -c '
    set -euo pipefail

    cfg="/home/agent/.codex/config.toml"
    tui="/tmp/codex-tui.toml"

    test -f "$cfg"
    test -f "$tui"

    # Replace existing [tui] section, if any.
    # Preserve all unrelated configuration.
    awk '"'"'
        /^\[tui\][[:space:]]*$/ {
            skip=1
            next
        }
        /^\[/ {
            skip=0
        }
        !skip {
            print
        }
    '"'"' "$cfg" > "${cfg}.tmp"

    printf "\n" >> "${cfg}.tmp"
    cat "$tui" >> "${cfg}.tmp"

    cat "${cfg}.tmp" > "$cfg"
    rm -f "${cfg}.tmp" "$tui"

    echo "Codex TUI settings applied successfully."
'
