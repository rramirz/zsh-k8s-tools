waypoint_label() {
  local resource_name waypoint ns

  # Usage message
  local usage="Usage: waypoint_label <ns|svc> <name> -w <waypoint-name> [-N <namespace>]
  
  Options:
    -w   Waypoint name to assign (required)
    -n   Namespace (optional, defaults to current context)
  "

  # Validate the first argument (must be ns or svc)
  if [[ $# -lt 2 ]]; then
    echo "$usage"
    return 1
  fi

  local resource_type="$1"
  local resource_name="$2"
  shift 2

  # Parse flags
  while getopts "w:n:" opt; do
    case "$opt" in
      w) waypoint="$OPTARG" ;;
      n) ns="$OPTARG" ;;
      *) echo "$usage"; return 1 ;;
    esac
  done

  # Ensure waypoint name is provided
  if [[ -z "$waypoint" ]]; then
    echo "Error: -w <waypoint-name> is required."
    echo "$usage"
    return 1
  fi

  # Set namespace if not provided
  ns="${ns:-$(kubectl config view --minify --output 'jsonpath={..namespace}')}"
  if [[ -z "$ns" ]]; then
    echo "No namespace provided and no default namespace set in context."
    return 1
  fi

  # Apply label based on resource type
  case "$resource_type" in
    ns)
      echo "Labeling namespace '$resource_name' with 'istio.io/use-waypoint=$waypoint'"
      kubectl label ns "$resource_name" "istio.io/use-waypoint=$waypoint" --overwrite
      ;;
    svc)
      echo "Labeling service '$resource_name' in namespace '$ns' with 'istio.io/use-waypoint=$waypoint'"
      kubectl label svc "$resource_name" -n "$ns" "istio.io/use-waypoint=$waypoint" --overwrite
      ;;
    *)
      echo "Invalid resource type: $resource_type. Use 'ns' or 'svc'."
      echo "$usage"
      return 1
      ;;
  esac
}
