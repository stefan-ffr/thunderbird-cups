# Thunderbird + CUPS

Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver in einem Docker-Container.

## 🚀 Quick Start

```bash
docker run -d \
  --name thunderbird-cups \
  -p 5800:5800 \
  -p 631:631 \
  -v ./data/thunderbird:/config:rw \
  -v ./data/cups:/etc/cups:rw \
  -e PRINTER_NAME=Office_Drucker \
  -e PRINTER_URI=ipp://192.168.1.100/ipp/print \
  yourusername/thunderbird-cups:latest
```

Zugriff:
- **Thunderbird**: http://localhost:5800
- **CUPS**: http://localhost:631

## 📖 Dokumentation

Vollständige Dokumentation: https://github.com/yourusername/thunderbird-cups

## ✨ Features

- 🔥 All-in-One: Thunderbird + CUPS
- 🌐 Web-basiert
- 🖨️ CUPS integriert
- 🚀 Multi-Platform (AMD64, ARM64)
- 🔧 Auto-Konfiguration

## 🔧 Drucker-URIs

```bash
# IPP
PRINTER_URI=ipp://192.168.1.100/ipp/print

# Socket (Port 9100)
PRINTER_URI=socket://192.168.1.100:9100

# LPD
PRINTER_URI=lpd://192.168.1.100/PASSTHRU
```

## 📦 Tags

- `latest` - Neueste stabile Version
- `v1.0.0` - Spezifische Version
- `develop` - Entwicklungsversion

## 🐛 Issues

GitHub: https://github.com/yourusername/thunderbird-cups/issues
