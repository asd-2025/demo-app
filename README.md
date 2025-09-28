# Demo-App

## 🎯 Objectif
Ce dépôt contient une application de démonstration utilisée pour tester et valider
les pipelines CI/CD, le déploiement sur Kubernetes OVHcloud MKS et la supervision.  
Elle servira de “sandbox” pour expérimenter les bonnes pratiques DevOps apprises
pendant la formation ASD-2025.

## 🗂 Arborescence prévue
- **app/** : code source de l’application (ex. petit service web en Python/Node)
- **charts/** : chart Helm pour déployer l’application sur Kubernetes
- **tests/** : scripts ou scénarios de test
- **docs/** : documentation sur l’application et son déploiement

## 🚀 Déploiement
- Build de l’image Docker de l’application
- Publication sur un registre privé
- Déploiement via Helm sur le cluster MKS OVHcloud
- Tests de bon fonctionnement et rollback

## 🔒 Sécurité & Secrets
- Gestion des variables d’environnement et secrets via Kubernetes
- Pas de credentials en clair dans le dépôt
- Respect des bonnes pratiques CI/CD

## 📈 Supervision
- Dashboards Grafana spécifiques à l’application
- Alertes dans Alertmanager
- Logs collectés par Loki

## 🤝 Contribution
Les modifications du code ou des charts passent par Pull Request.
La Team `devops` a les droits en écriture sur ce dépôt.

## 📜 Licence
Ce dépôt est sous licence MIT (voir fichier LICENSE à la racine).
