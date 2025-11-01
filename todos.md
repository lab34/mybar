# TODO - MyBar Moniteur d'Espace Disque

## Phase 1 : Structure et Documentation ✅
- [x] Création du dossier du projet
- [x] Rédaction du README.md
- [x] Création de todos.md
- [ ] Création de archi.md (architecture technique)
- [ ] Mise à jour de claude.md (instructions pour Claude)

## Phase 2 : Architecture du projet
- [ ] Créer la structure de dossiers sources :
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

## Phase 3 : Implémentation du modèle de données
- [ ] Créer la structure `DiskSpaceInfo` pour stocker :
  - Espace disponible (en GB)
  - Espace total (en GB)
  - Date de mesure
- [ ] Implémenter `DiskSpaceMonitor` avec :
  - Méthode pour obtenir l'espace disque disponible
  - Gestion des erreurs de lecture système
  - Conversion automatique en GB

## Phase 4 : Persistance des données
- [ ] Implémenter `StorageManager` pour :
  - Sauvegarder la dernière mesure avec sa date
  - Récupérer la mesure du début de journée
  - Calculer le delta journalier
- [ ] Utiliser `@AppStorage` pour une persistance légère

## Phase 5 : Interface MenuBar
- [ ] Créer `MenuBarView` avec SwiftUI :
  - Affichage du format "XX.X GB (-X.X GB)"
  - Mise à jour automatique du texte
  - Gestion des cas d'erreur
- [ ] Intégrer avec `MenuBarExtra` pour macOS 13+

## Phase 6 : Timer économique
- [ ] Implémenter un timer avec :
  - Intervalle de 5 minutes (300 secondes)
  - Quality of Service `.utility` pour économiser l'énergie
  - Compatibilité avec App Nap (ne pas réveiller le Mac)
  - Arrêt automatique pendant la veille

## Phase 7 : Optimisation et performance
- [ ] Vérifier la consommation CPU (< 0.1%)
- [ ] Tester l'impact sur la batterie
- [ ] Valider le comportement pendant la mise en veille
- [ ] Tester la reprise après veille

## Phase 8 : Configuration Xcode
- [ ] Créer le fichier `.xcodeproj`
- [ ] Configurer le target macOS 13.0+
- [ ] Définir l'architecture Apple Silicon
- [ ] Configurer les permissions (accès aux ressources système)
- [ ] Définir l'icône de l'application

## Phase 9 : Tests et validation
- [ ] Tester sur différentes configurations de disque
- [ ] Valider le calcul du delta journalier
- [ ] Vérifier le comportement au changement de jour (minuit)
- [ ] Tests de longue durée (plusieurs heures)

## Phase 10 : Documentation finale
- [ ] Mettre à jour README avec instructions d'utilisation
- [ ] Documenter les choix techniques dans archi.md
- [ ] Ajouter des commentaires dans le code
- [ ] Préparer le déploiement (signing, notarisation)