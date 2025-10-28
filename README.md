# Thunderbird + CUPS Docker Image

[![Build and Push Docker Image](https://github.com/stefan-ffr/thunderbird-cups/actions/workflows/docker-build.yml/badge.svg)](https://github.com/stefan-ffr/thunderbird-cups/actions/workflows/docker-build.yml)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr-image-blue)](https://github.com/stefan-ffr/thunderbird-cups/pkgs/container/thunderbird-cups)

> Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver in einem Docker-Container

## ✨ Features

- 🔥 **All-in-One**: Thunderbird + CUPS in einem Container
- 🖨️ **CUPS integriert**: Vollständiger Druckserver ohne Host-Installation
- 🌐 **Web-basiert**: Zugriff über Browser, keine Installation nötig
- 🔧 **Auto-Konfiguration**: Drucker via Umgebungsvariablen einrichten
- 🚀 **Multi-Platform**: Unterstützt AMD64 und ARM64 (Raspberry Pi)
- 📦 **GitHub Actions**: Automatische Builds, keine Docker Hub Abhängigkeit
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
  ghcr.io/stefan-ffr/thunderbird-cups:latest
```

### Docker Compose (empfohlen)

```yaml
version: '3.8'

services:
  thunderbird-cups:
    image: ghcr.io/stefan-ffr/thunderbird-cups:latest
    container_name: thunderbird-cups
    restart: unless-stopped
    ports:
      - "5800:5800"
      - "631:631"
    volumes:
      - ./data/thunderbird:/config:rw
      - ./data/cups:/etc/cups:rw
    environment:
      - USER_ID=1000
      - GROUP_ID=1000
      - TZ=Europe/Zurich
      - LANG=de_CH.UTF-8
      - DISPLAY_WIDTH=1920
      - DISPLAY_HEIGHT=1080
      - DARK_MODE=1
      - PRINTER_NAME=Office_Drucker
      - PRINTER_URI=ipp://192.168.1.100/ipp/print
      - SET_DEFAULT=true
    cap_add:
      - NET_ADMIN
      - NET_RAW
```

Speichern Sie dies als `docker-compose.yml` und starten Sie mit:
```bash
docker-compose up -d
```

### Zugriff

- **Thunderbird**: http://localhost:5800
- **CUPS Web-Interface**: http://localhost:631

## 📦 Image pullen

```bash
docker pull ghcr.io/stefan-ffr/thunderbird-cups:latest
```

**Das Image ist öffentlich verfügbar** - keine Anmeldung erforderlich!

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

### Drucker-URI Beispiele

```bash
# IPP (Internet Printing Protocol) - für die meisten modernen Drucker
PRINTER_URI=ipp://192.168.1.100/ipp/print

# Socket/JetDirect (Port 9100) - HP und viele andere
PRINTER_URI=socket://192.168.1.100:9100

# LPD (Line Printer Daemon) - Brother, Epson
PRINTER_URI=lpd://192.168.1.100/PASSTHRU

# HTTP - für einige ältere Drucker
PRINTER_URI=http://192.168.1.100:80
```

## 🖨️ Drucker einrichten

### Option 1: Via Umgebungsvariablen (empfohlen)

Setzen Sie beim Container-Start:

```yaml
environment:
  - PRINTER_NAME=HP_Office
  - PRINTER_URI=ipp://192.168.1.100/ipp/print
  - PRINTER_DESC=HP LaserJet Pro im Büro
  - SET_DEFAULT=true
```

Der Drucker wird automatisch konfiguriert!

### Option 2: Via CUPS Web-Interface

1. Öffnen Sie: http://localhost:631
2. Gehen Sie zu: **Administration** → **Add Printer**
3. Wählen Sie Ihren Drucker oder geben Sie die URI ein
4. Folgen Sie dem Assistenten

### Option 3: Via Kommandozeile

```bash
# Drucker hinzufügen
docker exec thunderbird-cups lpadmin \
  -p Office_Drucker \
  -v ipp://192.168.1.100/ipp/print \
  -D "HP LaserJet Büro" \
  -m everywhere \
  -E

# Als Standard setzen
docker exec thunderbird-cups lpoptions -d Office_Drucker

# Status prüfen
docker exec thunderbird-cups lpstat -p -d
```

## 📧 Extensions installieren

### FiltQuilla (für erweiterte E-Mail-Filter)

```bash
# Verzeichnis erstellen
mkdir -p ./data/extensions

# FiltQuilla herunterladen
curl -L -o ./data/extensions/filtquilla.xpi \
  "https://addons.thunderbird.net/thunderbird/downloads/latest/filtquilla/addon-filtquilla-latest.xpi"

# Container neu starten
docker-compose restart
```

Nach dem Neustart ist FiltQuilla automatisch installiert!

### Weitere beliebte Extensions

```bash
# Thunderbird Conversations
curl -L -o ./data/extensions/conversations.xpi \
  "https://addons.thunderbird.net/thunderbird/downloads/latest/thunderbird-conversations/addon-thunderbird-conversations-latest.xpi"

# Nostalgy++ (Keyboard-Shortcuts)
curl -L -o ./data/extensions/nostalgy.xpi \
  "https://addons.thunderbird.net/thunderbird/downloads/latest/nostalgy-ng/addon-nostalgy-ng-latest.xpi"

# Container neu starten
docker-compose restart
```

## 🔄 Updates

### Container aktualisieren

```bash
# Neueste Version pullen
docker-compose pull

# Container mit neuer Version neu starten
docker-compose up -d
```

### Automatische Updates

GitHub Actions baut das Image automatisch:
- ✅ Bei jedem Push auf `main`
- ✅ Bei neuen Tags (`v1.0.0`, `v1.1.0`, etc.)
- ✅ Wöchentlich jeden Montag um 2 Uhr (für Sicherheitsupdates)

## 🔍 Troubleshooting

### Container startet nicht

```bash
# Logs anzeigen
docker logs thunderbird-cups

# Ausführliche Logs
docker logs -f thunderbird-cups

# Container-Status
docker ps -a | grep thunderbird
```

### Drucker nicht erreichbar

```bash
# Netzwerk testen
docker exec thunderbird-cups ping 192.168.1.100

# Port testen
docker exec thunderbird-cups telnet 192.168.1.100 631

# CUPS-Status prüfen
docker exec thunderbird-cups lpstat -t

# CUPS-Logs
docker exec thunderbird-cups tail -f /var/log/cups/error_log
```

### Extensions werden nicht geladen

```bash
# Extensions-Verzeichnis prüfen
ls -lh ./data/extensions/

# XPI-Dateien validieren
docker exec thunderbird-cups sh -c 'for xpi in /config/extensions/*.xpi; do unzip -t "$xpi" || echo "Defekt: $xpi"; done'

# Container neu starten
docker-compose restart
```

### CUPS Web-Interface nicht erreichbar

```bash
# Port-Mapping prüfen
docker port thunderbird-cups

# CUPS-Prozess prüfen
docker exec thunderbird-cups ps aux | grep cupsd

# CUPS neu starten
docker exec thunderbird-cups pkill cupsd
docker restart thunderbird-cups
```

## 📚 Basis-Image

Dieses Image basiert auf [jlesage/thunderbird](https://github.com/jlesage/docker-thunderbird):
- Alpine Linux (klein und effizient)
- Thunderbird (neueste Version)
- Web-basiertes GUI
- VNC-Support

**Zusätzlich installiert:**
- CUPS (vollständiger Druckserver)
- Druckertreiber: HP (HPLIP), Canon, Brother, Epson, etc.
- Avahi (Drucker-Discovery im Netzwerk)
- Ghostscript (PostScript/PDF-Verarbeitung)
- Gutenprint (erweiterte Druckertreiber)

## 🛠️ Volumes & Persistenz

| Volume | Beschreibung | Backup empfohlen |
|--------|--------------|------------------|
| `/config` | Thunderbird-Daten (E-Mails, Einstellungen, Konten) | ✅ **Kritisch** |
| `/config/extensions` | Installierte Extensions (XPI-Dateien) | ✅ Ja |
| `/etc/cups` | CUPS-Konfiguration (Drucker-Einstellungen) | ✅ Ja |
| `/var/spool/cups` | Druck-Warteschlange | ❌ Optional |
| `/var/cache/cups` | CUPS-Cache | ❌ Nein |
| `/var/log/cups` | CUPS-Logs | ❌ Optional |

### Backup erstellen

```bash
# Thunderbird + CUPS Konfiguration sichern
tar -czf thunderbird-backup-$(date +%Y%m%d).tar.gz ./data/

# Wiederherstellen
tar -xzf thunderbird-backup-YYYYMMDD.tar.gz
docker-compose restart
```

## 🔐 Sicherheit

### Für Produktiv-Einsatz empfohlen:

```yaml
environment:
  # HTTPS aktivieren
  - SECURE_CONNECTION=1
  
  # Login-Seite aktivieren
  - WEB_AUTHENTICATION=1
  - WEB_AUTHENTICATION_USERNAME=admin
  - WEB_AUTHENTICATION_PASSWORD=IhrSicheresPasswort123
```

### Mit Reverse Proxy (Nginx, Traefik, Caddy)

```nginx
server {
    listen 443 ssl;
    server_name thunderbird.ihre-domain.de;
    
    ssl_certificate /etc/letsencrypt/live/ihre-domain.de/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ihre-domain.de/privkey.pem;
    
    location / {
        proxy_pass http://localhost:5800;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🤝 Beitragen

Contributions sind willkommen!

1. Fork das Repository
2. Erstellen Sie einen Feature-Branch (`git checkout -b feature/amazing-feature`)
3. Commit Ihre Änderungen (`git commit -m 'Add amazing feature'`)
4. Push zum Branch (`git push origin feature/amazing-feature`)
5. Öffnen Sie einen Pull Request

## 📝 Lizenz

Dieses Projekt steht unter der MIT-Lizenz.

## 🙏 Credits

- [jlesage/docker-thunderbird](https://github.com/jlesage/docker-thunderbird) - Basis-Image
- [Thunderbird](https://www.thunderbird.net) - E-Mail-Client
- [CUPS](https://www.cups.org) - Druckserver

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/stefan-ffr/thunderbird-cups/issues)
- **Diskussionen**: [GitHub Discussions](https://github.com/stefan-ffr/thunderbird-cups/discussions)

---

**Made with ❤️ in der Schweiz 🇨🇭**
