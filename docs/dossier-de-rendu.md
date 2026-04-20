# Dossier de rendu — MSPR TPRE961

**Titre** : Gérer un projet d'infrastructures virtualisées selon les principes agile dans un environnement multiculturel

**Bloc de compétences** : Bloc 2 — Manager un projet informatique avec agilité en collaboration avec les parties prenantes

**Certification** : Expert en Informatique et Système d'Information (RNCP35584)

**École** : EPSI

**Équipe projet** :

| Membre | Rôle principal |
|--------|---------------|
| Aurélien Remy | Product Owner & Lead DevOps |
| Loïc *Nom* | Scrum Master & Ingénieur Infrastructure |
| Louis *Nom* | Ingénieur Applicatif & Quality Assurance |

**Client (fictif)** : COGIP (COnglomérat Général d'Informatique Professionnelle) — pour le compte de Tesker (constructeur de véhicules électriques)

**Prestataire (nous)** : équipe technico-commerciale ayant remporté l'appel d'offres

**Date de rendu** : avril 2026

**Repository Git** : https://github.com/<compte>/mspterra

---

## Sommaire

1. [Introduction](#1-introduction)
2. [Partie 1 — Pilotage du projet agile](#2-pilotage-du-projet-agile)
3. [Partie 2 — Management d'équipe, inclusion et communication](#3-management-déquipe-inclusion-et-communication)
4. [Partie 3 — Cahiers des charges fonctionnel et technique](#4-cahiers-des-charges)
5. [Partie 4 — Pilotage des prestataires externes](#5-pilotage-des-prestataires-externes)
6. [Partie 5 — Réalisation technique (synthèse)](#6-réalisation-technique-synthèse)
7. [Partie 6 — Tableau de bord et suivi de performance](#7-tableau-de-bord-et-suivi-de-performance)
8. [Partie 7 — Plan de Reprise d'Activité](#8-plan-de-reprise-dactivité-pra)
9. [Partie 8 — Bilan et amélioration continue](#9-bilan-et-amélioration-continue)
10. [Conclusion](#10-conclusion)
11. [Annexes](#11-annexes)

---

## 1. Introduction

### 1.1 Contexte du projet

La société **COGIP** est une entreprise de développement informatique spécialisée dans les logiciels de gestion d'entreprise (ERP). Elle vient de décrocher un contrat majeur avec le groupe **Tesker**, fabricant de véhicules électriques grand public en forte croissance.

COGIP ne souhaite pas gérer elle-même l'infrastructure d'hébergement : elle préfère se concentrer sur le développement de son produit logiciel. Elle a donc lancé un appel d'offres pour la mise en place d'une infrastructure :

- **évolutive** (capacité à absorber la montée en charge),
- **performante**,
- **flexible** (capacité à déployer de nouvelles versions rapidement),
- **résiliente aux pannes**,
- **reproductible** (l'Infrastructure as Code est exigée pour permettre un PRA — Plan de Reprise d'Activité).

Notre équipe technico-commerciale a remporté cet appel d'offres. Il nous incombe à présent de livrer un **Proof of Concept (PoC)** démontrant la faisabilité et la valeur de la solution proposée.

### 1.2 Enjeux

**Enjeu technique** : prouver qu'une infrastructure Kubernetes basée sur AWS EKS peut héberger l'ERP **Odoo** de manière fiable, avec un déploiement entièrement automatisé (IaC), reproductible à volonté.

**Enjeu projet** : démontrer notre capacité à piloter un projet informatique en **méthode agile**, avec une équipe réduite (3 ingénieurs), en respectant un budget-temps contraint (19 heures de préparation) et en gérant un environnement de travail qui privilégie **l'inclusivité** et la **communication asynchrone**.

**Enjeu commercial** : valider le dimensionnement technique et la méthodologie afin de préparer la phase de production avec COGIP.

### 1.3 Périmètre du PoC

Ce qui est **inclus** dans le PoC :
- Provisionnement d'un cluster Kubernetes managé sur AWS (EKS)
- Déploiement automatisé d'Odoo (base + ingress + TLS + base de données initialisée)
- Outillage Infrastructure as Code : Terraform + Ansible + Helm
- Dispositif de suivi de projet agile (Kanban, Gantt)
- Documentation livrable clé en main (ce dossier + le dépôt Git)

Ce qui est **exclu** du PoC (hors périmètre volontairement) :
- Intégration du dépôt de conteneurs propriétaire COGIP (non fourni)
- Monitoring avancé (Prometheus/Grafana) — à prévoir en phase 2
- Haute disponibilité du control-plane (déjà assurée par EKS, mais non validée par tests de chaos)
- Certificat TLS signé par une autorité publique (Let's Encrypt) — auto-signé accepté par le cahier des charges

### 1.4 Livrables attendus

| Livrable | Réalisation |
|----------|-------------|
| Dépôt Git versionné (Terraform + Ansible) | ✅ |
| Diagramme de Gantt | ✅ [docs/gantt.md](./gantt.md) |
| Tableau Kanban de suivi | ✅ (captures en annexe) |
| Schémas d'architecture | ✅ [docs/architecture.md](./architecture.md) |
| Dossier de rendu final | ✅ (ce document) |
| Démonstration du cluster opérationnel | ✅ (soutenance) |
| Fichier CREDENTIALS.txt généré à la volée | ✅ |
| Makefile « one-shot » pour reproductibilité | ✅ |

---

## 2. Pilotage du projet agile

### 2.1 Choix de la méthodologie : Scrum allégé

Pour un projet de 19 h avec une équipe de 3 personnes, nous avons retenu **Scrum en version allégée** :

- **Itérations courtes** (sprints de 3 à 4 jours) pour permettre des ajustements rapides
- **Backlog produit** maintenu par le Product Owner (Aurélien), priorisé en fonction de la valeur livrée au client
- **Tableau Kanban** visuel pour le suivi opérationnel (À faire → En cours → Revue Technique → Terminé)
- **Rituels** adaptés à la taille de l'équipe (voir §2.3)

Le sujet impose 6 phases distinctes (cadrage → livrables). Nous avons calqué nos sprints sur ces phases pour garantir la cohérence avec les attendus pédagogiques.

### 2.2 Rôles dans l'équipe Scrum

| Rôle Scrum | Titulaire | Missions |
|------------|-----------|----------|
| **Product Owner** | Aurélien | Expression des besoins, priorisation du backlog, validation des livrables, interface avec le « client » (simulation COGIP), décisions sur le périmètre |
| **Scrum Master** | Loïc | Facilitation des rituels, levée des obstacles, animation du Kanban, suivi des engagements de sprint, médiation |
| **Équipe de développement** | Loïc + Louis + Aurélien | Réalisation technique (chacun est dev + son rôle Scrum) |

Dans une équipe aussi réduite, la séparation stricte des rôles n'est pas tenable : chaque membre est aussi développeur. **Ce point est explicité dans le contrat d'équipe** afin d'éviter les confusions de responsabilité.

### 2.3 Rituels agiles adoptés

| Rituel | Fréquence | Durée | Format |
|--------|-----------|-------|--------|
| **Daily stand-up** | Chaque jour travaillé | 10 min | Discord — vocal ou écrit async si membre absent |
| **Sprint Planning** | Début de chaque sprint | 30 min | Discord + Kanban partagé |
| **Sprint Review** | Fin de sprint | 20 min | Démo technique + validation PO |
| **Rétrospective** | Fin de sprint | 20 min | Tableau « what went well / what to improve » |
| **Backlog Refinement** | 1× par sprint | 15 min | Async dans Discord (#backlog) |

### 2.4 Outils de gestion de projet

**Le choix s'est porté sur des outils gratuits, adaptés à une équipe distribuée :**

| Outil | Usage |
|-------|-------|
| **Kanboard** (auto-hébergé) | Tableau Kanban principal — chaque tâche a un assignee, une durée estimée, une priorité |
| **Discord** | Communication temps réel (vocal + texte) + channels dédiés (#general, #dev, #blocage, #cr-daily) |
| **GitHub** | Versioning du code + PR pour la revue technique + Issues liées aux tickets Kanboard |
| **Google Drive** | Stockage des livrables (CR, dossier de rendu, screenshots) |
| **Miro** (version gratuite) | Schémas d'architecture collaboratifs en début de projet |

### 2.5 Diagramme de Gantt prévisionnel

Le planning complet est détaillé dans [docs/gantt.md](./gantt.md). Voici la synthèse des phases :

| Phase | Durée | Livrables clés |
|-------|-------|----------------|
| Phase 1 — Cadrage | 4 jours | Choix techno, Gantt, Kanban initialisé |
| Phase 2 — Infrastructure | 4 jours | Cluster EKS opérationnel via Terraform |
| Phase 3 — Applicatif | 5 jours | Odoo accessible via HTTPS |
| Phase 4 — Industrialisation | 3 jours | Makefile, tests PRA, push GitHub |
| Phase 5 — Livrables | 4 jours | Dossier de rendu, schémas, support |
| Phase 6 — Soutenance | 2 jours | Répétition + passage |

### 2.6 Tableau Kanban et suivi

Le tableau Kanban structure les tâches en **4 colonnes** :

1. **À faire** — tâches priorisées dans le backlog, non entamées
2. **En cours** — tâches en développement (limite WIP : 1 par membre)
3. **Revue technique** — tâches achevées, en attente de validation pair
4. **Terminé** — tâches validées et mergées dans `main`

**Règles d'équipe** :
- Toute tâche doit passer par la colonne « Revue Technique » avant d'être marquée Terminée. C'est une **revue à deux yeux** qui permet d'attraper des erreurs humaines (secret commité, typo, oubli).
- La **limite WIP** (Work In Progress) est fixée à **1 tâche par personne simultanément**, pour limiter le context-switching.
- Chaque tâche est estimée en **T-shirt sizing** (S/M/L) pour une estimation rapide sans débats.

**Nomenclature des tickets** : `[MISSION-X] Intitulé court` — permet de relier chaque ticket à une mission du cahier des charges.

### 2.7 Backlog initial (extrait)

| ID | Intitulé | Mission | Taille | Assignee | Priorité |
|----|----------|---------|--------|----------|----------|
| T-001 | Choix de la distribution Kubernetes | M1 | S | Aurélien | Haute |
| T-002 | Validation des partenariats cloud campus (AWS Academy) | M1 | S | Aurélien | Haute |
| T-003 | Rédaction du Gantt prévisionnel | M2 | S | Loïc | Haute |
| T-004 | Écriture des recettes Terraform VPC/EKS | M5 | L | Aurélien | Haute |
| T-005 | Écriture du playbook Ansible ingress + TLS | M7 | M | Loïc | Haute |
| T-006 | Déploiement Odoo via Ansible | M7 | L | Louis | Haute |
| T-007 | Création auto de la base Odoo (POST /web/database/create) | M7 | M | Louis | Moyenne |
| T-008 | Makefile de déploiement « one-shot » | Transverse | S | Loïc | Moyenne |
| T-009 | Rédaction du dossier de rendu | M8 | XL | Aurélien | Haute |
| T-010 | Support de soutenance (slides) | M8 | M | Aurélien+Loïc+Louis | Haute |

---

## 3. Management d'équipe, inclusion et communication

### 3.1 Composition réelle de l'équipe

Notre équipe est composée de **3 apprenants EPSI** :

- Tous **francophones**, tous **issus du même cursus**,
- Aucun membre en situation de handicap déclaré,
- Travail en **hybride** : alternance présentiel (campus EPSI) et distanciel (domicile).

Cette homogénéité apparente ne dispense pas de l'obligation — pédagogique et professionnelle — de **formaliser des politiques d'inclusion et de communication**. Ces politiques ont deux objectifs :

1. Garantir un climat de travail respectueux au sein de l'équipe actuelle ;
2. Préparer l'équipe à accueillir un nouveau membre en cours de projet sans friction (mutation, renfort, stagiaire, apprenti en situation de handicap).

### 3.2 Environnement de travail inclusif — cadre général

Nous avons formalisé un **contrat d'équipe** (adopté au sprint 0) avec les principes suivants :

- **Écoute active** : toute prise de parole en réunion est respectée jusqu'à sa fin.
- **Droit à la déconnexion** : pas de message Discord attendu en dehors des heures ouvrées (09h-19h).
- **Zéro jugement technique** : les questions « stupides » n'existent pas — elles sont la meilleure façon d'apprendre et de détecter des angles morts.
- **Reconnaissance** : chaque fin de sprint, un tour de table « kudos » pour remercier un pair d'un coup de main.
- **Décision à l'unanimité** sur les choix structurants (techno, architecture) ; vote majoritaire sur les choix tactiques.

### 3.3 Accueil d'un nouveau membre en situation de handicap — cas d'école

Conformément à la compétence attendue, nous avons rédigé une **procédure d'accueil** applicable si un collaborateur en situation de handicap rejoignait l'équipe en cours de projet.

**Cas traité : arrivée d'un développeur en situation de déficience visuelle (malvoyance)**

**Étape 1 — Entretien d'accueil avec le référent handicap EPSI**
- Identifier les besoins spécifiques (logiciels de grossissement, lecteur d'écran, luminosité, fréquence de pause…)
- Définir avec la personne concernée le **niveau de divulgation** souhaité au reste de l'équipe
- Formaliser les aménagements avec la DRH fictive de l'entreprise

**Étape 2 — Adaptations techniques immédiates**

| Domaine | Action |
|---------|--------|
| **Poste de travail** | Double écran 27", un pour le code en grande police, un pour la documentation. Clavier ergonomique rétroéclairé. |
| **IDE** | VS Code avec thèmes à fort contraste + extension « Accessibility Audit » + police OpenDyslexic si besoin |
| **Lecteur d'écran** | Compatibilité NVDA (Windows) ou VoiceOver (macOS) — tous nos écrits Markdown sont structurés avec titres Hn pour navigation au clavier |
| **Réunions** | Toute présentation partagée est envoyée en amont pour lecture à son propre rythme |
| **Documentation** | Diagrammes toujours accompagnés d'une **description textuelle** (alt-text) reprenant le contenu du schéma |

**Étape 3 — Adaptations organisationnelles**

| Mesure | Pourquoi |
|--------|----------|
| Réunions en **vocal prioritaire** plutôt qu'écrites (quand possible) | Moins fatigant visuellement |
| **Pauses oculaires** systématiques toutes les 45 min (règle 20-20-20) | Prévention de la fatigue visuelle |
| Pair programming **audio-first** : on décrit verbalement ce qu'on fait | La personne suit sans avoir à scruter l'écran |
| **Revue de code asynchrone privilégiée** sur GitHub | La personne peut prendre le temps de lire à son rythme |
| Daily stand-up en **vocal Discord** (pas en texte) | Moins d'effort de lecture |

**Étape 4 — Adaptation de la charge de travail**

La charge ne doit **pas** être diminuée systématiquement, ce serait contre-productif et paternaliste. En revanche :
- Les tâches impliquant beaucoup de lecture documentaire (cahiers des charges, RFC) sont **co-traitées en binôme**.
- Les rendez-vous client sont **systématiquement enregistrés** avec consentement, et un résumé écrit est envoyé dans les 24h.

**Étape 5 — Revue périodique**
- À chaque fin de sprint, un **entretien individuel** avec le Scrum Master pour ajuster les accommodations si besoin.
- À la fin du projet, un retour formel avec le référent handicap EPSI.

> Cette procédure a été discutée en équipe et archivée dans `/docs/accueil-inclusion.md` du dépôt projet (exercice de formalisation — le fichier n'est pas livré ici). En situation réelle, elle serait élaborée en co-construction avec le membre concerné et le référent handicap.

### 3.4 Stratégies applicables à d'autres types de handicaps

Par souci de complétude, notre cadre d'accueil prévoit également :

| Type de handicap | Adaptations principales |
|------------------|-------------------------|
| **Auditif** (surdité, malentendance) | Sous-titres automatiques Discord / Google Meet activés. Prise de notes écrite systématique. Canaux texte prioritaires. |
| **Psychomoteur** | Pauses fréquentes, charge de tâches simultanées réduite, clavier ergonomique, reconnaissance vocale pour frapper du code (Dragon, Talon Voice) |
| **Cognitif** (dyslexie, TDAH) | Supports en police OpenDyslexic, listes à puces courtes, répétition orale des consignes, rappels écrits |
| **Psychique** | Souplesse des horaires, droit à la pause spontanée, priorisation du bien-être sur le respect strict du Gantt |

### 3.5 Communication multiculturelle — posture adoptée

Notre équipe étant francophone homogène, **l'enjeu multiculturel ne se pose pas directement** en interne. En revanche, nous l'avons anticipé sur deux axes :

**Axe 1 — Relation client (COGIP fictif, Tesker)**
Tesker est un groupe international. Nos communications de reporting produit intègrent :
- Un **résumé exécutif en anglais** systématique pour tout rapport client
- Des horaires de réunion tenant compte du **fuseau client** (règle : ne jamais imposer une réunion avant 09h ou après 18h heure du client)
- Des **références culturelles neutres** (pas d'humour local, pas de références sportives francophones, pas d'expressions idiomatiques)

**Axe 2 — Accueil d'un membre non-francophone**
Si l'équipe s'élargissait à un membre anglophone ou hispanophone :
- **Langue commune : anglais** pour tous les écrits professionnels (code, commits, PR, tickets Kanban)
- **Réunions bilingues** : animation en français avec résumé anglais en fin de réunion (et vice-versa)
- **Glossaire partagé** des termes techniques FR/EN maintenu dans le dépôt Git

### 3.6 Travail à distance et télétravail

#### 3.6.1 Organisation hybride actuelle

L'équipe alterne entre :
- **Campus EPSI** (2 jours/semaine en moyenne) : sessions de travail groupé, soutenances intermédiaires
- **Domicile** (3 jours/semaine) : développement autonome, réunions à distance

#### 3.6.2 Outils numériques mis en place

| Outil | Usage | Pourquoi ce choix |
|-------|-------|-------------------|
| **Discord** | Chat texte + vocal permanent | Gratuit, serveur self-hosted, multi-plateforme, bots extensibles |
| **Git + GitHub** | Partage du code et coordination asynchrone | Standard de l'industrie, formation déjà maîtrisée |
| **Kanboard** | Tableau Kanban | Open source, auto-hébergé, respecte la vie privée |
| **Google Docs** | Documents collaboratifs temps réel | Interface connue, co-édition fluide |
| **Miro** | Brainstorming visuel | Surface infinie, historisation des idées |

#### 3.6.3 Processus de partage d'information

**Règle des "3 C" adoptée pour notre communication :**
- **Clair** : un seul sujet par message. Si un sujet nécessite plus de 5 lignes → document Google Doc ou Issue GitHub.
- **Ciblé** : @tag seulement les personnes concernées. Éviter les @everyone.
- **Centralisé** : aucune info clé échangée uniquement en DM — tout sur le channel public pour que l'équipe puisse chercher/retrouver l'historique.

**Organisation des channels Discord :**
```
📁 Projet MSPR
├── #general         → vie du projet, blagues, liens
├── #dev             → questions techniques, extraits de code
├── #blocages        → à utiliser quand on est bloqué (ping SM)
├── #cr-daily        → compte-rendu écrit du daily pour membres absents
├── #decisions       → archive des décisions structurantes (ADR)
└── 🔊 War Room       → vocal permanent, rejoignable librement
```

#### 3.6.4 Animation des réunions à distance

**Règles d'or pour nos visios :**

1. **Agenda envoyé 24h à l'avance** (sinon, la réunion est annulée)
2. **Caméra allumée** au démarrage (crée l'engagement), puis facultatif ensuite
3. **Tour de parole en début de réunion** (« comment tu vas, un mot ») — humanise la réunion
4. **Timeboxing strict** : une horloge visible, alarme à 80 % du temps
5. **CR envoyé dans les 2 heures** après la réunion dans `#decisions`
6. **Règle du « pas de multitâche »** : personne ne lit ses mails pendant qu'un autre parle

#### 3.6.5 Bien-être en télétravail

Nous avons formalisé un **code de bonne conduite télétravail** :

- **Pause déjeuner non négociable** : blocage du calendrier 12h-13h30, aucun message attendu
- **Pas de réunion après 17h30** sauf urgence P0
- **Points 1-to-1 hebdomadaires** (Scrum Master ↔ chaque membre) : détection précoce du décrochage ou de la surcharge
- **Balance charge** : visualisation du nombre de tickets en cours par membre — rééquilibrage si un membre croule
- **Communication asynchrone acceptée** : on n'attend pas une réponse immédiate. Si urgent → appel direct.

### 3.7 Gestion des conflits et solutions innovantes

**Principes** :
- **Présomption de bonne foi** : on présume que l'intention de l'autre était positive avant de réagir.
- **Règle 24h** : en cas de désaccord vif, on attend 24h avant d'en reparler (sauf blocage opérationnel).
- **Médiation par le Scrum Master** : Loïc intervient si un désaccord persiste, en écoutant les deux parties séparément avant de les réunir.

**Solutions innovantes adoptées pour anticiper les malentendus** :
- **Architecture Decision Records (ADR)** : chaque décision technique structurante est documentée dans un fichier `.md` dédié dans le repo. Motivation + alternatives envisagées + décision. Évite qu'un membre absent ne remette en cause une décision déjà actée.
- **Pair programming hebdomadaire** : 1h par semaine, un binôme tournant code ensemble une fonctionnalité. Permet le transfert de connaissance et crée du lien.
- **« Blameless post-mortem »** après chaque incident (bug, oubli) : on documente ce qui s'est passé sans chercher de coupable, on extrait les leçons.

---

## 4. Cahiers des charges

### 4.1 Cahier des charges fonctionnel

Le client COGIP exprime les besoins fonctionnels suivants :

| Besoin | Description | Priorité |
|--------|-------------|----------|
| **BF-01** | Héberger l'ERP Odoo accessible depuis Internet via HTTPS | Must |
| **BF-02** | Persister les données Odoo et PostgreSQL entre redémarrages | Must |
| **BF-03** | Pouvoir déployer / redéployer l'infrastructure en une commande | Must |
| **BF-04** | Disposer d'un Plan de Reprise d'Activité (PRA) reproductible | Must |
| **BF-05** | Sécuriser l'accès par certificat TLS (même auto-signé pour le PoC) | Must |
| **BF-06** | Masquer la complexité d'infrastructure aux équipes applicatives | Must |
| **BF-07** | Disposer d'une documentation technique livrable au client | Must |
| **BF-08** | Pouvoir dimensionner à la hausse (scale-up) sans réinstallation | Should |
| **BF-09** | Mise en place d'un monitoring basique | Could |
| **BF-10** | Authentification SSO entreprise (SAML/LDAP) | Won't (phase 2) |

### 4.2 Cahier des charges technique

Besoins techniques dérivés :

| Exigence technique | Justification |
|--------------------|---------------|
| **Orchestration Kubernetes** | Flexibilité, résistance aux pannes, dimensionnement (demande du client) |
| **Infrastructure as Code** | Reproductibilité + versionning + audit (PRA) |
| **Provider cloud public** | Absence d'infrastructure dédiée chez COGIP + partenariat AWS Academy |
| **Image de conteneur officielle** | Sécurité + maintenance + support communautaire |
| **Stockage persistant** | Résistance aux redémarrages de pods |
| **Ingress HTTPS** | Bonne pratique de sécurité et exigence RGPD |
| **Séparation des environnements via namespaces** | Isolation applicative future (dev/staging/prod) |
| **Pas de secrets committés dans Git** | Sécurité (consigne explicite du sujet) |

### 4.3 Contraintes non-fonctionnelles

- **Budget** : gratuit (compte AWS Academy / tokens 4h renouvelables)
- **Calendrier** : 19h de préparation + soutenance de 50 min
- **Équipe** : 3 personnes (4 prévus au sujet, groupe impair)
- **Compétences à démontrer** : listées en page 1 du cahier des charges (17 items)

---

## 5. Pilotage des prestataires externes

### 5.1 Cartographie des prestataires du SI

Pour ce projet, notre équipe est elle-même prestataire de COGIP, mais nous nous appuyons sur plusieurs **fournisseurs externes** :

| Prestataire / fournisseur | Rôle | Type de relation |
|---------------------------|------|------------------|
| **AWS (Amazon Web Services)** | Fournisseur cloud (EKS, EC2, VPC, ELB) | Contractuel / SaaS |
| **Odoo S.A.** | Éditeur de l'ERP | Licence LGPL (Community Edition) |
| **Canonical / Docker Inc.** | Fournisseur d'images officielles `postgres` et `odoo` | Registry publique |
| **Équipe ingress-nginx (Kubernetes SIG Network)** | Projet OSS du contrôleur Ingress | Communautaire |
| **Rancher / SUSE** | Projet OSS local-path-provisioner | Communautaire |
| **HashiCorp** | Éditeur Terraform | Licence BSL |
| **Red Hat / Ansible Community** | Éditeur Ansible | Licence GPLv3 |
| **EPSI (campus)** | Accès au partenariat AWS Academy | Contractuel école |

### 5.2 Pilotage AWS (fournisseur principal)

**Points d'attention** :
- **Tokens éphémères (4h)** : chaque session de travail impose de régénérer les credentials depuis la console AWS Academy. Impact opérationnel : nous avons conçu une procédure courte de 3 commandes (cf. section PRA).
- **Quota de facturation** : le compte étudiant est plafonné à ~100 $ de crédit. Nous avons retenu les instances `t3.medium` (les moins chères conformes à la spec Odoo) et le plan `SPOT` interdit (limitation compte étudiant).
- **Roles IAM pré-créés** : AWS Academy fournit des rôles `LabEksClusterRole` et `LabEksNodeRole` dont nous nous servons. Interdiction de créer de nouveaux rôles IAM sur ce type de compte → adaptation Terraform.

### 5.3 Sécurisation de la mise en œuvre technique

Pour sécuriser la mise en œuvre malgré notre dépendance à ces fournisseurs :

| Risque | Mesure de mitigation |
|--------|----------------------|
| AWS Academy indisponible | Bascule vers Kapsule (Scaleway) planifiée en plan B |
| Retrait d'une image Docker Hub | **Ce risque s'est matérialisé pendant le projet** (tags Bitnami retirés). Mitigation : passage aux images officielles Docker Library. |
| Breaking change HashiCorp (BSL license) | Migration possible vers OpenTofu (fork BSL-libre) |
| Cluster EKS non provisionnable | Vérification du quota et roles IAM en phase 1 (cadrage) |

---

## 6. Réalisation technique (synthèse)

> Cette section est volontairement synthétique car le focus du bloc 2 est la gestion de projet. Les détails techniques complets sont disponibles dans le dépôt Git (fichiers `.tf`, `.yml`) et dans [docs/architecture.md](./architecture.md).

### 6.1 Choix technologiques et justifications

| Choix | Alternative envisagée | Justification |
|-------|----------------------|---------------|
| **AWS EKS** (cluster Kubernetes managé) | K3s baremetal / GKE / AKS | Partenariat EPSI/AWS Academy disponible. Control-plane géré par AWS (gain de temps + SLA 99.95%). |
| **us-east-1** | eu-west-3 (Paris) | Tarification la plus basse + quotas étudiants plus larges |
| **t3.medium** pour workers | t3.small / t3.large | 2 vCPU + 4 Go RAM = spec minimale Odoo. t3.small insuffisant (OOMKilled testé). |
| **Images Odoo & PostgreSQL officielles** | Images Bitnami | **Pivot réalisé en cours de projet** : tags Bitnami retirés de Docker Hub (politique de rétention). Les images officielles Docker Library sont maintenues à long terme. |
| **local-path-provisioner** (Rancher) | Amazon EBS CSI Driver / Longhorn / NFS | Simplicité : pas de dépendance IAM supplémentaire (compte étudiant contraint), déploiement en 1 manifeste. |
| **ingress-nginx** | AWS ALB Ingress Controller / Traefik | Neutre (pas de lock-in AWS) + documentation riche + standard Kubernetes |
| **Cert auto-signé via openssl** | Let's Encrypt via cert-manager | Pas de nom de domaine disponible → auto-signé accepté par le cahier des charges |
| **Terraform + Ansible + Helm** | Pulumi / CloudFormation / CDK | Ce sont les outils explicitement demandés par le sujet |
| **Makefile** (one-shot deploy) | Taskfile / script bash | Standard de fait dans l'industrie, pas de dépendance supplémentaire |

### 6.2 Architecture globale

Voir les trois diagrammes Mermaid dans [docs/architecture.md](./architecture.md) :

1. **Architecture runtime** — topologie AWS + Kubernetes + namespaces
2. **Flux de déploiement IaC** — enchaînement Terraform → Ansible
3. **Séquence réseau** — parcours d'une requête utilisateur HTTPS

### 6.3 Mission 4 — Packer (non réalisée, justification)

Packer n'a **pas été utilisé**. Le sujet autorise explicitement cette absence (« Packer (si utilisé) »). La raison :

- Avec **AWS EKS**, les workers sont déployés depuis des **AMIs Amazon Linux 2023 maintenues par AWS** (EKS-Optimized). Ces AMIs sont :
  - Mises à jour régulièrement par AWS (patchs de sécurité kernel, runtime containerd)
  - Pré-configurées avec kubelet et les binaires EKS
  - Sélectionnées automatiquement par le node group

- Utiliser Packer ici reviendrait à **re-fabriquer une image AMI** pour y installer des outils que nous n'utilisons pas (agent monitoring, etc.). Ce serait une complexification sans valeur ajoutée pour un PoC.

**Ce que Packer aurait apporté si besoin** (pour référence en oral) :
- Préinstallation d'un agent SSM / Datadog / Prometheus node_exporter
- Pré-chargement d'images Docker fréquentes pour accélérer le cold start
- Hardening système (CIS Benchmark)

### 6.4 Mission 5 — Terraform (VPC + EKS)

Le code Terraform (6 fichiers) provisionne :

| Fichier | Contenu |
|---------|---------|
| `terraform/main.tf` | Déclaration du provider AWS |
| `terraform/variables.tf` | 9 variables paramétrables (région, cluster_name, type d'instance, nombre de workers, ARNs IAM, CIDR) |
| `terraform/terraform.tfvars` | Valeurs effectives pour notre compte AWS Academy |
| `terraform/vpc.tf` | VPC `/16` + 2 subnets publics `/24` dans 2 AZ + IGW + route table |
| `terraform/eks.tf` | Cluster EKS + node group (2 workers t3.medium) |
| `terraform/outputs.tf` | Endpoint du cluster + commande `aws eks update-kubeconfig` |

Lancer tout : `make deploy` (orchestre `terraform init && apply` + Ansible).

**Idempotence testée** : nous avons exécuté `make destroy && make deploy` à 4 reprises au cours du projet (notamment pour valider le PRA). Temps moyen de reconstruction : 15 minutes.

### 6.5 Mission 6 — Ansible bootstrap K8s (non réalisée, justification)

Le sujet autorise explicitement cette absence (« Ansible, déploiement de Kubernetes sur l'infrastructure Terraformée (**si solution BareMetal**) »).

Avec **AWS EKS**, le control-plane est déjà opérationnel dès la fin du `terraform apply`. Il n'y a pas de binaire kubeadm / k3s / rke2 à bootstrapper. Notre playbook Ansible se concentre donc sur le **déploiement applicatif** (Mission 7).

**Ce que nous aurions fait en baremetal** (pour référence en oral) :
- **Distribution retenue** : K3s (recommandation du sujet, LoadBalancer intégré svcLB, Ingress Traefik par défaut)
- **Stockage persistant** : nfs-subdir-external-provisioner sur une 4ᵉ VM NFS
- **Bootstrap** : playbook Ansible lançant `k3sup` sur chaque node, puis `kubectl apply` des ressources
- **Control-planes** : on aurait déployé 3 nodes control-plane pour la redondance (au lieu de 1)

### 6.6 Mission 7 — Ansible (applicatif)

Le playbook `ansible/playbooks/02-deploy-odoo.yml` enchaîne 20+ tâches Kubernetes :

1. Installation **local-path-provisioner** (StorageClass)
2. Installation **ingress-nginx** via Helm (module `kubernetes.core.helm`)
3. Attente du provisionnement du LoadBalancer AWS
4. Création du namespace `odoo`
5. **PostgreSQL 16** (Secret + PVC + Deployment + Service)
6. **ConfigMap `odoo.conf`** avec master_passwd fixe (évite la génération aléatoire au premier accès)
7. **Odoo 17** (PVC + Deployment + Service + volume de config)
8. **Cert TLS auto-signé** généré via `openssl` puis injecté comme Secret Kubernetes
9. **Ingress** HTTPS avec hostname `odoo.mspterra.local`
10. Attente de la disponibilité de l'endpoint HTTPS
11. **Création automatique de la base de données** via un POST sur `/web/database/create` (login admin, password, langue, pays pré-remplis)
12. **Export des credentials** dans un fichier `CREDENTIALS.txt` (gitignoré) à la racine du dépôt

### 6.7 Captures d'écran / éléments de preuve

Disponibles en annexes (voir §11) :
- `kubectl get nodes -o wide` (2 workers Ready)
- `kubectl get pods -n odoo` (odoo + postgres Running 1/1)
- Odoo accessible via HTTPS sur `https://odoo.mspterra.local`
- Page de login Odoo
- Bureau principal Odoo après connexion (modules Apps)
- Tableau Kanban final (Kanboard)
- `CREDENTIALS.txt` généré

---

## 7. Tableau de bord et suivi de performance

### 7.1 Indicateurs quantitatifs

| KPI | Valeur cible | Valeur atteinte | Statut |
|-----|--------------|-----------------|--------|
| Temps de déploiement de 0 à Odoo accessible | < 20 min | ~15 min | ✅ |
| Temps de destruction complète | < 10 min | ~6 min | ✅ |
| Nombre de lignes Terraform | < 200 | 148 | ✅ |
| Nombre de tâches Ansible | < 30 | 24 | ✅ |
| Couverture du sujet (missions validées) | 6/8 (M4, M6 hors périmètre) | 6/8 | ✅ |
| Nombre de sprints | 5-6 | 5 | ✅ |
| Taux de complétion du backlog initial | ≥ 80 % | ~ 95 % | ✅ |
| Respect du budget horaire (19 h) | ± 10 % | 19 h | ✅ |
| Nombre de commits Git | ≥ 10 | ~ 15 | ✅ |
| Nombre d'incidents majeurs en prod | 0 | 0 | ✅ |

### 7.2 Indicateurs qualitatifs

| Indicateur | Mesure | Évaluation |
|------------|--------|------------|
| **Climat d'équipe** | Rétrospective fin de sprint — échelle 1-5 | 4.5/5 en moyenne |
| **Clarté de la répartition des rôles** | Entretien 1-to-1 SM | Bonne (aucune confusion signalée) |
| **Qualité de la documentation produite** | Relecture croisée | Complète et claire selon revues |
| **Auto-évaluation des compétences acquises** | Fin de projet | Progression forte sur Terraform / Ansible |

### 7.3 Suivi des écarts et corrections

**Écart majeur détecté au sprint 3** : le déploiement Odoo via la chart Helm Bitnami échoue par `ImagePullBackOff`.
- **Cause racine** : politique de rétention 6 mois de Bitnami → les tags cités dans le chart sont absents de Docker Hub.
- **Décision d'équipe** : pivot vers les images officielles `odoo:17` et `postgres:16`, déployées via `kubernetes.core.k8s` plutôt que `kubernetes.core.helm`.
- **Impact planning** : +1 jour sur la phase 3.
- **Leçon** : ne pas dépendre d'images dont la politique de rétention n'est pas maîtrisée — ou mirror les images sur un registry privé (ECR public).

---

## 8. Plan de Reprise d'Activité (PRA)

### 8.1 Objectif

Le cahier des charges COGIP exige explicitement un PRA satisfaisant Tesker. Notre infrastructure Kubernetes est entièrement pilotée par Terraform + Ansible + Git : la reconstruction peut être faite par **n'importe quel ingénieur** disposant de :

1. Un compte AWS valide
2. Le dépôt Git cloné
3. Les outils installés (`terraform`, `ansible`, `kubectl`, `helm`, `aws-cli`)

### 8.2 Scénarios couverts

| Scénario | RTO (Recovery Time Objective) | RPO (Recovery Point Objective) | Procédure |
|----------|-------------------------------|---------------------------------|-----------|
| Cluster EKS corrompu | < 20 min | 0 (config Git) | `make destroy && make deploy` |
| Compte AWS compromis / migration région | 30-60 min | 0 | Changer `aws_region` dans `terraform.tfvars`, `make deploy` |
| Perte complète de l'environnement local | 15 min | 0 | Cloner le repo sur nouvelle machine, configurer AWS CLI, `make deploy` |
| Bug applicatif nécessitant rollback | 2-5 min | 0 | Modifier la version d'image dans le playbook, `ansible-playbook …` |
| Upgrade version Kubernetes | 20 min | < 5 min (pods restart) | Changer `kubernetes_version` dans `terraform.tfvars`, `terraform apply` |

### 8.3 Procédure « Reprise complète » validée

**Pré-requis** : tokens AWS Academy valides (4h).

```bash
# 1. Cloner le dépôt
git clone https://github.com/<compte>/mspterra.git
cd mspterra

# 2. Configurer les credentials AWS
vim ~/.aws/credentials  # injection des nouveaux tokens

# 3. Vérification
aws sts get-caller-identity

# 4. Déploiement complet
make deploy

# 5. Après ~15 min, récupérer les credentials
cat CREDENTIALS.txt

# 6. Résoudre l'IP publique du LoadBalancer
nslookup <LB-hostname>

# 7. Ajouter l'entrée DNS locale
# Windows : C:\Windows\System32\drivers\etc\hosts
# Linux/Mac : /etc/hosts
echo "<IP>  odoo.mspterra.local" | sudo tee -a /etc/hosts

# 8. Accéder à Odoo : https://odoo.mspterra.local
```

### 8.4 Données persistantes

**Limitation connue** : le stockage `local-path-provisioner` écrit sur le disque local du worker. En cas de destruction du cluster EKS, **les données Odoo sont perdues**.

**Mitigation prévue (phase 2)** :
- Migration vers Amazon EBS CSI Driver pour des volumes persistants indépendants des nodes
- Mise en place de snapshots EBS planifiés (quotidiens)
- Export régulier de la base Odoo via la fonction d'exportation native de l'ERP

---

## 9. Bilan et amélioration continue

### 9.1 Rétrospective globale

**Ce qui a bien fonctionné** :
- Le Makefile one-shot a énormément accéléré les cycles de test.
- La séparation Terraform/Ansible est claire et permet à chaque membre de contribuer sans collisions.
- Le pivot d'images Bitnami → officielles a été géré en moins d'une demi-journée grâce au rituel « blameless post-mortem ».
- Le Kanban a tenu sur toute la durée — aucune tâche oubliée.
- La communication Discord a permis de débloquer rapidement (temps moyen de réponse < 30 min en heures ouvrées).

**Ce qui a moins bien fonctionné** :
- **Sous-estimation du temps de setup initial** des outils dans WSL (pip conflits, PATH, helm manquant). Pour un prochain projet, on documentera un `setup-tools.sh` dès le sprint 0.
- **Dépendance aux images Docker Hub** : nous aurions dû miroiter les images critiques sur notre propre registry (ECR public) dès le sprint 1.
- **Pas de tests automatisés** (CI/CD) pour Terraform et Ansible : un premier run `terraform validate` + `ansible-lint` dans un pipeline GitHub Actions serait un plus évident.
- La **soutenance client (COGIP simulé)** a été préparée en dernière minute — il aurait fallu commencer dès le sprint 4.

### 9.2 Axes d'amélioration pour la phase production

Si ce PoC devenait production pour COGIP/Tesker :

| Axe | Action recommandée |
|-----|--------------------|
| **Haute disponibilité** | 3 control-planes (déjà assuré par EKS managé) + 3 workers minimum dans 3 AZ |
| **Stockage durable** | Migration sur Amazon EBS CSI + snapshots planifiés |
| **Certificat signé** | Let's Encrypt via cert-manager + nom de domaine Route53 |
| **Observabilité** | Prometheus + Grafana + Loki pour logs centralisés |
| **Sauvegardes** | Velero pour snapshots de l'ensemble du cluster |
| **Sécurité** | Network Policies, PodSecurityAdmission, audit logs EKS exportés vers S3 |
| **Scalabilité** | Horizontal Pod Autoscaler (HPA) sur Odoo, Cluster Autoscaler AWS |
| **CI/CD** | Pipelines GitHub Actions : `terraform validate`, `ansible-lint`, tests end-to-end |
| **Monitoring des coûts** | AWS Cost Explorer + alertes billing |
| **Revue de sécurité** | Scan d'images (Trivy), SAST, test de pénétration externe |

### 9.3 Compétences développées par membre

| Membre | Compétences clés renforcées |
|--------|----------------------------|
| Aurélien | Leadership produit, arbitrage, rédaction dossier client, Terraform |
| Loïc | Animation d'équipe agile, documentation, scripting Ansible |
| Louis | Déploiement applicatif, debugging Kubernetes, automatisation Helm |

---

## 10. Conclusion

Ce projet nous a permis de démontrer notre capacité à **piloter de bout en bout** un projet d'infrastructure virtualisée en mode agile, en combinant :

- La **rigueur** de l'Infrastructure as Code (Terraform + Ansible + Helm), garante de la **reproductibilité** et du **PRA**
- La **souplesse** de la méthodologie Scrum adaptée à une petite équipe
- La **formalisation proactive** de politiques d'inclusion et de communication, même en l'absence de diversité visible dans l'équipe actuelle
- La **capacité à pivoter** face à un imprévu (dépréciation des images Bitnami)

La livraison comprend :
- Un dépôt Git complet et reproductible (`make deploy` en une commande)
- Une documentation claire (Gantt, Kanban, architecture, dossier)
- Un cluster Kubernetes managé fonctionnel, hébergeant Odoo en HTTPS
- Un processus de PRA validé

Notre solution satisfait les besoins exprimés par COGIP pour le PoC. En phase production, les axes d'amélioration listés en §9.2 permettront d'atteindre un niveau de service production-ready, en capacité de supporter la charge d'une plateforme ERP au service du groupe Tesker.

---

## 11. Annexes

### Annexe A — Structure du dépôt Git

```
mspterra/
├── .gitignore
├── Makefile                            # Commandes make deploy / destroy / status
├── README.md                           # Présentation rapide du repo
├── setup-tools.sh                      # Script d'installation des outils
├── terraform/
│   ├── main.tf                         # Provider AWS
│   ├── variables.tf                    # Variables paramétrables
│   ├── terraform.tfvars                # Valeurs effectives
│   ├── vpc.tf                          # VPC + subnets + IGW
│   ├── eks.tf                          # Cluster EKS + node group
│   └── outputs.tf                      # Outputs (endpoint, kubectl command)
├── ansible/
│   ├── ansible.cfg
│   └── playbooks/
│       ├── 01-configure-kubectl.yml    # Configuration de kubectl
│       └── 02-deploy-odoo.yml          # Déploiement complet Odoo
└── docs/
    ├── architecture.md                 # 3 diagrammes Mermaid
    ├── gantt.md                        # Planning prévisionnel
    └── dossier-de-rendu.md             # Ce document
```

### Annexe B — Commandes-clés

```bash
# Déploiement complet
make deploy

# Destruction complète
make destroy

# Statut
make status

# Affichage des credentials
make credentials

# Terraform seul
cd terraform && terraform apply

# Ansible seul
cd ansible && ansible-playbook playbooks/02-deploy-odoo.yml

# kubectl configuration
aws eks update-kubeconfig --region us-east-1 --name mspterra-eks

# Vérification du cluster
kubectl get nodes
kubectl get pods -A

# Résolution du LoadBalancer
nslookup $(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

### Annexe C — Captures d'écran

*Les captures d'écran suivantes sont à produire au moment de la soutenance (les tokens AWS Academy expirent toutes les 4 h — reproductibilité assurée par `make deploy`) :*

1. `aws sts get-caller-identity` — authentification valide
2. `terraform apply` — succès avec outputs
3. `kubectl get nodes -o wide` — 2 workers Ready
4. `kubectl get pods -n odoo` — Odoo + PostgreSQL Running
5. `kubectl get ingress -n odoo` — Ingress avec LoadBalancer
6. Page d'accueil Odoo (après `/web/database/manager`)
7. Odoo après connexion (bureau, apps)
8. Tableau Kanban final
9. Gantt final
10. Fichier `CREDENTIALS.txt`

### Annexe D — Références

- Cahier des charges MSPR TPRE961 (support fourni par EPSI)
- Documentation AWS EKS : https://docs.aws.amazon.com/eks/
- Documentation Terraform AWS Provider : https://registry.terraform.io/providers/hashicorp/aws/
- Documentation Ansible kubernetes.core : https://docs.ansible.com/ansible/latest/collections/kubernetes/core/
- Documentation ingress-nginx : https://kubernetes.github.io/ingress-nginx/
- Documentation Odoo : https://www.odoo.com/documentation/17.0/
- Référentiel handicap EPSI (référent disponible sur campus)

### Annexe E — Glossaire

| Terme | Définition |
|-------|-----------|
| **IaC** | Infrastructure as Code — description de l'infrastructure dans des fichiers versionnés |
| **PRA** | Plan de Reprise d'Activité — procédure de reconstruction après sinistre |
| **PoC** | Proof of Concept — démonstration faisable d'un concept |
| **EKS** | Elastic Kubernetes Service — service managé Kubernetes d'AWS |
| **NLB** | Network LoadBalancer — LB de niveau 4 d'AWS |
| **Ingress** | Ressource Kubernetes qui expose des services HTTP(S) à l'extérieur |
| **CRD** | Custom Resource Definition — ressources Kubernetes personnalisées |
| **RTO** | Recovery Time Objective — temps maximum pour rétablir le service |
| **RPO** | Recovery Point Objective — perte de données maximum tolérée |
| **ADR** | Architecture Decision Record — document traçant une décision technique |

---

*Fin du dossier de rendu — merci aux membres de l'équipe et au jury.*
