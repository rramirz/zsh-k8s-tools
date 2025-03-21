deploy_sleep_pod() {
  local pod_name="sleep-pod"
  local service_account=""
  local namespace=""  #  current context namespace if none specified

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --name)
        pod_name="$2"
        shift 2
        ;;
      --sa)
        service_account="--serviceaccount=$2"
        shift 2
        ;;
      --namespace|-n)
        namespace="$2"
        shift 2
        ;;
      *)
        echo "Usage: deploy_sleep_pod [--name pod-name] [--sa service-account] [--namespace|-n namespace]"
        return 1
        ;;
    esac
  done

  kubectl run "$pod_name" \
    --image=debian:latest \
    --restart=Never \
    --namespace "$namespace" \
    --command -- sleep 43200 $service_account
    
  echo "Deployed pod: $pod_name"
  echo "Namespace: $namespace"
  echo "Pod will terminate after 12 hours"
  [[ -n "$service_account" ]] && echo "Attached service account: ${service_account#--serviceaccount=}"
}

exec_sleep_pod() {
  local pod_name="sleep-pod"
  local shell_cmd="sh"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --name)
        pod_name="$2"
        shift 2
        ;;
      *)
        shell_cmd="$1"
        shift
        ;;
    esac
  done

  kubectl exec -it "$pod_name" -- "$shell_cmd"
}

