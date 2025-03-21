# Ensure functions directory exists
if [[ ! -d "${0:h}/functions" ]]; then
  echo "Error: Missing functions directory"
  return 1
fi

# Load all functions
for f in "${0:h}/functions"/*.zsh; do
  source "$f"
done

# Set function path for autoloading (optional)
fpath=("${0:h}/functions" $fpath)
autoload -Uz "${0:h}/functions"/*(.:t)

echo "Loaded platform Zsh tools from ${0:h}"

