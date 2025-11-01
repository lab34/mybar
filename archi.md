# Architecture Technique - MyBar

## Overview
MyBar est une application macOS native légère pour surveiller l'espace disque disponible depuis la barre de menus.

## Architecture Générale

### Design Pattern
- **MVVM (Model-View-ViewModel)** avec SwiftUI
- **Single Responsibility** : chaque composant a une responsabilité unique
- **Dependency Injection** via les environnements SwiftUI

### Stack Technique
- **Language** : Swift 5.7+
- **Framework UI** : SwiftUI (iOS 16+, macOS 13+)
- **Accès système** : Foundation (FileManager)
- **Persistance** : UserDefaults (@AppStorage)
- **Concurrence** : GCD + Timer

## Composants Principaux

### 1. MyBarApp.swift (Point d'entrée)
```swift
// Gère le cycle de vie de l'application via AppDelegate
// Configure NSApplicationDelegateAdaptor
// Initialise le status item de barre de menus
```

### 2. AppDelegate.swift (Gestionnaire de barre de menus)
**Responsabilités :**
- Création et gestion du NSStatusItem
- Affichage direct du texte dans la barre de menus
- Mise à jour automatique via Timer
- Gestion du menu contextuel (Quitter)

**Fonctionnalités :**
- Texte affiché directement : "XXX.X GB (+/-X.X GB)"
- Mises à jour toutes les 5 secondes
- Police monospacée pour une lisibilité optimale

### 3. DiskSpaceMonitor.swift (Modèle)
**Responsabilités :**
- Lecture de l'espace disque disponible via FileManager
- Conversion des octets en GB formatés
- Gestion des erreurs système
- Surveillance du volume principal (`/`)

**Propriétés :**
```swift
struct DiskSpaceInfo {
    let availableSpace: Double    // en GB
    let totalSpace: Double        // en GB
    let timestamp: Date
}
```

### 4. StorageManager.swift (Persistance)
**Responsabilités :**
- Sauvegarde de la dernière mesure
- Récupération des données précédentes
- Calcul du delta journalier
- Gestion du changement de jour (minuit)

**Stockage :**
```swift
@AppStorage("lastMeasurement") private var lastData: Data?
@AppStorage("dayStartMeasurement") private var dayStartData: Data?
```

### 5. Info.plist (Configuration)
**Configuration clé :**
- `LSUIElement: true` : Application cachée du Dock
- Pas de `NSMainStoryboardFile` : Interface purement programmatique
- Signature de code pour la sécurité

## Flux de Données

```
AppDelegate (Timer 5s) → DiskSpaceMonitor → StorageManager → NSStatusItem
                                             ↓
                                       UserDefaults
```

## Architecture Spécifique

### NSStatusItem vs MenuBarExtra
- **Choix final** : NSStatusItem via AppDelegate
- **Avantages** : Contrôle total du texte affiché directement dans la barre
- **Raison** : MenuBarExtra ne permet pas l'affichage direct du texte sans icône

### Cycle de vie
1. **Lancement** : MyBarApp → AppDelegate → setupStatusBar()
2. **Monitoring** : DiskSpaceMonitor.startMonitoring()
3. **Mise à jour** : Timer toutes les 5s → updateDisplay()
4. **Persistance** : StorageManager.saveMeasurement()
5. **Affichage** : NSStatusItem.button.title = "XXX.X GB (+/-X.X GB)"

## Optimisation Énergétique

### Timer Économique
- **Intervalle** : 5 secondes (phase de test) → configurable pour 300 secondes (5 minutes en production)
- **QoS** : `.utility` (priorité basse)
- **Background** : Compatible App Nap
- **Veille** : Pas de réveil du système
- **Optimisation** : Mise à jour uniquement quand les données changent

### Gestion Mémoire
- **Structs** au lieu de classes (allocation pile)
- **Lazy loading** des ressources
- **Pas de cache** inutile
- **Cycle** automatique des objets

### CPU
- **Calculs** uniquement lors des mises à jour
- **Opérations** asynchrones (non-bloquantes)
- **Filesystem** access optimisés

## Sécurité et Permissions

### Accès Système
- **FileManager** : Lecture seule des métadonnées disque
- **Aucune permission spéciale** requise
- **Sandboxing** : standard macOS

### Persistance
- **UserDefaults** : stockage local sécurisé
- **Aucune donnée** envoyée externe
- **Local uniquement** et privé

## Gestion des Erreurs

### Types d'Erreurs
1. **FileSystem** : Disque non accessible
2. **Permission** : Accès refusé (rare)
3. **Parsing** : Données corrompues

### Stratégie
- **Affichage** du dernier état connu
- **Notification** discrète (pas d'alerte)
- **Auto-récupération** à la prochaine tentative

## Performance Cibles

### Métriques
- **CPU** : < 0.1% en utilisation normale
- **Mémoire** : < 10MB RSS
- **Démarrage** : < 1 seconde
- **Impact batterie** : Négligeable

### Monitoring
- **Instruments** profilage régulier
- **Energy Log** vérification
- **Memory Leaks** détection automatique

## Évolution Future

### V1.0 (MVP)
- Surveillance volume principal uniquement
- Format texte simple
- Delta journalier

### V1.1 (Améliorations)
- Configuration du volume
- Fréquence de mise à jour configurable
- Icône et couleurs

### V2.0 (Évolutions)
- Surveillance multiple volumes
- Historique graphique
- Alertes seuils critiques

## Décisions Techniques

### SwiftUI vs AppKit
- **Choix** : SwiftUI pour modernité et performance
- **Avantages** : Code concis, réactif, optimisé Apple Silicon
- **Alternative** : AppKit si compatibilité macOS < 13 requise

### MenuBarExtra vs NSStatusItem
- **Choix final** : NSStatusItem avec AppDelegate
- **Avantages** : Contrôle total du texte affiché, pas d'icône requise
- **Raison** : MenuBarExtra ne permet pas l'affichage direct du texte dans la barre
- **Alternative** : MenuBarExtra si interface pop-up souhaitée

### UserDefaults vs Core Data
- **Choix** : UserDefaults pour simplicité
- **Avantages** : Léger, instantané, aucune configuration
- **Alternative** : Core Data si historique complexe requis