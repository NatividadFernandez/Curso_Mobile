import 'package:flutter/material.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/presentation/navigation/navigation_routes.dart';

void main() async {
  await AppModules().setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
