import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'tone_generator.dart';

class DesignAqua extends StatefulWidget {
  final VoidCallback? onSwitchTheme;

  const DesignAqua({super.key, this.onSwitchTheme});

  @override
  State<DesignAqua> createState() => _DesignAquaState();
}

class _DesignAquaState extends State<DesignAqua> with SingleTickerProviderStateMixin {
  final ToneGenerator _toneGenerator = ToneGenerator();
  late AnimationController _waveController;
  Timer? _countdownTimer;

  bool _isEjecting = false;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void _toggleEjection() async {
    if (_isEjecting) {
      _stopEjection();
    } else {
      _startEjection();
    }
  }

  void _startEjection() async {
    setState(() {
      _isEjecting = true;
      _secondsRemaining = 30;
    });

    _waveController.repeat();
    await _toneGenerator.startTone();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopEjection();
      }
    });
  }

  void _stopEjection() async {
    _countdownTimer?.cancel();
    _waveController.stop();
    _waveController.reset();
    await _toneGenerator.stopTone();

    if (mounted) {
      setState(() {
        _isEjecting = false;
        _secondsRemaining = 30;
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _waveController.dispose();
    _toneGenerator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (30 - _secondsRemaining) / 30.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Barra superior limpia
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Text(
                      'Water Eject',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (widget.onSwitchTheme != null)
                      IconButton(
                        icon: const Icon(Icons.style, color: Colors.tealAccent),
                        tooltip: 'Cambiar Estilo Visual',
                        onPressed: widget.onSwitchTheme,
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),

                // Tarjeta Glassmorphic con Icono de Gota y Estado
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.opacity,
                            size: 40,
                            color: Colors.tealAccent.shade100,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isEjecting ? 'Expulsando Agua de Altavoces' : 'Listo para Limpieza Acústica',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Generando onda senoidal de 165 Hz',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                          if (_isEjecting) ...[
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tiempo restante: ${_secondsRemaining}s',
                              style: const TextStyle(color: Colors.tealAccent, fontSize: 13),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Botón Circular Aqua Minimalista
                GestureDetector(
                  onTap: _toggleEjection,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isEjecting ? const Color(0xFFE53935) : const Color(0xFF00B4D8),
                      boxShadow: [
                        BoxShadow(
                          color: (_isEjecting ? const Color(0xFFE53935) : const Color(0xFF00B4D8)).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isEjecting ? Icons.stop_rounded : Icons.play_arrow_rounded,
                            size: 56,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isEjecting ? 'Parar' : 'Comenzar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Recomendaciones
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up, color: Colors.tealAccent, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Asegúrate de colocar el volumen al máximo',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
