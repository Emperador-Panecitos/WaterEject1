import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Generador de tono optimizado para Water Eject.
/// Genera un buffer WAV PCM de 165 Hz en memoria una sola vez
/// para evitar duplicacion de datos o fugas de memoria.
class ToneGenerator {
  static const int sampleRate = 44100;
  static const double frequency = 165.0; // Frecuencia optima para expulsion de agua
  static const double durationSeconds = 3.0; // Duracion del loop en segundos

  static Uint8List? _cachedWavBytes;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Genera los bytes del archivo WAV con cabecera RIFF oficial de 44 bytes
  /// y ondas sinusoidales con pulsos sincronizados de alta energia.
  static Uint8List generateToneBytes({double freq = frequency, double duration = durationSeconds}) {
    if (_cachedWavBytes != null && freq == frequency && duration == durationSeconds) {
      return _cachedWavBytes!;
    }

    final int numSamples = (sampleRate * duration).round();
    final int subchunk2Size = numSamples * 2; // 16-bit = 2 bytes por muestra mono
    final int chunkSize = 36 + subchunk2Size;

    final ByteData byteData = ByteData(44 + subchunk2Size);

    // --- CABECERA RIFF (12 bytes) ---
    // "RIFF"
    byteData.setUint8(0, 0x52);
    byteData.setUint8(1, 0x49);
    byteData.setUint8(2, 0x46);
    byteData.setUint8(3, 0x46);
    // ChunkSize (little endian)
    byteData.setUint32(4, chunkSize, Endian.little);
    // "WAVE"
    byteData.setUint8(8, 0x57);
    byteData.setUint8(9, 0x41);
    byteData.setUint8(10, 0x56);
    byteData.setUint8(11, 0x45);

    // --- SUBCHUNK 1 "fmt " (24 bytes) ---
    // "fmt "
    byteData.setUint8(12, 0x66);
    byteData.setUint8(13, 0x6D);
    byteData.setUint8(14, 0x74);
    byteData.setUint8(15, 0x20);
    // Subchunk1Size = 16 (PCM estandar)
    byteData.setUint32(16, 16, Endian.little);
    // AudioFormat = 1 (Linear PCM)
    byteData.setUint16(20, 1, Endian.little);
    // NumChannels = 1 (Mono)
    byteData.setUint16(22, 1, Endian.little);
    // SampleRate = 44100
    byteData.setUint32(24, sampleRate, Endian.little);
    // ByteRate = SampleRate * NumChannels * BitsPerSample / 8
    byteData.setUint32(28, sampleRate * 2, Endian.little);
    // BlockAlign = NumChannels * BitsPerSample / 8
    byteData.setUint16(32, 2, Endian.little);
    // BitsPerSample = 16
    byteData.setUint16(34, 16, Endian.little);

    // --- SUBCHUNK 2 "data" (8 bytes + datos PCM) ---
    // "data"
    byteData.setUint8(36, 0x64);
    byteData.setUint8(37, 0x61);
    byteData.setUint8(38, 0x74);
    byteData.setUint8(39, 0x61);
    // Subchunk2Size
    byteData.setUint32(40, subchunk2Size, Endian.little);

    // --- MUESTRAS PCM DE AUDIO ---
    int offset = 44;
    for (int i = 0; i < numSamples; i++) {
      final double t = i / sampleRate;

      // Genera la onda base a 165Hz con pulso ritmico para sacudir las gotas de agua
      final double pulse = 0.85 + 0.15 * sin(2 * pi * 4.0 * t); // modulacion ritmica de 4Hz
      final double sampleValue = sin(2 * pi * freq * t) * pulse;

      // Normalizar a 16 bits (-32768 a 32767)
      final int pcmSample = (sampleValue * 32760).clamp(-32768, 32767).toInt();
      byteData.setInt16(offset, pcmSample, Endian.little);
      offset += 2;
    }

    _cachedWavBytes = byteData.buffer.asUint8List();
    return _cachedWavBytes!;
  }

  /// Inicia el tono continuo en bucle
  Future<void> startTone() async {
    final wavBytes = generateToneBytes();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(1.0);
    await _player.play(BytesSource(wavBytes));
    _isPlaying = true;
  }

  /// Detiene el tono
  Future<void> stopTone() async {
    await _player.stop();
    _isPlaying = false;
  }

  /// Libera los recursos del reproductor
  void dispose() {
    _player.dispose();
  }
}
