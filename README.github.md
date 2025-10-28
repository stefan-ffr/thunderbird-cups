# Thunderbird + CUPS Docker Image

[![Build and Push Docker Image](https://github.com/yourusername/thunderbird-cups/actions/workflows/docker-build.yml/badge.svg)](https://github.com/yourusername/thunderbird-cups/actions/workflows/docker-build.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/yourusername/thunderbird-cups)](https://hub.docker.com/r/yourusername/thunderbird-cups)
[![Docker Image Size](https://img.shields.io/docker/image-size/yourusername/thunderbird-cups/latest)](https://hub.docker.com/r/yourusername/thunderbird-cups)

> Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver in einem Docker-Container

## ✨ Features

- 🔥 **All-in-One**: Thunderbird + CUPS in einem Container
- 🖨️ **CUPS integriert**: Vollständiger Druckserver ohne Host-Installation
- 🌐 **Web-basiert**: Zugriff über Browser, keine Installation nötig
- 🔧 **Auto-Konfiguration**: Drucker via Umgebungsvariablen einrichten
- 🚀 **Multi-Platform**: Unterstützt AMD64 und ARM64 (Raspberry Pi)
- 📦 **Fertig gebaut**: Automatische Builds via GitHub Actions
- 🔄 **FiltQuilla-ready**: Extension-Support vorbereitet

## 🚀 Schnellstart

### Docker CLI

```bash
docker run -d \
  --name thunderbird-cups \
  -p 5800:5800 \
  -p 631:631 \
  -v ./data/thunderbird:/config:rw \
  -v ./data/cups:/etc/cups:rw \
  -e TZ=Europe/Zurich \
  -e PRINTER_NAME=Office_Drucker \
  -e PRINTER_URI=ipp://192.168.1.100/ipp/print \
  yourusername/thunderbird-cups:latest
```

### Docker Compose (empfohlen)

```bash
# docker-compose.yml herunterladen
curl -o docker-compose.yml https://raw.githubusercontent.com/yourusername/thunderbird-cups/main/docker-compose-github.yml

# Container starten
docker-compose up -d
```

### Zugriff

- **Thunderbird**: http://localhost:5800
- **CUPS Web-Interface**: http://localhost:631

## 📦 Image-Quellen

Das fertige Image ist verfügbar auf:

- **Docker Hub**: `docker pull yourusername/thunderbird-cups:latest`
- **GitHub Container Registry**: `docker pull ghcr.io/yourusername/thunderbird-cups:latest`

## 🔧 Konfiguration

### Umgebungsvariablen

#### Grundeinstellungen

| Variable | Beschreibung | Standard |
|----------|--------------|----------|
| `USER_ID` | User-ID des Containers | `1000` |
| `GROUP_ID` | Group-ID des Containers | `1000` |
| `TZ` | Zeitzone | `Etc/UTC` |
| `LANG` | Sprache/Locale | `en_US.UTF-8` |

#### Display

| Variable | Beschreibung | Standard |
|----------|--------------|----------|
| `DISPLAY_WIDTH` | Bildschirmbreite | `1920` |
| `DISPLAY_HEIGHT` | Bildschirmhöhe | `1080` |
| `DARK_MODE` | Dunkles Theme (0 oder 1) | `0` |

#### Drucker (automatische Konfiguration)

| Variable | Beschreibung | Beispiel |
|----------|--------------|----------|
| `PRINTER_NAME` | Druckername | `Office_Drucker` |
| `PRINTER_URI` | Drucker-URI | `ipp://192.168.1.100/ipp/print` |
| `PRINTER_DESC` | Beschreibung | `HP LaserJet Büro` |
| `SET_DEFAULT` | Als Standard setzen | `true` |

#### Sicherheit

| Variable | Beschreibung | Standard |
|----------|--------------|----------|
| `SECURE_CONNECTION` | HTTPS aktivieren (0 oder 1) | `0` |
| `WEB_AUTHENTICATION` | Login-Seite aktivieren (0 oder 1) | `0` |
| `WEB_AUTHENTICATION_USERNAME` | Benutzername | - |
| `WEB_AUTHENTICATION_PASSWORD` | Passwort | - |

### Drucker-URI Beispiele

```yaml
# IPP (Internet Printing Protocol)
PRINTER_URI=ipp://192.168.1.100/ipp/print

# Socket/JetDirect (Port 9100)
PRINTER_URI=socket://192.168.1.100:9100

# LPD (Line Printer Daemon)
PRINTER_URI=lpd://192.168.1.100/PASSTHRU

# HTTP
PRINTER_URI=http://192.168.1.100:80
```

## 🖨️ Drucker einrichten

### Option 1: Via Umgebungsvariablen (beim Start)

```yaml
environment:
  - PRINTER_NAME=HP_Office
  - PRINTER_URI=ipp://192.168.1.100/ipp/print
  - PRINTER_DESC=HP LaserJet Pro
  - SET_DEFAULT=true
```

### Option 2: Via CUPS Web-Interface

1. Öffnen Sie: http://localhost:631
2. Gehen Sie zu: **Administration** → **Add Printer**
3. Wählen Sie Ihren Drucker oder geben Sie die URI ein
4. Folgen Sie dem Assistenten

### Option 3: Via Kommandozeile

```bash
docker exec thunderbird-cups lpadmin \
  -p Office_Drucker \
  -v ipp://192.168.1.100/ipp/print \
  -m everywhere \
  -E

# Als Standard setzen
docker exec thunderbird-cups lpoptions -d Office_Drucker
```

## 📧 Extensions installieren

### FiltQuilla

```bash
# Verzeichnis erstellen
mkdir -p ./data/extensions

# FiltQuilla herunterladen
curl -L -o ./data/extensions/filtquilla.xpi \
  "https://addons.thunderbird.net/thunderbird/downloads/latest/filtquilla/addon-filtquilla-latest.xpi"

# Container neu starten
docker-compose restart
```

### Weitere Extensions

Kopieren Sie XPI-Dateien nach `./data/extensions/` und starten Sie den Container neu.

## 🏗️ Eigenes Image bauen

### Voraussetzungen

- Docker & Docker Compose
- GitHub Account
- Docker Hub Account (optional)

### Repository forken und anpassen

1. **Forken Sie dieses Repository**

2. **Passen Sie die Dateien an:**
   - `.github/workflows/docker-build.yml`: Ändern Sie `yourusername` zu Ihrem GitHub-Username
   - `docker-compose-github.yml`: Ändern Sie den Image-Namen
   - `Dockerfile`: Nach Bedarf anpassen

3. **GitHub Secrets einrichten:**
   - Gehen Sie zu: Settings → Secrets and variables → Actions
   - Fügen Sie hinzu:
     - `DOCKERHUB_USERNAME`: Ihr Docker Hub Benutzername
     - `DOCKERHUB_TOKEN`: Ihr Docker Hub Access Token

4. **Build auslösen:**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

   GitHub Actions baut automatisch das Image und pusht es zu Docker Hub und GHCR.

### Lokaler Build

```bash
# Image bauen
docker build -t thunderbird-cups:latest .

# Oder mit Docker Compose
docker-compose build

# Starten
docker-compose up -d
```

## 🔄 Updates

### Image aktualisieren

```bash
docker-compose pull
docker-compose up -d
```

### Automatische Updates

GitHub Actions baut das Image automatisch:
- Bei jedem Push auf `main`
- Bei neuen Tags (`v1.0.0`)
- Wöchentlich (jeden Montag)

## 📊 Vergleich mit anderen Lösungen

| Lösung | Container | Build nötig | Wartung | Flexibilität |
|--------|-----------|-------------|---------|--------------|
| **Dieses Image** | 1 | ❌ Nein | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Separate Container | 2 | ❌ Nein | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Host-CUPS | 1 | ❌ Nein | ⭐⭐⭐ | ⭐⭐⭐ |
| Custom Build | 2 | ✅ Ja | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

**Vorteil dieses Images:**
- ✅ Fertig gebaut und getestet
- ✅ Nur ein Container
- ✅ Automatische Updates
- ✅ Multi-Platform Support

## 🛠️ Volumes

| Volume | Beschreibung | Backup empfohlen |
|--------|--------------|------------------|
| `/config` | Thunderbird-Daten (E-Mails, Einstellungen) | ✅ Ja |
| `/config/extensions` | Extensions (XPI-Dateien) | ✅ Ja |
| `/etc/cups` | CUPS-Konfiguration (Drucker) | ✅ Ja |
| `/var/spool/cups` | Druck-Warteschlange | ❌ Optional |
| `/var/cache/cups` | CUPS-Cache | ❌ Nein |
| `/var/log/cups` | CUPS-Logs | ❌ Optional |

## 🔍 Troubleshooting

### Container startet nicht

```bash
# Logs anzeigen
docker logs thunderbird-cups

# Health Status prüfen
docker inspect thunderbird-cups | grep -A 10 Health
```

### Drucker nicht erreichbar

```bash
# Netzwerk testen
docker exec thunderbird-cups ping 192.168.1.100

# CUPS-Status prüfen
docker exec thunderbird-cups lpstat -t

# CUPS-Logs
docker exec thunderbird-cups tail -f /var/log/cups/error_log
```

### Extensions funktionieren nicht

```bash
# Extensions prüfen
ls -lh ./data/extensions/

# Container neu starten
docker-compose restart
```

## 📚 Basis-Image

Dieses Image basiert auf [jlesage/thunderbird](https://github.com/jlesage/docker-thunderbird):
- Alpine Linux
- Thunderbird (neueste Version)
- Web-basiertes GUI
- VNC-Support

**Zusätzlich installiert:**
- CUPS (Druckserver)
- Druckertreiber (HP, Canon, Brother, Epson)
- Avahi (Drucker-Discovery)

## 🤝 Beitragen

Contributions sind willkommen!

1. Fork das Repository
2. Erstellen Sie einen Feature-Branch (`git checkout -b feature/amazing-feature`)
3. Commit Ihre Änderungen (`git commit -m 'Add amazing feature'`)
4. Push zum Branch (`git push origin feature/amazing-feature`)
5. Öffnen Sie einen Pull Request

## 📝 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE) für Details.

## 🙏 Credits

- [jlesage/docker-thunderbird](https://github.com/jlesage/docker-thunderbird) - Basis-Image
- [Thunderbird](https://www.thunderbird.net) - E-Mail-Client
- [CUPS](https://www.cups.org) - Druckserver

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/thunderbird-cups/issues)
- **Diskussionen**: [GitHub Discussions](https://github.com/yourusername/thunderbird-cups/discussions)
- **Docker Hub**: [yourusername/thunderbird-cups](https://hub.docker.com/r/yourusername/thunderbird-cups)

## 🗺️ Roadmap

- [x] CUPS-Integration
- [x] GitHub Actions CI/CD
- [x] Multi-Platform Builds
- [x] Auto-Drucker-Konfiguration
- [ ] Mehrere Drucker via Umgebungsvariablen
- [ ] Vorinstallierte Extensions
- [ ] Automatische Extension-Updates
- [ ] CUPS-Authentifizierung

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/thunderbird-cups&type=Date)](https://star-history.com/#yourusername/thunderbird-cups&Date)

---

**Made with ❤️ for the Thunderbird community**
