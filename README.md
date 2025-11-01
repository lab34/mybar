# MyBar - Moniteur d'Espace Disque macOS

Application macOS native légère qui affiche l'espace disque disponible dans la barre de menus.

## Fonctionnalités

- Affichage en temps réel de l'espace disque disponible sur le volume principal
- Calcul du delta (variation) depuis le début de la journée
- Mise à jour automatique toutes les 5 minutes
- Consommation minimale de CPU et batterie
- Compatible Apple Silicon natif
- Interface minimaliste dans la barre de menus macOS

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

L'application s'installe automatiquement dans la barre de menus et affiche :
- Espace disque disponible (ex: "156.2 GB")
- Variation depuis le début de journée (ex: "-2.1 GB")

L'application se met à jour automatiquement sans intervention utilisateur.

## Architecture

Projet SwiftUI avec MenuBarExtra pour une intégration native macOS optimisée pour les performances et l'économie d'énergie.

## License

MIT License