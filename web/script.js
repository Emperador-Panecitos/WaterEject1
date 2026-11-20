// Water Eject Web Audio Engine (165 Hz Tone Tester)
let audioCtx = null;
let oscillator = null;
let gainNode = null;
let pulseTimer = null;
let isPlaying = false;

const toneBtn = document.getElementById('toneBtn');
const toneIcon = document.getElementById('toneIcon');
const toneLabel = document.getElementById('toneLabel');
const toneStatus = document.getElementById('toneStatus');

function toggleAudio() {
  if (isPlaying) {
    stopTone();
  } else {
    startTone();
  }
}

function startTone() {
  const AudioContext = window.AudioContext || window.webkitAudioContext;
  audioCtx = new AudioContext();

  oscillator = audioCtx.createOscillator();
  gainNode = audioCtx.createGain();

  oscillator.type = 'sine';
  oscillator.frequency.setValueAtTime(165, audioCtx.currentTime); // 165 Hz frecuencia óptima

  // Modulación rítmica para simular pulsación de expulsión
  gainNode.gain.setValueAtTime(0.7, audioCtx.currentTime);

  let high = true;
  pulseTimer = setInterval(() => {
    if (!audioCtx) return;
    const now = audioCtx.currentTime;
    if (high) {
      gainNode.gain.cancelScheduledValues(now);
      gainNode.gain.linearRampToValueAtTime(0.2, now + 0.05);
    } else {
      gainNode.gain.cancelScheduledValues(now);
      gainNode.gain.linearRampToValueAtTime(0.85, now + 0.05);
    }
    high = !high;
  }, 250);

  oscillator.connect(gainNode);
  gainNode.connect(audioCtx.destination);
  oscillator.start();

  isPlaying = true;
  toneIcon.textContent = '⏹️';
  toneLabel.textContent = 'Detener Tono (165 Hz)';
  toneStatus.textContent = '🔊 Tono de 165 Hz activo';
  toneStatus.style.color = '#00E5FF';
}

function stopTone() {
  if (pulseTimer) clearInterval(pulseTimer);
  if (oscillator) {
    try {
      oscillator.stop();
      oscillator.disconnect();
    } catch (e) {}
  }
  if (audioCtx) {
    audioCtx.close();
    audioCtx = null;
  }
  isPlaying = false;
  toneIcon.textContent = '▶️';
  toneLabel.textContent = 'Reproducir Frecuencia (165 Hz)';
  toneStatus.textContent = 'Audio en reposo';
  toneStatus.style.color = 'var(--text-muted)';
}

if (toneBtn) {
  toneBtn.addEventListener('click', toggleAudio);
}
