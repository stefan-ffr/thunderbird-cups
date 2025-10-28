# Quick Setup Guide für stefan-ffr/thunderbird-cups

## 🚀 Repository ist bereit für: github.com/stefan-ffr/thunderbird-cups

### Schritt 1: Repository auf GitHub erstellen

1. Gehen Sie zu: https://github.com/new
2. Repository-Name: **thunderbird-cups**
3. Owner: **stefan-ffr**
4. Beschreibung: `Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver`
5. **Public** auswählen
6. **NICHT** "Initialize this repository with a README" anhaken
7. Klicken Sie auf **Create repository**

### Schritt 2: Dateien vorbereiten

```bash
# Neues Verzeichnis erstellen
mkdir thunderbird-cups
cd thunderbird-cups

# Dateien aus dem Paket kopieren
# Stellen Sie sicher, dass folgende Dateien vorhanden sind:
# - Dockerfile
# - .dockerignore
# - .github/workflows/docker-build.yml
# - rootfs/etc/cont-init.d/95-cups.sh
# - docker-compose.yml (von docker-compose-github.yml)
# - README.md (von README-stefan-ffr.md)
```

### Schritt 3: Git initialisieren und pushen

```bash
# Git initialisieren
git init
git branch -M main

# .gitignore erstellen
cat > .gitignore << 'EOF'
# Data
data/
*.tar.gz
*.zip

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Env
.env

# Logs
*.log
EOF

# Alle Dateien hinzufügen
git add .

# Initial Commit
git commit -m "Initial commit: Thunderbird + CUPS Docker image

- Dockerfile with CUPS integration
- GitHub Actions for automated builds
- Multi-platform support (amd64, arm64)
- Auto-printer configuration via environment variables
- FiltQuilla extension support
"

# Remote hinzufügen
git remote add origin https://github.com/stefan-ffr/thunderbird-cups.git

# Pushen
git push -u origin main
```

### Schritt 4: GitHub Actions Build beobachten

1. Gehen Sie zu: https://github.com/stefan-ffr/thunderbird-cups
2. Klicken Sie auf den Tab **Actions**
3. Sie sollten einen laufenden Workflow sehen: "Build and Push Docker Image"
4. Der Build dauert ca. 10-15 Minuten

### Schritt 5: Image öffentlich machen

Nach erfolgreichem Build:

1. Gehen Sie zu: https://github.com/stefan-ffr?tab=packages
2. Klicken Sie auf Ihr `thunderbird-cups` Package
3. **Package settings** (rechts) → **Change visibility**
4. Wählen Sie **Public**
5. Bestätigen Sie mit dem Repository-Namen

### Schritt 6: Image nutzen! 🎉

```bash
# Image pullen
docker pull ghcr.io/stefan-ffr/thunderbird-cups:latest

# Container starten
docker run -d \
  --name thunderbird-cups \
  -p 5800:5800 \
  -p 631:631 \
  -v ./data:/config:rw \
  -e PRINTER_NAME=Office_Drucker \
  -e PRINTER_URI=ipp://192.168.1.100/ipp/print \
  ghcr.io/stefan-ffr/thunderbird-cups:latest

# Zugriff
# Thunderbird: http://localhost:5800
# CUPS: http://localhost:631
```

## 📦 Docker Compose (empfohlen)

Erstellen Sie `docker-compose.yml`:

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

Starten mit:
```bash
docker-compose up -d
```

## 🔧 Wichtige Hinweise

### Keine Secrets nötig!
- ✅ GitHub Container Registry nutzt automatisch `GITHUB_TOKEN`
- ✅ Keine Docker Hub Credentials erforderlich
- ✅ Einfacher und sicherer

### Automatische Updates
Das Image wird automatisch neu gebaut:
- Bei jedem Push auf `main`
- Bei neuen Tags (`v1.0.0`)
- Wöchentlich (jeden Montag)

### Multi-Platform
Das Image funktioniert auf:
- ✅ AMD64 (Standard PCs, Server)
- ✅ ARM64 (Raspberry Pi 4, Apple Silicon)

## 📝 Nächste Schritte

1. **README optimieren**: Fügen Sie Screenshots hinzu
2. **Issues aktivieren**: Settings → Features → Issues
3. **Discussions aktivieren**: Settings → Features → Discussions
4. **Topics hinzufügen**: About → Topics: `docker`, `thunderbird`, `cups`, `printing`, `email`
5. **Releases erstellen**: Bei neuen Versionen Tags pushen

### Release erstellen

```bash
# Version Tag erstellen
git tag -a v1.0.0 -m "Release v1.0.0 - Initial release"
git push origin v1.0.0
```

Dies erstellt automatisch:
- `ghcr.io/stefan-ffr/thunderbird-cups:v1.0.0`
- `ghcr.io/stefan-ffr/thunderbird-cups:v1.0`
- `ghcr.io/stefan-ffr/thunderbird-cups:v1`
- `ghcr.io/stefan-ffr/thunderbird-cups:latest`

## 🎉 Fertig!

Ihr Image ist jetzt verfügbar als:
```bash
ghcr.io/stefan-ffr/thunderbird-cups:latest
```

Jeder kann es nutzen mit:
```bash
docker pull ghcr.io/stefan-ffr/thunderbird-cups:latest
```

**Keine weitere Konfiguration nötig!** 🚀

---

## 🆘 Troubleshooting

### Build schlägt fehl

```bash
# GitHub Actions Logs prüfen
# Repository → Actions → Workflow auswählen → Build logs

# Lokal testen
docker build -t test .
```

### Image ist privat

```bash
# Auf GitHub:
# Packages → thunderbird-cups → Package settings → Change visibility → Public
```

### Image wird nicht gepullt

```bash
# Prüfen ob öffentlich
# https://github.com/stefan-ffr/thunderbird-cups/pkgs/container/thunderbird-cups

# Ohne Anmeldung pullen
docker logout ghcr.io
docker pull ghcr.io/stefan-ffr/thunderbird-cups:latest
```

## 📚 Weitere Dokumentation

Im Repository:
- `README.md` - Hauptdokumentation
- `GITHUB_SETUP.md` - Detaillierte Anleitung
- `.github/workflows/docker-build.yml` - Workflow-Konfiguration

---

**Viel Erfolg mit Ihrem Image! 🎉**
