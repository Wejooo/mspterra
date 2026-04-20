# Architecture MSPR TPRE961

## 1. Architecture runtime (infrastructure déployée)

```mermaid
flowchart TB
    User(["👤 Utilisateur<br/>Navigateur"])

    subgraph AWS["☁️ AWS Cloud — région us-east-1"]
        IGW["Internet Gateway"]
        NLB["🔀 Network LoadBalancer<br/>(créé par ingress-nginx)"]

        subgraph VPC["VPC 10.0.0.0/16"]

            subgraph EKS["EKS Cluster mspterra-eks — Kubernetes 1.32"]
                CP["🧠 Control Plane<br/>(managé par AWS)"]

                subgraph SubA["Subnet public — us-east-1a (10.0.1.0/24)"]
                    W1["Worker 1<br/>EC2 t3.medium<br/>2 vCPU · 4 Go RAM"]
                end
                subgraph SubB["Subnet public — us-east-1b (10.0.2.0/24)"]
                    W2["Worker 2<br/>EC2 t3.medium<br/>2 vCPU · 4 Go RAM"]
                end

                subgraph NSIng["ns: ingress-nginx"]
                    ING["Pod ingress-nginx<br/>controller"]
                end

                subgraph NSOdoo["ns: odoo"]
                    ODOO["Pod Odoo 17<br/>:8069"]
                    PG["Pod PostgreSQL 16<br/>:5432"]
                    VolO[("PVC odoo-data<br/>5 Gi<br/>local-path")]
                    VolP[("PVC postgres-pvc<br/>5 Gi<br/>local-path")]
                    TLS>"🔒 Secret odoo-tls<br/>(cert auto-signé)"]
                    IngRule["Ingress odoo<br/>host: odoo.mspterra.local<br/>TLS + redirect HTTPS"]
                end
            end
        end
    end

    User -->|"HTTPS :443<br/>odoo.mspterra.local"| IGW
    IGW --> NLB
    NLB --> ING
    ING --> IngRule
    IngRule --> ODOO
    ODOO -->|"SQL :5432"| PG
    ODOO --- VolO
    PG --- VolP
    IngRule -.uses.- TLS
    CP -.schedules.- W1
    CP -.schedules.- W2

    classDef aws fill:#232F3E,stroke:#FF9900,color:#fff
    classDef k8s fill:#326CE5,stroke:#fff,color:#fff
    classDef pod fill:#fff,stroke:#326CE5
    classDef vol fill:#F0F0F0,stroke:#666
    class AWS,IGW,NLB,VPC aws
    class EKS,CP,NSIng,NSOdoo,SubA,SubB k8s
    class ING,ODOO,PG,W1,W2 pod
    class VolO,VolP vol
```

---

## 2. Flux de déploiement (Infrastructure as Code)

```mermaid
flowchart LR
    Dev["👨‍💻 Ingénieur<br/>make deploy"]

    subgraph IAC["Outils IaC"]
        TF["📜 Terraform<br/>terraform apply"]
        ANS["📘 Ansible<br/>ansible-playbook"]
    end

    subgraph Provisionne["Provisionné par Terraform"]
        VPC2["VPC + Subnets<br/>+ Route Table + IGW"]
        EKS2["Cluster EKS<br/>+ Node Group (2 workers)"]
    end

    subgraph Configure["Configuré par Ansible (kubernetes.core)"]
        STG["local-path-provisioner<br/>(StorageClass)"]
        NGX["ingress-nginx<br/>via Helm"]
        PGAPP["PostgreSQL 16<br/>Deployment + Service + PVC"]
        ODAPP["Odoo 17<br/>Deployment + Service + PVC + ConfigMap"]
        INGAPP["Ingress + TLS self-signed<br/>+ création auto de la DB Odoo"]
        CRED["📄 CREDENTIALS.txt"]
    end

    Dev --> TF
    TF --> VPC2
    TF --> EKS2
    EKS2 -.kubeconfig.-> ANS
    Dev --> ANS
    ANS --> STG
    ANS --> NGX
    ANS --> PGAPP
    ANS --> ODAPP
    ANS --> INGAPP
    ANS --> CRED

    classDef user fill:#FFD700,stroke:#333
    classDef tf fill:#7B42BC,stroke:#fff,color:#fff
    classDef ans fill:#EE0000,stroke:#fff,color:#fff
    classDef out fill:#E0F7FA,stroke:#00838F
    class Dev user
    class TF tf
    class ANS ans
    class VPC2,EKS2,STG,NGX,PGAPP,ODAPP,INGAPP,CRED out
```

---

## 3. Flux réseau d'une requête utilisateur

```mermaid
sequenceDiagram
    actor User as Utilisateur
    participant DNS as /etc/hosts<br/>(résolution locale)
    participant LB as AWS NLB
    participant NGX as ingress-nginx
    participant ODOO as Odoo Pod
    participant PG as PostgreSQL Pod

    User->>DNS: odoo.mspterra.local ?
    DNS-->>User: 52.20.62.230 (IP du NLB)
    User->>LB: HTTPS :443
    LB->>NGX: TCP vers pod controller
    NGX->>NGX: termine TLS (cert auto-signé)
    NGX->>NGX: match Host: odoo.mspterra.local
    NGX->>ODOO: HTTP :8069 (plain, dans le cluster)
    ODOO->>PG: SQL :5432
    PG-->>ODOO: résultat requête
    ODOO-->>NGX: HTML
    NGX-->>LB: HTTPS
    LB-->>User: HTTPS réponse
```

---

## 4. Stack technologique

| Couche | Technologie | Rôle |
|--------|-------------|------|
| Cloud | **AWS EKS** (us-east-1) | Cluster Kubernetes managé |
| Compute | **EC2 t3.medium × 2** | Workers Kubernetes |
| Réseau | **VPC + 2 subnets publics** | Isolation + HA multi-AZ |
| Orchestration | **Kubernetes 1.32** | Orchestration conteneurs |
| Ingress | **ingress-nginx** + AWS NLB | Exposition HTTPS |
| Storage | **local-path-provisioner** | Volumes persistants |
| App | **Odoo 17** (image officielle) | ERP |
| DB | **PostgreSQL 16** (image officielle) | Base de données |
| TLS | **Certificat auto-signé** | Chiffrement HTTPS |
| IaC compute | **Terraform 1.14** | Provisionnement AWS |
| IaC config | **Ansible + kubernetes.core** | Déploiement applicatif |
| Packaging | **Helm 3** | Déploiement ingress-nginx |
| Orchestration | **GNU Make** | Commande unique `make deploy` |
