SHELL := /bin/bash

CLUSTER_NAME := mspterra-eks
AWS_REGION   := us-east-1

TF_DIR       := terraform
ANS_DIR      := ansible

.PHONY: help deploy destroy status credentials plan init check-aws clean

help:
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║           MSPR TPRE961 - Odoo sur EKS AWS                  ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Cibles disponibles :"
	@echo "  make deploy       → Déploie toute l'infrastructure (Terraform + Ansible)"
	@echo "  make destroy      → Détruit toutes les ressources AWS"
	@echo "  make status       → Affiche l'état du cluster et des pods"
	@echo "  make credentials  → Affiche le fichier CREDENTIALS.txt"
	@echo "  make plan         → Terraform plan (dry-run)"
	@echo "  make check-aws    → Vérifie la validité des credentials AWS"
	@echo "  make clean        → Nettoie les fichiers locaux Terraform"

check-aws:
	@echo "→ Vérification des credentials AWS..."
	@aws sts get-caller-identity --output table 2>/dev/null \
		|| (echo "✗ ERREUR: credentials AWS invalides ou expirés"; \
		    echo "  Mettez à jour ~/.aws/credentials avec de nouveaux tokens AWS Academy"; \
		    exit 1)

init:
	@echo "→ Terraform init..."
	cd $(TF_DIR) && terraform init

plan: init
	cd $(TF_DIR) && terraform plan

deploy: check-aws init
	@echo ""
	@echo "════════════════════════════════════════════════════════════"
	@echo "  [1/3] Terraform apply — création VPC + cluster EKS"
	@echo "════════════════════════════════════════════════════════════"
	cd $(TF_DIR) && terraform apply -auto-approve
	@echo ""
	@echo "════════════════════════════════════════════════════════════"
	@echo "  [2/3] Configuration de kubectl"
	@echo "════════════════════════════════════════════════════════════"
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(CLUSTER_NAME)
	kubectl get nodes -o wide
	@echo ""
	@echo "════════════════════════════════════════════════════════════"
	@echo "  [3/3] Ansible — déploiement Odoo + ingress + TLS"
	@echo "════════════════════════════════════════════════════════════"
	cd $(ANS_DIR) && ansible-playbook playbooks/02-deploy-odoo.yml
	@echo ""
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║              DÉPLOIEMENT TERMINÉ AVEC SUCCÈS               ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@cat CREDENTIALS.txt 2>/dev/null || true

destroy: check-aws
	@echo "⚠  Suppression de toutes les ressources AWS..."
	@echo "→ Suppression des namespaces Kubernetes..."
	-kubectl delete namespace odoo --ignore-not-found --timeout=60s
	-kubectl delete namespace ingress-nginx --ignore-not-found --timeout=120s
	@echo "→ Terraform destroy..."
	cd $(TF_DIR) && terraform destroy -auto-approve
	@rm -f CREDENTIALS.txt /tmp/odoo-tls.crt /tmp/odoo-tls.key
	@echo "✓ Ressources détruites."

status:
	@echo "═══ Nodes ═══"
	@kubectl get nodes -o wide 2>/dev/null || echo "kubectl non configuré"
	@echo ""
	@echo "═══ Pods (tous namespaces) ═══"
	@kubectl get pods -A 2>/dev/null || echo "kubectl non configuré"
	@echo ""
	@echo "═══ Ingress ═══"
	@kubectl get ingress -A 2>/dev/null || echo "kubectl non configuré"
	@echo ""
	@echo "═══ Services LoadBalancer ═══"
	@kubectl get svc -A --field-selector spec.type=LoadBalancer 2>/dev/null || echo "kubectl non configuré"

credentials:
	@cat CREDENTIALS.txt 2>/dev/null || echo "Fichier CREDENTIALS.txt non trouvé — lance 'make deploy' d'abord"

clean:
	@echo "→ Nettoyage des fichiers Terraform locaux..."
	rm -rf $(TF_DIR)/.terraform
	rm -f $(TF_DIR)/.terraform.lock.hcl
	@echo "✓ Fichiers locaux nettoyés (state Terraform conservé)"
