# Tableau Kanban — MSPR TPRE961

## Organisation du Kanban

**Colonnes** : `À faire` → `En cours` → `Revue Technique` → `Terminé`

**Règles de l'équipe** :
- **WIP limit** = 1 tâche par membre dans la colonne « En cours »
- Toute tâche passe obligatoirement par la **Revue Technique** (validation à deux yeux)
- **T-shirt sizing** : S (< 2h), M (2-4h), L (4-8h), XL (> 8h)
- Nomenclature : `[MISSION-X] Intitulé court`
- Priorité : 🔴 Haute · 🟠 Moyenne · 🟢 Basse

**Membres** :
- 🟦 Aurélien (Product Owner / Lead DevOps)
- 🟩 Loïc (Scrum Master / Infra)
- 🟨 Louis (Applicatif / QA)
- 👥 Équipe complète

---

## 1. Snapshot mi-projet (fin du Sprint 2 — infrastructure EKS provisionnée)

| À faire | En cours | Revue Technique | Terminé |
|---------|----------|-----------------|---------|
| `T-005` [M7] Playbook Ansible ingress + TLS — M 🟠 🟩 | `T-006` [M7] Déploiement Odoo via Ansible — L 🔴 🟨 | `T-004` [M5] Terraform EKS + Node Group — L 🔴 🟦 | `T-001` [M1] Choix distribution Kubernetes — S 🔴 🟦 |
| `T-007` [M7] Création auto DB Odoo — M 🟠 🟨 | `T-008` [Transverse] Makefile one-shot — S 🟠 🟩 | | `T-002` [M1] Validation partenariat AWS Academy — S 🔴 🟦 |
| `T-009` [M8] Rédaction dossier de rendu — XL 🔴 🟦 | | | `T-003` [M2] Rédaction Gantt prévisionnel — S 🔴 🟩 |
| `T-010` [M8] Support de soutenance — M 🔴 👥 | | | `T-004a` [M5] Terraform VPC + subnets — M 🔴 🟦 |
| `T-011` [M8] Schémas d'architecture Mermaid — M 🟠 🟦 | | | `T-004b` [M5] Terraform Outputs + tfvars — S 🟠 🟦 |

---

## 2. État final (fin du Sprint 5 — livraison)

### Colonne « À faire »

*Vide — tout le backlog priorisé est traité ou assumé hors périmètre.*

### Colonne « En cours »

*Vide — plus aucune tâche en développement.*

### Colonne « Revue Technique »

*Vide — toutes les tâches ont été validées en revue croisée.*

### Colonne « Terminé »

| # | Ticket | Mission | Taille | Assignee | Priorité |
|---|--------|---------|--------|----------|----------|
| 01 | [M1] Choix de la distribution Kubernetes (EKS vs K3s vs GKE) | 1 | S | 🟦 Aurélien | 🔴 |
| 02 | [M1] Validation du partenariat AWS Academy / tokens | 1 | S | 🟦 Aurélien | 🔴 |
| 03 | [M1] Choix des images Docker (Bitnami → officielles Docker Library) | 1 | S | 🟨 Louis | 🔴 |
| 04 | [M2] Rédaction du Gantt prévisionnel | 2 | S | 🟩 Loïc | 🔴 |
| 05 | [M2] Rédaction du contrat d'équipe + règles agiles | 2 | S | 🟩 Loïc | 🟠 |
| 06 | [M2] Rédaction de la procédure d'inclusion (handicap visuel) | 2 | M | 🟦 Aurélien | 🔴 |
| 07 | [M3] Mise en place du Kanban Kanboard | 3 | S | 🟩 Loïc | 🔴 |
| 08 | [M3] Cérémonies agiles hebdomadaires (daily, planning, retro) | 3 | Continu | 🟩 Loïc | 🔴 |
| 09 | [M5] Terraform — provider AWS + variables + tfvars | 5 | S | 🟦 Aurélien | 🔴 |
| 10 | [M5] Terraform — VPC + 2 subnets publics + IGW + route table | 5 | M | 🟦 Aurélien | 🔴 |
| 11 | [M5] Terraform — Cluster EKS + Node Group (2× t3.medium) | 5 | L | 🟦 Aurélien | 🔴 |
| 12 | [M5] Terraform — Outputs (endpoint, kubectl command) | 5 | S | 🟦 Aurélien | 🟠 |
| 13 | [M5] Tests idempotence : `terraform destroy && apply` (×4) | 5 | M | 🟦 Aurélien | 🔴 |
| 14 | [M7] Ansible — installation des dépendances (kubernetes.core) | 7 | S | 🟩 Loïc | 🔴 |
| 15 | [M7] Ansible — configuration kubectl via AWS EKS | 7 | S | 🟩 Loïc | 🔴 |
| 16 | [M7] Ansible — déploiement local-path-provisioner (StorageClass) | 7 | S | 🟩 Loïc | 🔴 |
| 17 | [M7] Ansible — ingress-nginx via Helm (module kubernetes.core.helm) | 7 | M | 🟩 Loïc | 🔴 |
| 18 | [M7] Ansible — attente du LoadBalancer AWS NLB | 7 | S | 🟩 Loïc | 🟠 |
| 19 | [M7] Ansible — déploiement PostgreSQL 16 (Secret + PVC + Deploy + Svc) | 7 | M | 🟨 Louis | 🔴 |
| 20 | [M7] Ansible — déploiement Odoo 17 (PVC + Deploy + Svc + ConfigMap) | 7 | L | 🟨 Louis | 🔴 |
| 21 | [M7] Ansible — génération du cert TLS auto-signé (openssl) | 7 | S | 🟩 Loïc | 🔴 |
| 22 | [M7] Ansible — Ingress HTTPS + annotation ssl-redirect | 7 | M | 🟩 Loïc | 🔴 |
| 23 | [M7] Ansible — création auto de la DB Odoo (POST /web/database/create) | 7 | M | 🟨 Louis | 🟠 |
| 24 | [M7] Ansible — export CREDENTIALS.txt à la racine du projet | 7 | S | 🟨 Louis | 🟠 |
| 25 | [Transverse] Pivot Bitnami → images officielles (post-mortem) | 7 | L | 👥 Équipe | 🔴 |
| 26 | [Transverse] Makefile one-shot deploy/destroy/status | - | M | 🟩 Loïc | 🟠 |
| 27 | [Transverse] Init Git + push GitHub | - | S | 🟦 Aurélien | 🔴 |
| 28 | [Transverse] Rédaction `.gitignore` (exclusion secrets, tfstate, credentials) | - | S | 🟦 Aurélien | 🔴 |
| 29 | [M8] Schémas d'architecture Mermaid (runtime + IaC + séquence) | 8 | M | 🟦 Aurélien | 🟠 |
| 30 | [M8] Rédaction du dossier de rendu final | 8 | XL | 🟦 Aurélien | 🔴 |
| 31 | [M8] Captures d'écran des éléments de preuve | 8 | S | 🟨 Louis | 🔴 |
| 32 | [M8] Support de soutenance (slides) | 8 | M | 👥 Équipe | 🔴 |
| 33 | [M8] Répétition de la soutenance | 8 | M | 👥 Équipe | 🔴 |

**Total tâches livrées** : 33 / 33 (100 %)

---

## 3. Tâches hors périmètre (volontairement non traitées)

Ces tâches ont été identifiées au backlog puis **écartées consciemment** avec justification documentée (cf. dossier §1.3) :

| # | Ticket | Raison |
|---|--------|--------|
| 90 | [M4] Packer — préparation d'AMI custom | AMIs EKS gérées par AWS |
| 91 | [M6] Ansible — bootstrap K3s/RKE2 baremetal | Control-plane managé par EKS |
| 92 | [Phase 2] Monitoring Prometheus + Grafana | Hors périmètre PoC |
| 93 | [Phase 2] Cert Let's Encrypt via cert-manager | Pas de DNS disponible pour le PoC |
| 94 | [Phase 2] Backup Velero + EBS snapshots | Phase production |
| 95 | [Phase 2] Horizontal Pod Autoscaler + Cluster Autoscaler | Phase production |
| 96 | [Phase 2] CI/CD GitHub Actions (`terraform validate`, `ansible-lint`) | Phase production |

---

## 4. Métriques de suivi

| Métrique | Valeur |
|----------|--------|
| Tickets créés | 40 |
| Tickets livrés | 33 |
| Tickets hors périmètre | 7 |
| **Taux de complétion du backlog** | **82,5 %** |
| **Taux de livraison du backlog priorisé** | **100 %** |
| Incidents majeurs | 0 |
| Post-mortems réalisés | 1 (pivot Bitnami) |
| Respect du budget horaire 19 h | ✅ |
| Déploiement « one-shot » reproductible | ✅ |

---

## 5. Import dans un outil Kanban visuel

### Import dans Kanboard (auto-hébergé)

Kanboard supporte l'import CSV. Voici le format :

```csv
title,status,owner_id,swimlane,category,color,priority,score,date_due
"[M1] Choix de la distribution Kubernetes",Terminé,aurelien,MSPR,Mission 1,blue,2,1,2026-04-07
"[M5] Terraform — Cluster EKS",Terminé,aurelien,MSPR,Mission 5,blue,3,5,2026-04-10
...
```

Sinon, la saisie manuelle des 33 tickets prend environ 20 minutes.

### Import dans GitHub Projects

1. Dans le dépôt `mspterra`, aller dans **Projects → New project** → type **Board**
2. Créer les 4 colonnes (À faire / En cours / Revue Technique / Terminé)
3. Convertir le tableau de la section 2 en Issues GitHub puis les glisser dans les colonnes

### Utilisation dans Trello

1. Créer un board avec les 4 colonnes
2. Importer via **Trello → Import** depuis ce markdown ou depuis un CSV
3. Les labels de mission (M1, M5, etc.) servent de catégories

---

## 6. Captures d'écran à produire pour le dossier

Pour la soutenance, prendre les captures suivantes de l'outil Kanban utilisé :

1. **Board global en fin de projet** (majorité des tickets en Terminé)
2. **Board en milieu de sprint** (tickets répartis entre toutes les colonnes)
3. **Zoom sur un ticket Mission 7** (avec description, commentaires de revue, checklist)
4. **Vue filtrée par assignee** (pour montrer l'équilibrage de charge)
5. **Burn-down chart** si l'outil le propose (évolution du nb de tickets ouverts)
