# GitHub Repository Setup Anleitung

Komplette Anleitung zum Einrichten Ihres eigenen Thunderbird + CUPS Docker-Images mit automatischen Builds.

## 📋 Voraussetzungen

- GitHub Account
- Docker Hub Account (optional, für Docker Hub Deployment)
- Git installiert
- Docker installiert (für lokale Tests)

## 🚀 Schritt-für-Schritt Anleitung

### 1. Repository erstellen

#### Option A: Neues Repository auf GitHub

1. Gehen Sie zu https://github.com/new
2. Repository-Name: `thunderbird-cups`
3. Beschreibung: `Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver`
4. **Public** oder **Private** (je nach Wunsch)
5. **Nicht** "Initialize this repository with a README" auswählen
6. Klicken Sie auf **Create repository**

#### Option B: Von diesem Template

Falls Sie ein Template-Repository haben:
1. Klicken Sie auf **Use this template**
2. Geben Sie Ihrem Repository einen Namen
3. Wählen Sie Public/Private

### 2. Lokales Setup

```bash
# Repository klonen (ersetzen Sie yourusername)
git clone https://github.com/yourusername/thunderbird-cups.git
cd thunderbird-cups

# Alle Dateien von diesem Setup kopieren
# Stellen Sie sicher, dass folgende Dateien vorhanden sind:
# - Dockerfile
# - .dockerignore
# - .github/workflows/docker-build.yml
# - rootfs/etc/cont-init.d/95-cups.sh
# - docker-compose-github.yml
# - README.github.md (umbenennen zu README.md)
# - README.docker.md
```

### 3. Dateien anpassen

#### A. Dockerfile
Bereits fertig! Keine Änderungen nötig (außer Sie wollen zusätzliche Pakete).

#### B. GitHub Actions Workflow
`.github/workflows/docker-build.yml`:

```yaml
env:
  DOCKER_HUB_IMAGE: IHR_DOCKERHUB_USERNAME/thunderbird-cups
  GHCR_IMAGE: ghcr.io/${{ github.repository_owner }}/thunderbird-cups
```

Ersetzen Sie:
- `IHR_DOCKERHUB_USERNAME` → Ihr Docker Hub Username

#### C. docker-compose-github.yml

```yaml
image: IHR_DOCKERHUB_USERNAME/thunderbird-cups:latest
```

Ersetzen Sie `IHR_DOCKERHUB_USERNAME`.

#### D. README.md

Suchen und ersetzen Sie in `README.github.md` (dann umbenennen zu README.md):
- `yourusername` → Ihr GitHub/Docker Hub Username
- URLs aktualisieren

### 4. GitHub Secrets einrichten

Für automatische Builds zu Docker Hub:

1. Gehen Sie zu Ihrem Repository auf GitHub
2. Klicken Sie auf **Settings** → **Secrets and variables** → **Actions**
3. Klicken Sie auf **New repository secret**

Fügen Sie folgende Secrets hinzu:

#### DOCKERHUB_USERNAME
- **Name**: `DOCKERHUB_USERNAME`
- **Value**: Ihr Docker Hub Benutzername (z.B. `maxmustermann`)

#### DOCKERHUB_TOKEN
1. Gehen Sie zu https://hub.docker.com/settings/security
2. Klicken Sie auf **New Access Token**
3. Name: `GitHub Actions`
4. Access permissions: **Read, Write, Delete**
5. Klicken Sie auf **Generate**
6. Kopieren Sie den Token
7. Fügen Sie ihn als Secret hinzu:
   - **Name**: `DOCKERHUB_TOKEN`
   - **Value**: Der kopierte Token

### 5. Initiales Commit und Push

```bash
# Git-Status prüfen
git status

# Alle Dateien hinzufügen
git add .

# Commit erstellen
git commit -m "Initial commit: Thunderbird + CUPS Docker image"

# Zu GitHub pushen
git push origin main
```

### 6. Build beobachten

1. Gehen Sie zu Ihrem Repository auf GitHub
2. Klicken Sie auf den Tab **Actions**
3. Sie sollten einen laufenden Workflow sehen: "Build and Push Docker Image"
4. Klicken Sie darauf, um den Fortschritt zu sehen

Der Build dauert ca. 10-15 Minuten beim ersten Mal.

### 7. Image testen

Nachdem der Build erfolgreich war:

```bash
# Von Docker Hub pullen
docker pull IHR_USERNAME/thunderbird-cups:latest

# Oder von GitHub Container Registry
docker pull ghcr.io/IHR_USERNAME/thunderbird-cups:latest

# Container starten
docker run -d \
  --name thunderbird-cups \
  -p 5800:5800 \
  -p 631:631 \
  -v $(pwd)/data/thunderbird:/config:rw \
  -v $(pwd)/data/cups:/etc/cups:rw \
  IHR_USERNAME/thunderbird-cups:latest

# Testen
curl http://localhost:5800
```

### 8. Repository-Einstellungen optimieren

#### A. Repository-Beschreibung

1. Gehen Sie zu Ihrem Repository
2. Klicken Sie auf das ⚙️ (Settings) rechts oben
3. Fügen Sie hinzu:
   - **Description**: `Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver`
   - **Website**: `https://hub.docker.com/r/IHR_USERNAME/thunderbird-cups`
   - **Topics**: `docker`, `thunderbird`, `cups`, `email`, `printing`, `docker-image`

#### B. GitHub Pages aktivieren (optional)

Für eine schöne Projekt-Website:

1. Settings → Pages
2. Source: **Deploy from a branch**
3. Branch: **main** / **docs**
4. Speichern

#### C. Issues & Discussions

1. Settings → Features
2. Aktivieren Sie:
   - ✅ Issues
   - ✅ Discussions (für Community-Support)

## 🎯 Erweiterte Konfiguration

### Automatische Rebuilds

Der Workflow ist bereits konfiguriert für:
- ✅ Push auf `main` → Build
- ✅ Neue Tags (`v*`) → Build mit Version
- ✅ Pull Requests → Test-Build (ohne Push)
- ✅ Wöchentlich Montags 2 Uhr → Rebuild

### Eigene Tags erstellen

```bash
# Version Tag erstellen
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Oder für mehrere Tags
git tag v1.0.0
git tag v1.0
git tag v1
git push origin --tags
```

Dies erstellt automatisch:
- `yourusername/thunderbird-cups:v1.0.0`
- `yourusername/thunderbird-cups:v1.0`
- `yourusername/thunderbird-cups:v1`
- `yourusername/thunderbird-cups:latest`

### Multi-Platform Builds

Bereits konfiguriert für:
- `linux/amd64` (Standard PCs, Server)
- `linux/arm64` (Raspberry Pi 4, Apple Silicon)

Weitere Plattformen hinzufügen:

```yaml
platforms: linux/amd64,linux/arm64,linux/arm/v7
```

## 🔧 Troubleshooting

### Build schlägt fehl: "unauthorized"

**Problem**: Docker Hub Secrets nicht korrekt gesetzt

**Lösung**:
1. Überprüfen Sie `DOCKERHUB_USERNAME` und `DOCKERHUB_TOKEN`
2. Stellen Sie sicher, dass der Token gültig ist
3. Pushen Sie erneut

### Build schlägt fehl: Syntax-Fehler

**Problem**: Fehler im Dockerfile oder Skript

**Lösung**:
```bash
# Lokal testen
docker build -t test .

# Logs prüfen auf GitHub Actions
```

### Image wird nicht zu Docker Hub gepusht

**Problem**: Möglicherweise private Repository und Secrets fehlen

**Lösung**:
- Bei private Repos: Secrets müssen explizit gesetzt sein
- Workflow-Logs auf GitHub Actions prüfen

### "No space left on device"

**Problem**: GitHub Actions Runner hat nicht genug Speicher

**Lösung**: Multi-Stage Build oder kleineres Base-Image verwenden (bereits optimiert)

## 📦 Zusätzliche Optimierungen

### Docker Hub Auto-Description

Die README wird automatisch zu Docker Hub gepusht!

Datei: `README.docker.md` wird nach Docker Hub synchronisiert.

### Badge im README

Fügen Sie Badges hinzu (bereits in README.github.md enthalten):

```markdown
[![Build Status](https://github.com/yourusername/thunderbird-cups/actions/workflows/docker-build.yml/badge.svg)](https://github.com/yourusername/thunderbird-cups/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/yourusername/thunderbird-cups)](https://hub.docker.com/r/yourusername/thunderbird-cups)
```

### Dependabot für Basis-Image Updates

Erstellen Sie `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"
```

## 🎓 Best Practices

### 1. Versions-Tags
```bash
# Semantic Versioning verwenden
git tag v1.0.0
git tag v1.1.0
git tag v2.0.0
```

### 2. Changelog pflegen
Erstellen Sie `CHANGELOG.md` und pflegen Sie Änderungen.

### 3. Issues nutzen
Nutzen Sie GitHub Issues für Bug-Reports und Feature-Requests.

### 4. Tests hinzufügen
Fügen Sie Container-Tests zum Workflow hinzu:

```yaml
- name: Test Container
  run: |
    docker run -d --name test yourusername/thunderbird-cups:latest
    sleep 10
    docker logs test
    docker exec test lpstat -r
```

## 📚 Weiterführende Ressourcen

- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **Docker Build Push Action**: https://github.com/docker/build-push-action
- **Docker Hub**: https://hub.docker.com
- **GHCR**: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

## ✅ Checkliste

Vor dem Go-Live:

- [ ] Alle `yourusername` ersetzt
- [ ] Docker Hub Secrets gesetzt
- [ ] Initiales Commit gepusht
- [ ] Build erfolgreich
- [ ] Image lokal getestet
- [ ] README angepasst
- [ ] Repository-Beschreibung gesetzt
- [ ] Topics hinzugefügt
- [ ] Issues aktiviert

## 🎉 Fertig!

Sie haben jetzt:
- ✅ Automatische Docker-Builds via GitHub Actions
- ✅ Multi-Platform Support (AMD64, ARM64)
- ✅ Images auf Docker Hub und GHCR
- ✅ Wöchentliche Auto-Updates
- ✅ Professionelles CI/CD-Setup

Ihr Image ist jetzt verfügbar als:
```bash
docker pull yourusername/thunderbird-cups:latest
```

**Viel Erfolg mit Ihrem Projekt! 🚀**
