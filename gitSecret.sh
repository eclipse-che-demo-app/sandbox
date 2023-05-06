#!/usr/bin/env bash

CHE_NAMESPACE=""
GIT_PAT="hello"
GIT_PAT_CHK="goodbye"

GIT_PAT=$(yq e '."github.com".oauth_token' ~/.config/gh/hosts.yml | base64)
GIT_USER=$(yq e '."github.com".user' ~/.config/gh/hosts.yml)
CHE_USER=$(oc whoami)

cat << EOF | oc apply -f -
kind: Secret
apiVersion: v1
metadata:
  name: personal-access-token-${CHE_USER}
  namespace: ${DEVWORKSPACE_NAMESPACE}
  labels:
    app.kubernetes.io/component: scm-personal-access-token
    app.kubernetes.io/part-of: che.eclipse.org
  annotations:
    che.eclipse.org/che-userid: ${CHE_USER}
    che.eclipse.org/scm-personal-access-token-name: github
    che.eclipse.org/scm-url: https://github.com
    che.eclipse.org/scm-userid: ${GIT_USER}
data:
  token: ${GIT_PAT}
type: Opaque
EOF

GIT_PAT=""
GIT_PAT_CHK=""
GIT_USER=""
