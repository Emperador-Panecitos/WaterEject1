# Water Eject 💧

Aplicación móvil Android y plataforma web para expulsión de agua en altavoces mediante frecuencias calibradas a **165 Hz**.

## 📱 Características de la Aplicación

- **Frecuencia Acústica Óptima:** Generación de onda de 165 Hz calculada para desplazar gotas de agua acumuladas en las cavidades del altavoz.
- **Dos Diseños Visuales Disponibles:**
  1. **Modo Neón Profundo:** Interfaz oscura, anillos pulsantes reactivos cian/azul y medidor visual de frecuencia.
  2. **Modo Aqua Glassmorphism:** Fondo degradado marino y tarjeta translúcida esmerilada con indicador fluido.
  - *Ambos conservan el mismo nombre oficial: **Water Eject**.*
- **Prevención de fugas de memoria:** Generador WAV PCM en memoria de búfer fijo, sin duplicación de datos de audio.

---

## 🚀 Despliegue en Vercel

La carpeta `web/` contiene la página de destino con:
- Código QR para escaneo y descarga desde móviles Android.
- Probador de frecuencia interactivo en tiempo real con Web Audio API (165 Hz).
- Tarjetas interactivas de los dos diseños.

### Pasos para desplegar en Vercel:
1. Sube este repositorio a tu cuenta de **GitHub**.
2. Entra en [vercel.com](https://vercel.com) e inicia sesión.
3. Haz clic en **"Add New Project"** y selecciona tu repositorio `WaterEject`.
4. En **Root Directory**, selecciona la carpeta `web` (o déjalo en la raíz con el `vercel.json` incluido).
5. Haz clic en **Deploy**. En segundos tendrás tu enlace público oficial.

---

## ⚙️ Compilación Automática del APK (GitHub Actions)

No necesitas instalar Flutter ni el SDK de Android en tu computadora:
- Cada vez que hagas `git push` a la rama `main`, GitHub Actions compilará automáticamente el archivo `WaterEject.apk` en la nube.
- Puedes descargar el APK directamente desde la pestaña **Actions** o **Releases** de tu repositorio de GitHub.
