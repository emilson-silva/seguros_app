import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:seguros_app/app.dart';
import 'package:seguros_app/core/di/injection.dart';
import 'package:seguros_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(const App());
}
