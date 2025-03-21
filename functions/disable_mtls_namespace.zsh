disable_mtls_namespace() {
  if [[ -z "$1" ]]; then
    echo "Usage: disable_mtls_namespace <namespace>"
    return 1
  fi

  local ns="$1"

  echo "Disabling mTLS for namespace: $ns"

  kubectl delete peerauthentication default -n "$ns" 2>/dev/null
  kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: disable-mtls
  namespace: $ns
spec:
  mtls:
    mode: DISABLE
EOF

  echo "mTLS is now disabled for namespace: $ns"
}

