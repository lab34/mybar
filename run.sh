#!/bin/bash

# Script pour construire et lancer MyBar

echo "🔨 Construction de MyBar..."
xcodebuild -project MyBar.xcodeproj -scheme MyBar -configuration Debug -destination 'platform=macOS' build

if [ $? -eq 0 ]; then
    echo "✅ Build réussi"

    # Trouver et copier l'application
    APP_PATH=$(find /Users/labouc/Library/Developer/Xcode/DerivedData/MyBar-*/Build/Products/Debug/ -name "MyBar.app" -type d | head -1)

    if [ -n "$APP_PATH" ]; then
        echo "🚀 Lancement de MyBar..."
        cp -R "$APP_PATH" ./
        open MyBar.app
        echo "📱 MyBar est maintenant dans votre barre de menus !"
    else
        echo "❌ Application non trouvée"
    fi
else
    echo "❌ Build échoué"
fi