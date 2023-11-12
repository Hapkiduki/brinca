import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Owlet Run',
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}
