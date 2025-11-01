# MyBar - Moniteur d'Espace Disque macOS

Application macOS native légère qui affiche l'espace disque disponible dans la barre de menus.

## Fonctionnalités

- **Affichage direct** de l'espace disque dans la barre de menus (pas d'icône à cliquer)
- Format : "XXX.X GB (+/-X.X GB)" avec variation journalière
- Calcul du delta (variation) depuis le début de la journée
- Mise à jour automatique toutes les 5 minutes
- Consommation minimale de CPU et batterie
- Compatible Apple Silicon natif
- Application invisible (pas d'icône dans le Dock)
- Menu contextuel simple pour quitter l'application

## Configuration requise

- macOS 13.0 ou supérieur
- Apple Silicon (recommandé) ou Intel

## Installation

Clonez ce repository et ouvrez le projet dans Xcode :

```bash
git clone <repository-url>
cd mybar
open MyBar.xcodeproj
```

## Utilisation

L'application s'installe automatiquement dans la barre de menus et **affiche directement** :
- Espace disque disponible (ex: "156.2 GB")
- Variation depuis le début de journée (ex: "-2.1 GB")

**Important** : L'information est visible en permanence dans la barre de menus, **sans avoir besoin de cliquer sur une icône**.

L'application se met à jour automatiquement sans intervention utilisateur.

Cliquez droit sur le texte pour accéder au menu et quitter l'application.

## Architecture

Projet **hybride SwiftUI + AppKit** utilisant :
- **NSStatusItem** pour l'affichage direct du texte dans la barre de menus
- **AppDelegate** pour la gestion du cycle de vie
- **SwiftUI** pour les composants réactifs (DiskSpaceMonitor, StorageManager)
- **Foundation** pour l'accès système et la persistance

Cette architecture offre un contrôle total sur l'affichage tout en maintenant la simplicité et les performances.

## License

MIT License