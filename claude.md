# Instructions Claude - MyBar Project

## Contexte du Projet
MyBar est une application macOS native qui affiche l'espace disque disponible dans la barre de menus, avec un affichage du delta journalier.

## Objectifs Principaux
- **Surveillance** : Espace disque disponible sur le volume principal (/)
- **Affichage** : Format texte "XX.X GB (-X.X GB)" directement dans la barre de menus (sans clic)
- **Performance** : Consommation minimale CPU/batterie
- **Mises à jour** : Toutes les 5 secondes (test) → 5 minutes (production), compatible veille

## Contraintes Techniques
- **Plateforme** : macOS 13.0+ (NSStatusItem + AppDelegate)
- **Architecture** : Apple Silicon native
- **Language** : Swift + SwiftUI + AppKit
- **Énergie** : Compatible App Nap, pas de réveil système

## Structure du Projet
```
mybar/
├── MyBar/
│   ├── MyBarApp.swift              # Point d'entrée avec NSApplicationDelegateAdaptor
│   ├── Info.plist                  # Configuration (LSUIElement, pas de storyboard)
│   ├── Models/
│   │   └── DiskSpaceMonitor.swift  # Monitoring espace disque
│   ├── Utils/
│   │   └── StorageManager.swift    # Persistance et calcul delta
│   └── Views/
│       └── MenuBarView.swift       # Interface SwiftUI (legacy, non utilisée)
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

### 3. Interface Barre de Menus
- **Affichage direct** dans NSStatusItem (pas d'icône, pas de clic requis)
- Format : "156.2 GB (-2.1 GB)" avec police monospacée
- Mise à jour automatique via Timer
- Menu contextuel simple (Quitter)

### 4. Architecture AppDelegate
- **NSStatusItem** pour contrôle total de l'affichage
- **Timer** toutes les 5 secondes (configurable)
- Gestion du cycle de vie de l'application
- Nettoyage automatique des ressources

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
- Pattern AppDelegate pour contrôler NSStatusItem
- MVVM avec SwiftUI pour les composants
- Single responsibility principle
- Documentation intégrée
- Architecture hybride SwiftUI + AppKit

## Dépendances
- Aucune dépendance externe
- Frameworks Apple uniquement :
  - SwiftUI (MyBarApp, modèles réactifs)
  - AppKit (NSStatusItem, NSStatusBar)
  - Foundation (FileManager, Timer, UserDefaults)

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
- **Architecture actuelle** : NSStatusItem > MenuBarExtra pour affichage direct
- **Timer** : Configurer 300s pour production (actuellement 5s pour tests)
- **Info.plist** : LSUIElement = true pour cacher du Dock

## Architecture Décisions
### Pourquoi NSStatusItem vs MenuBarExtra ?
- **NSStatusItem** permet d'afficher du texte directement dans la barre
- **MenuBarExtra** nécessite une icône et un menu pop-up
- L'utilisateur voulait voir l'information SANS cliquer

### Pourquoi AppDelegate ?
- Contrôle total du cycle de vie du NSStatusItem
- Gestion propre des timers et ressources
- Nettoyage automatique à la fermeture

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