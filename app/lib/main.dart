import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_dark.dart';
import 'design_aqua.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const WaterEjectApp());
}

class WaterEjectApp extends StatefulWidget {
  const WaterEjectApp({super.key});

  @override
  State<WaterEjectApp> createState() => _WaterEjectAppState();
}

class _WaterEjectAppState extends State<WaterEjectApp> {
  // Permite alternar entre los dos estilos de diseno solicitados
  // ambos conservan el mismo nombre oficial: "Water Eject" y la misma logica acustica
  bool _useDarkDesign = true;

  void _toggleDesign() {
    setState(() {
      _useDarkDesign = !_useDarkDesign;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Eject',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: _useDarkDesign
          ? DesignDark(onSwitchTheme: _toggleDesign)
          : DesignAqua(onSwitchTheme: _toggleDesign),
    );
  }
}
