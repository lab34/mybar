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

### Méthode 1 : Binaire précompilé

1. Téléchargez le dernier `MyBar.app` depuis la section [Releases](https://github.com/labouc/mybar/releases)
2. Glissez `MyBar.app` dans votre dossier `/Applications`
3. Lancez l'application depuis Finder ou avec la commande :
   ```bash
   open /Applications/MyBar.app
   ```

### Méthode 2 : Compilation depuis les sources

Clonez ce repository et compilez avec Xcode :

```bash
git clone https://github.com/labouc/mybar.git
cd mybar
open MyBar.xcodeproj
# Dans Xcode : Product → Build (⌘+B)
# L'application sera dans : ~/Library/Developer/Xcode/DerivedData/MyBar-*/Build/Products/Release/MyBar.app
```

### Lancement automatique (optionnel)

Pour lancer MyBar automatiquement au démarrage de macOS :

```bash
# Créer le fichier launchctl
cat > ~/Library/LaunchAgents/com.labouc.mybar.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.labouc.mybar</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/MyBar.app/Contents/MacOS/MyBar</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

# Charger l'agent launchctl
launchctl load ~/Library/LaunchAgents/com.labouc.mybar.plist
```

Pour arrêter le lancement automatique :
```bash
launchctl unload ~/Library/LaunchAgents/com.labouc.mybar.plist
rm ~/Library/LaunchAgents/com.labouc.mybar.plist
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