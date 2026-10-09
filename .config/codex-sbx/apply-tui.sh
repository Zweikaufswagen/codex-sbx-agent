
#!/usr/bin/env bash
set -euo pipefail

SANDBOX="${SBX_SANDBOX_NAME:?SBX_SANDBOX_NAME is not set}"
TUI_CONFIG="${HOME}/.config/codex-sbx/tui.toml"

# Validate host configuration
if [[ ! -f "$TUI_CONFIG" ]]; then
    echo "ERROR: TUI config not found: $TUI_CONFIG" >&2
    exit 1
fi

if ! command -v sbx >/dev/null 2>&1; then
    echo "ERROR: sbx CLI not found" >&2
    exit 1
fi

echo "Applying Codex TUI settings to: $SANDBOX"

# Copy configuration into the agent's writable directory
sbx cp "$TUI_CONFIG" \
    "${SANDBOX}:/home/agent/.codex/.tui-import.toml"

# Apply configuration inside the sandbox
sbx exec "$SANDBOX" bash -c '
    set -euo pipefail

    cfg="/home/agent/.codex/config.toml"
    tui="/home/agent/.codex/.tui-import.toml"
    tmp="${cfg}.tmp"

    if [[ ! -f "$cfg" ]]; then
        echo "ERROR: Codex config not found: $cfg" >&2
        exit 1
    fi

    if [[ ! -f "$tui" ]]; then
        echo "ERROR: TUI import not found: $tui" >&2
        exit 1
    fi

    # Remove existing [tui] section
    # Preserve all unrelated configuration
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
    '"'"' "$cfg" > "$tmp"

    # Append global TUI configuration
    printf "\n" >> "$tmp"
    cat "$tui" >> "$tmp"

    # Update original file while preserving its ownership
    cat "$tmp" > "$cfg"

    # Clean up temporary files
    rm -f "$tmp" "$tui"

    echo "Codex TUI settings applied successfully."
'
