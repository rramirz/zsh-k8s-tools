istio-label() {
  if [[ $# -lt 3 ]]; then
    echo "Usage: istio-label ambient <ns|deploy|ds|statefulset> <resourceName> --enable|--disable"
    return 1
  fi

  local mode="$1"
  local resourceType="$2"
  local resourceName="$3"
  local action="$4"
  local label_key="istio.io/dataplane-mode"
  local label_value="ambient"

  if [[ "$mode" != "ambient" ]]; then
    echo "Error: Only 'ambient' mode is supported."
    return 1
  fi

  if [[ "$action" != "--enable" && "$action" != "--disable" ]]; then
    echo "Error: The action must be either '--enable' or '--disable'."
    return 1
  fi

  case "$resourceType" in
    ns|namespace)
      if [[ "$action" == "--enable" ]]; then
        echo "Labeling namespace '$resourceName' with $label_key=$label_value"
        kubectl label namespace "$resourceName" "$label_key=$label_value" --overwrite
      else
        echo "Removing label from namespace '$resourceName'"
        kubectl label namespace "$resourceName" "$label_key-" --overwrite
      fi
      ;;
    
    deploy|deployment|ds|daemonset|statefulset)
      if [[ "$action" == "--enable" ]]; then
        echo "Patching $resourceType '$resourceName' to add pod label $label_key=$label_value"
        kubectl patch "$resourceType" "$resourceName" --type='merge' -p \
          "{\"spec\": {\"template\": {\"metadata\": {\"labels\": {\"$label_key\": \"$label_value\"}}}}}"
      else
        echo "Removing label from $resourceType '$resourceName'"
        kubectl patch "$resourceType" "$resourceName" --type='json' -p \
          "[{\"op\": \"remove\", \"path\": \"/spec/template/metadata/labels/istio.io~1dataplane-mode\"}]" || \
          echo "Label not found or already removed."
      fi
      ;;
    
    *)
      echo "Error: Unsupported resource type. Use 'ns', 'deploy', 'ds', or 'statefulset'."
      return 1
      ;;
  esac
}

