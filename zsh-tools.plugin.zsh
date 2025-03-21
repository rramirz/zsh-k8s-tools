# Ensure functions directory exists
if [[ ! -d "${0:h}/functions" ]]; then
  return 1
fi

# Preserve existing prompt settings before loading functions
if [[ -z "$ORIGINAL_PROMPT" ]]; then
  ORIGINAL_PROMPT="$PROMPT"
fi

# Load all functions, but only if there are `.zsh` files
if compgen -G "${0:h}/functions/*.zsh" > /dev/null; then
  for f in "${0:h}/functions"/*.zsh; do
    source "$f"
  done
else
  echo "Warning: No Zsh function files found in ${0:h}/functions"
fi

# Set function path for autoloading (optional)
fpath=("${0:h}/functions" $fpath)
autoload -Uz "${0:h}/functions"/*(N.:t)  # `N` suppresses errors if no files match

# Restore original prompt after loading functions
PROMPT="$ORIGINAL_PROMPT"

