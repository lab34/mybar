# Instructions Claude - MyBar Project

## Contexte du Projet
MyBar est une application macOS native qui affiche l'espace disque disponible dans la barre de menus, avec un affichage du delta journalier.

## Objectifs Principaux
- **Surveillance** : Espace disque disponible sur le volume principal (/)
- **Affichage** : Format texte "XX.X GB (-X.X GB)" dans la barre de menus
- **Performance** : Consommation minimale CPU/batterie
- **Mises à jour** : Toutes les 5 minutes, compatible veille

## Contraintes Techniques
- **Plateforme** : macOS 13.0+ (MenuBarExtra)
- **Architecture** : Apple Silicon native
- **Language** : Swift + SwiftUI
- **Énergie** : Compatible App Nap, pas de réveil système

## Structure du Projet
```
mybar/
├── MyBar/
│   ├── MyBarApp.swift
│   ├── Models/
│   │   └── DiskSpaceMonitor.swift
│   ├── Views/
│   │   └── MenuBarView.swift
│   └── Utils/
│       └── StorageManager.swift
├── README.md
├── todos.md
├── archi.md
└── claude.md
```

## Fonctionnalités Clés

### 1. Monitoring Espace Disque
- Volume principal : `/System/Volumes/Data` ou `/`
- Conversion automatique octets → GB
- Gestion des erreurs de lecture système

### 2. Calcul Delta Journalier
- Stockage dernière mesure + timestamp
- Détection changement de jour (minuit)
- Calcul variation : `actuel - début_jour`

### 3. Interface MenuBar
- Affichage minimaliste
- Format : "156.2 GB (-2.1 GB)"
- Mise à jour réactive SwiftUI

### 4. Timer Économique
- Intervalle : 300 secondes (5 minutes)
- QoS : `.utility` (basse priorité)
- Compatible App Nap et veille

## Bonnes Pratiques

### Performance
- Structs > Classes (allocation pile)
- Opérations asynchrones (GCD)
- Lazy loading des ressources
- Pas de cache inutile

### Énergie
- Quality of Service approprié
- Pas de background threads agressifs
- Respect App Nap
- Timer économique

### Code
- MVVM pattern avec SwiftUI
- Single responsibility principle
- Documentation intégrée
- Tests unitaires simples

## Dépendances
- Aucune dépendance externe
- Frameworks Apple uniquement :
  - SwiftUI (interface)
  - Foundation (FileManager, Timer)
  - Combine (réactivité)

## Cibles de Performance
- CPU : < 0.1% utilisation normale
- Mémoire : < 10MB RSS
- Impact batterie : Négligeable
- Démarrage : < 1 seconde

## Notes de Développement
- Toujours tester la consommation d'énergie
- Vérifier le comportement pendant la veille
- Valider les changements de jour (minuit)
- Maintenir la simplicité avant tout

## Commandes Utiles
```bash
# Ouvrir le projet
open MyBar.xcodeproj

# Tester avec Instruments
instruments -t "Energy Log" MyBar.app

# Vérifier l'utilisation mémoire
top -pid <MyBar-PID>
```

## Environnement Développement
- Xcode 14.0+
- macOS 13.0+
- Apple Silicon (recommandé)
- Swift 5.7+

## Priorités
1. **Fonctionnalité de base** (affichage espace)
2. **Delta journalier** (calcul variation)
3. **Performance optimisation** (CPU/mémoire)
4. **Robustesse** (gestion erreurs)
5. **Documentation** (maintenance future)