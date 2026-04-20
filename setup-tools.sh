#!/bin/bash
set -e

echo "=== Vérification et installation des outils MSPR ==="

# ── Ansible ──────────────────────────────────────────────
if /home/wejo/.local/bin/ansible --version &>/dev/null || ansible --version &>/dev/null; then
  echo "[OK] Ansible déjà installé"
else
  echo "[...] Installation Ansible..."
  pip3 install ansible boto3 --break-system-packages
fi

# ── kubectl ───────────────────────────────────────────────
if kubectl version --client &>/dev/null; then
  echo "[OK] kubectl déjà installé"
else
  echo "[...] Installation kubectl..."
  sudo apt-get update -qq
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update -qq
  sudo apt-get install -y kubectl
  echo "[OK] kubectl installé"
fi

# ── Helm ─────────────────────────────────────────────────
if helm version --short &>/dev/null; then
  echo "[OK] Helm déjà installé"
else
  echo "[...] Installation Helm..."
  curl -fsSL -o /tmp/helm.tar.gz https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz
  tar -xzf /tmp/helm.tar.gz -C /tmp
  sudo mv /tmp/linux-amd64/helm /usr/local/bin/helm
  rm -f /tmp/helm.tar.gz
  echo "[OK] Helm installé"
fi

# ── Ansible collection kubernetes.core ───────────────────
if /home/wejo/.local/bin/ansible-galaxy collection list 2>/dev/null | grep -q kubernetes.core; then
  echo "[OK] Collection kubernetes.core déjà installée"
else
  echo "[...] Installation ansible collection kubernetes.core..."
  /home/wejo/.local/bin/ansible-galaxy collection install kubernetes.core
  echo "[OK] kubernetes.core installé"
fi

# ── PATH fix ~/.bashrc ────────────────────────────────────
if ! grep -q 'local/bin' ~/.bashrc; then
  echo 'export PATH=$PATH:/home/wejo/.local/bin' >> ~/.bashrc
fi

echo ""
echo "=== Résumé des versions ==="
ansible --version 2>/dev/null | head -1 || /home/wejo/.local/bin/ansible --version | head -1
kubectl version --client 2>/dev/null | head -1
helm version --short 2>/dev/null
terraform --version 2>/dev/null | head -1
aws --version 2>/dev/null
echo "=== Tout est prêt ! ==="
