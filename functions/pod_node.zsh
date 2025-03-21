function pod_node() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: pod_node <pod-name>"
    return 1
  fi

  local pod_name="$1"
  local namespace

  # Get the current namespace from the context
  namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')

  # Default to 'default' namespace if none is set
  namespace=${namespace:-default}

  kubectl get pod "$pod_name" -n "$namespace" -o jsonpath='{.spec.nodeName}'
  echo
}

