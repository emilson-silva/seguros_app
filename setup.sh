#!/usr/bin/env bash
# Gera as pastas de plataforma (android/ios/web) em cima do código existente.
set -e
flutter create --project-name seguros_app --platforms=android,ios,web .
flutter pub get
echo ""
echo "Próximos passos:"
echo "  1) dart pub global activate flutterfire_cli"
echo "  2) flutterfire configure   (sobrescreve lib/firebase_options.dart)"
echo "  3) No console Firebase: ativar Authentication > E-mail/senha e criar o Firestore"
echo "  4) firebase deploy --only firestore:rules"
echo "  5) flutter run -d chrome   (ou um emulador/dispositivo)"
