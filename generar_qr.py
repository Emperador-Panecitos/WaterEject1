import qrcode

# Sustituye esto por el enlace publico de tu APK o de tu despliegue en Vercel
apk_url = "https://water-eject.vercel.app"

qr = qrcode.QRCode(
    version=5,
    box_size=12,
    border=4
)
qr.add_data(apk_url)
qr.make(fit=True)

imagen = qr.make_image(
    fill_color="black",
    back_color="white"
)
imagen.save("WaterEject_QR.png")
print("QR creado correctamente: WaterEject_QR.png")
