# Build Instructions - MyBar

## Prérequis
- Xcode 14.0 ou supérieur
- macOS 13.0 ou supérieur
- Apple Silicon (recommandé) ou Intel

## Compilation

### Via Xcode
```bash
# Ouvrir le projet
open MyBar.xcodeproj

# Compiler et lancer (⌘+R)
```

### Via ligne de commande
```bash
# Compiler le projet
xcodebuild -project MyBar.xcodeproj -scheme MyBar -configuration Debug build

# Compiler pour release
xcodebuild -project MyBar.xcodeproj -scheme MyBar -configuration Release build
```

## Déploiement

### Installation locale
```bash
# Copier l'application dans Applications
cp -r build/Release/MyBar.app /Applications/

# Lancer l'application
open /Applications/MyBar.app
```

### Démarrage automatique
Pour que l'application se lance au démarrage :

1. **Via les préférences Système** :
   - Aller dans `Général > Éléments de connexion`
   - Ajouter MyBar

2. **Via la ligne de commande** :
```bash
# Créer un fichier launch agent
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

# Charger le launch agent
launchctl load ~/Library/LaunchAgents/com.labouc.mybar.plist
```

## Configuration du projet Xcode

### Target Settings
- **Deployment Target** : macOS 13.0
- **Architecture** : Apple Silicon (ARM64)
- **Code Signing** : Automatic
- **Sandboxing** : Activé

### Entitlements
- App Sandbox activé
- Accès lecture seule aux fichiers système
- Pas d'accès réseau requis

### Build Settings optimisés
- **Swift Optimization Level** : -Onone (Debug) / -O (Release)
- **Enable Bitcode** : No
- **Compress PNG Files** : Yes
- **Enable Testability** : Yes (Debug only)

## Performance Monitoring

### Instruments
```bash
# Lancer Instruments pour profiler l'énergie
instruments -t "Energy Log" /Applications/MyBar.app

# Profiler l'utilisation mémoire
instruments -t "Leaks" /Applications/MyBar.app

# Analyser l'utilisation CPU
instruments -t "Time Profiler" /Applications/MyBar.app
```

### Commandes système
```bash
# Vérifier l'utilisation mémoire
top -pid $(pgrep MyBar)

# Monitorer l'énergie
powermetrics --samplers cpu_power,gpu_power -i 1000 -n 10 | grep MyBar

# Vérifier les processus actifs
ps aux | grep MyBar
```

## Debugging

### Logs
```bash
# Voir les logs de l'application
log stream --predicate 'process == "MyBar"'

# Console système
open /Applications/Utilities/Console.app
```

### Debug dans Xcode
- Points d'arrêt dans `DiskSpaceMonitor.swift:45`
- Surveillance des variables `currentSpace` et `dailyDelta`
- Vérification du timer dans `updateDiskSpace()`

## Dépannage

### Problèmes courants
1. **L'application n'apparaît pas dans la barre de menus**
   - Vérifier que `LSUIElement = true` dans Info.plist
   - Redémarrer l'application

2. **Pas d'accès aux informations du disque**
   - Vérifier les entitlements dans MyBar.entitlements
   - S'assurer que le sandboxing autorise l'accès

3. **Consommation batterie élevée**
   - Vérifier l'intervalle du timer (300 secondes minimum)
   - Confirmer la qualité de service (.utility)

### Performance
- CPU : < 0.1% en fonctionnement normal
- Mémoire : < 10MB RSS
- Impact batterie : Négligeable
- Démarrage : < 1 seconde

## Distribution

### Package pour distribution
```bash
# Créer un package d'installation
productbuild --component MyBar.app /Applications --install-location /Applications MyBar.pkg

# Signer le package
productsign --sign "Developer ID Installer" MyBar.pkg MyBar_signed.pkg

# Notariser le package (Apple Developer requis)
xcrun altool --notarize-app --primary-bundle-id "com.labouc.mybar" --username "developer@apple.com" --password "@keychain:AC_PASSWORD" --file MyBar_signed.pkg
```

### Code Signing
```bash
# Signer l'application
codesign --force --verify --verbose --sign "Developer ID Application" MyBar.app

# Vérifier la signature
codesign -dvvv MyBar.app
```