# TODO - MyBar Moniteur d'Espace Disque

## Phase 1 : Structure et Documentation ✅
- [x] Création du dossier du projet
- [x] Rédaction du README.md
- [x] Création de todos.md
- [x] Création de archi.md (architecture technique)
- [x] Mise à jour de claude.md (instructions pour Claude)

## Phase 2 : Architecture du projet ✅
- [x] Créer la structure de dossiers sources :
  ```
  MyBar/
  ├── MyBar/
  │   ├── MyBarApp.swift         # Point d'entrée de l'application
  │   ├── Models/
  │   │   └── DiskSpaceMonitor.swift  # Logique de monitoring
  │   ├── Views/
  │   │   └── MenuBarView.swift  # Interface MenuBar
  │   └── Utils/
  │       └── StorageManager.swift   # Persistance des données
  └── MyBar.xcodeproj
  ```

## Phase 3 : Implémentation du modèle de données ✅
- [x] Créer la structure `DiskSpaceInfo` pour stocker :
  - Espace disponible (en GB)
  - Espace total (en GB)
  - Date de mesure
- [x] Implémenter `DiskSpaceMonitor` avec :
  - Méthode pour obtenir l'espace disque disponible
  - Gestion des erreurs de lecture système
  - Conversion automatique en GB

## Phase 4 : Persistance des données ✅
- [x] Implémenter `StorageManager` pour :
  - Sauvegarder la dernière mesure avec sa date
  - Récupérer la mesure du début de journée
  - Calculer le delta journalier
- [x] Utiliser `@AppStorage` pour une persistance légère

## Phase 5 : Interface MenuBar ✅
- [x] Créer `MenuBarView` avec SwiftUI :
  - Affichage du format "XX.X GB (-X.X GB)"
  - Mise à jour automatique du texte
  - Gestion des cas d'erreur
- [x] Intégrer avec `NSStatusItem` via AppDelegate pour contrôle total

## Phase 6 : Timer économique ✅
- [x] Implémenter un timer avec :
  - Intervalle de 5 secondes (tests) → configurable pour 300 secondes (production)
  - Quality of Service approprié
  - Compatibilité avec App Nap
  - Arrêt automatique pendant la veille

## Phase 7 : Optimisation et performance ✅
- [x] Vérifier la consommation CPU (< 0.1%)
- [x] Tester l'impact sur la batterie
- [x] Valider le comportement pendant la mise en veille
- [x] Tester la reprise après veille

## Phase 8 : Configuration Xcode ✅
- [x] Créer le fichier `.xcodeproj`
- [x] Configurer le target macOS 13.0+
- [x] Définir l'architecture Apple Silicon
- [x] Configurer les permissions (accès aux ressources système)
- [x] Configurer LSUIElement pour application cachée

## Phase 9 : Tests et validation ✅
- [x] Tester sur différentes configurations de disque
- [x] Valider le calcul du delta journalier
- [x] Vérifier le comportement au changement de jour (minuit)
- [x] Tests de longue durée

## Phase 10 : Documentation finale ✅
- [x] Mettre à jour README avec instructions d'utilisation
- [x] Documenter les choix techniques dans archi.md
- [x] Ajouter des commentaires dans le code
- [x] Préparer le déploiement (signing, notarisation)

## Phase 11 : Déploiement ✅
- [x] Compiler en mode Release
- [x] Résoudre les problèmes de configuration Info.plist
- [x] Installer dans `/Applications/`
- [x] Documenter le lancement automatique avec launchctl

## Améliorations futures (v1.1+)

### Améliorations UX
- [ ] Configuration de la fréquence de rafraîchissement
- [ ] Choix du volume à surveiller
- [ ] Personnalisation des couleurs et format d'affichage
- [ ] Support des alertes seuils critiques

### Améliorations techniques
- [ ] Surveillance multiple volumes
- [ ] Historique graphique
- [ ] Mode debug avancé
- [ ] Mode silencieux configurable

### Distribution
- [ ] Création d'un installateur pkg
- [ ] Signature et notarisation automatique
- [ ] Publication via GitHub Releases
- [ ] Documentation utilisateur avancée