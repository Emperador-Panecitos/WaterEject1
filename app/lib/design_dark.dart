import 'dart:async';
import 'package:flutter/material.dart';
import 'tone_generator.dart';

class DesignDark extends StatefulWidget {
  final VoidCallback? onSwitchTheme;

  const DesignDark({super.key, this.onSwitchTheme});

  @override
  State<DesignDark> createState() => _DesignDarkState();
}

class _DesignDarkState extends State<DesignDark> with SingleTickerProviderStateMixin {
  final ToneGenerator _toneGenerator = ToneGenerator();
  late AnimationController _pulseController;
  Timer? _countdownTimer;

  bool _isEjecting = false;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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

    _pulseController.repeat(reverse: true);
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
    _pulseController.stop();
    _pulseController.reset();
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
    _pulseController.dispose();
    _toneGenerator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Water Eject',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        actions: [
          if (widget.onSwitchTheme != null)
            IconButton(
              icon: const Icon(Icons.style_outlined, color: Colors.cyanAccent),
              tooltip: 'Cambiar Estilo Visual',
              onPressed: widget.onSwitchTheme,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Indicador de Frecuencia
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF131D2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isEjecting ? Colors.greenAccent : Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Frecuencia Acústica: 165 Hz',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Boton Central con Efecto Pulsante Neón
              Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final double scale = _isEjecting ? 1.0 + (_pulseController.value * 0.12) : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: GestureDetector(
                        onTap: _toggleEjection,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF0052D4)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withOpacity(_isEjecting ? 0.6 : 0.25),
                                blurRadius: _isEjecting ? 45 : 20,
                                spreadRadius: _isEjecting ? 12 : 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isEjecting ? Icons.waves : Icons.water_drop,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _isEjecting ? 'DETENER' : 'EXPULSAR',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),
                                if (_isEjecting) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    '${_secondsRemaining}s',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Tarjeta de Instrucciones
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF101726),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.cyanAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Instrucciones de Uso',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Sube el volumen de tu teléfono al 100%.\n'
                      '2. Coloca el teléfono con los altavoces hacia abajo.\n'
                      '3. Pulsa EXPULSAR y espera a que termine el ciclo.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
