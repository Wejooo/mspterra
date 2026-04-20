# Diagramme de Gantt — MSPR TPRE961

## Planning prévisionnel (durée totale : 19 h de préparation sur ~3 semaines)

```mermaid
gantt
    title MSPR TPRE961 — Infra EKS + Odoo (planning prévisionnel)
    dateFormat  YYYY-MM-DD
    axisFormat  %d/%m

    section Phase 1 — Cadrage
    Analyse du cahier des charges              :done,   a1, 2026-04-06, 1d
    Mission 1 · Choix technologiques           :done,   a2, after a1,  1d
    Mission 2 · Découpage tâches + Gantt       :done,   a3, after a2,  1d
    Mise en place Kanban (Mission 3)           :done,   a4, after a3,  1d

    section Phase 2 — Infrastructure
    Mission 5 · Terraform — VPC + subnets      :done,   b1, 2026-04-09, 1d
    Mission 5 · Terraform — Cluster EKS        :done,   b2, after b1,  1d
    Mission 5 · Terraform — Node Group         :done,   b3, after b2,  1d
    Tests & itérations (terraform destroy/apply):done,  b4, after b3,  1d

    section Phase 3 — Applicatif
    Mission 7 · Ansible — kubectl + storage    :done,   c1, 2026-04-13, 1d
    Mission 7 · Helm ingress-nginx + TLS       :done,   c2, after c1,  1d
    Mission 7 · PostgreSQL + Odoo              :done,   c3, after c2,  1d
    Mission 7 · Ingress + auto-création DB     :done,   c4, after c3,  1d
    Debug (images Bitnami, DB pré-existante)   :done,   c5, after c4,  1d

    section Phase 4 — Industrialisation
    Makefile (one-shot deploy/destroy)         :done,   d1, 2026-04-18, 1d
    Mise en place Git + push GitHub            :done,   d2, after d1,  1d
    Tests end-to-end du PRA                    :done,   d3, after d2,  1d

    section Phase 5 — Livrables
    Schémas d'architecture (Mermaid)           :active, e1, 2026-04-20, 1d
    Rédaction dossier de rendu                 :        e2, after e1,  3d
    Captures d'écran et preuves                :        e3, after e1,  1d
    Support de soutenance                      :        e4, after e2,  2d

    section Phase 6 — Soutenance
    Répétition générale                        :        f1, after e4,  1d
    Soutenance orale (50 min)                  :crit,   f2, after f1,  1d
```

---

## Répartition du temps par mission

```mermaid
pie title Répartition du temps (en heures)
    "Mission 1 — Choix technos"        : 1
    "Mission 2 — Organisation"         : 1
    "Mission 3 — Suivi Kanban (continu)" : 1
    "Mission 5 — Terraform"            : 4
    "Mission 7 — Ansible + Odoo"       : 6
    "Makefile + Git + tests PRA"       : 2
    "Mission 8 — Dossier de rendu"     : 3
    "Soutenance + préparation"         : 1
```

---

## Notes sur le planning

- **Mission 4 (Packer)** non réalisée : le choix d'AWS EKS (managé) rend Packer inutile car les AMIs des workers sont gérées par AWS.
- **Mission 6 (Ansible K8s baremetal)** non réalisée : le control-plane est managé par AWS EKS, aucun cluster à bootstrapper manuellement.
- **Jalon critique** : la disponibilité des tokens AWS Academy (4 h) a imposé des cycles `make destroy` / `make deploy` réguliers pour valider l'idempotence de l'IaC.
- **Imprévus gérés** :
  - Tags Bitnami supprimés de Docker Hub → pivot vers images officielles `odoo:17` et `postgres:16`
  - Initialisation automatique de la base via POST `/web/database/create` depuis Ansible
