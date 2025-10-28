#!/bin/bash
# Automatisches Setup für Thunderbird-CUPS GitHub Repository

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

success() { echo -e "${GREEN}✓ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; }
info() { echo -e "${BLUE}ℹ $1${NC}"; }

clear
cat << "EOF"
╔════════════════════════════════════════════════════════╗
║                                                        ║
║    Thunderbird + CUPS GitHub Repository Setup         ║
║    Automatische Docker-Builds mit GitHub Actions      ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
EOF
echo ""

# Git prüfen
if ! command -v git &> /dev/null; then
    error "Git ist nicht installiert!"
    exit 1
fi

success "Git gefunden"

# Benutzer-Informationen abfragen
echo ""
info "=== Benutzer-Informationen ==="
echo ""

read -p "Ihr GitHub-Benutzername: " GITHUB_USER
read -p "Ihr Docker Hub-Benutzername (Enter für gleichen Namen): " DOCKER_USER
DOCKER_USER=${DOCKER_USER:-$GITHUB_USER}

read -p "Repository-Name [thunderbird-cups]: " REPO_NAME
REPO_NAME=${REPO_NAME:-thunderbird-cups}

read -p "Ihre E-Mail-Adresse: " EMAIL

echo ""
info "Zusammenfassung:"
echo "  GitHub-User: ${GITHUB_USER}"
echo "  Docker Hub-User: ${DOCKER_USER}"
echo "  Repository: ${REPO_NAME}"
echo "  E-Mail: ${EMAIL}"
echo ""
read -p "Korrekt? (j/n): " confirm

if [[ ! "$confirm" =~ ^[Jj]$ ]]; then
    error "Abgebrochen"
    exit 1
fi

# Verzeichnis erstellen
echo ""
info "=== Repository-Struktur erstellen ==="
echo ""

if [ -d "$REPO_NAME" ]; then
    warning "Verzeichnis ${REPO_NAME} existiert bereits"
    read -p "Überschreiben? (j/n): " overwrite
    if [[ "$overwrite" =~ ^[Jj]$ ]]; then
        rm -rf "$REPO_NAME"
    else
        error "Abgebrochen"
        exit 1
    fi
fi

mkdir -p "$REPO_NAME"
cd "$REPO_NAME"

success "Verzeichnis erstellt: ${REPO_NAME}"

# Git initialisieren
info "Git Repository initialisieren..."
git init
git branch -M main

# Dateien erstellen
info "Erstelle Projekt-Dateien..."

# .gitignore
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

success ".gitignore erstellt"

# Benötigte Verzeichnisse
mkdir -p .github/workflows
mkdir -p rootfs/etc/cont-init.d
mkdir -p docs

success "Verzeichnis-Struktur erstellt"

# README erstellen
info "Erstelle README.md..."

cat > README.md << EOF
# ${REPO_NAME}

[![Build and Push Docker Image](https://github.com/${GITHUB_USER}/${REPO_NAME}/actions/workflows/docker-build.yml/badge.svg)](https://github.com/${GITHUB_USER}/${REPO_NAME}/actions/workflows/docker-build.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/${DOCKER_USER}/${REPO_NAME})](https://hub.docker.com/r/${DOCKER_USER}/${REPO_NAME})

> Thunderbird E-Mail-Client mit integriertem CUPS-Druckserver

## 🚀 Quick Start

\`\`\`bash
docker run -d \\
  --name thunderbird-cups \\
  -p 5800:5800 \\
  -p 631:631 \\
  -v ./data/thunderbird:/config:rw \\
  -v ./data/cups:/etc/cups:rw \\
  -e PRINTER_NAME=Office_Drucker \\
  -e PRINTER_URI=ipp://192.168.1.100/ipp/print \\
  ${DOCKER_USER}/${REPO_NAME}:latest
\`\`\`

**Zugriff:**
- Thunderbird: http://localhost:5800
- CUPS: http://localhost:631

## 📖 Dokumentation

Siehe [GITHUB_SETUP.md](docs/GITHUB_SETUP.md) für vollständige Dokumentation.

## ✨ Features

- 🔥 All-in-One: Thunderbird + CUPS in einem Container
- 🌐 Web-basierter Zugriff
- 🖨️ CUPS komplett integriert
- 🚀 Multi-Platform: AMD64 & ARM64
- 🔧 Auto-Konfiguration via Umgebungsvariablen

## 🐛 Support

Issues: https://github.com/${GITHUB_USER}/${REPO_NAME}/issues

## 📝 Lizenz

MIT License - siehe LICENSE
EOF

success "README.md erstellt"

# LICENSE
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

success "LICENSE erstellt"

# Dockerfile muss von den vorhandenen Dateien kopiert werden
info "Bitte kopieren Sie folgende Dateien manuell in dieses Verzeichnis:"
echo "  - Dockerfile"
echo "  - .dockerignore"
echo "  - rootfs/etc/cont-init.d/95-cups.sh"
echo "  - .github/workflows/docker-build.yml (mit angepassten Usernamen)"
echo "  - docker-compose.yml"
echo ""
echo "Diese Dateien sollten bereits vorhanden sein."
echo ""

read -p "Dateien kopiert? (j/n): " files_copied

if [[ ! "$files_copied" =~ ^[Jj]$ ]]; then
    warning "Bitte kopieren Sie die Dateien und führen Sie das Skript erneut aus"
    exit 0
fi

# Git Commit
echo ""
info "=== Git Initial Commit ==="
echo ""

git add .
git commit -m "Initial commit: Thunderbird + CUPS Docker image

- Dockerfile with CUPS integration
- GitHub Actions for automated builds
- Multi-platform support (amd64, arm64)
- Auto-printer configuration
"

success "Initial Commit erstellt"

# Remote hinzufügen
echo ""
info "=== GitHub Remote konfigurieren ==="
echo ""

REPO_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "Füge Remote hinzu: ${REPO_URL}"
git remote add origin "$REPO_URL"

success "Remote hinzugefügt"

# Zusammenfassung
echo ""
info "╔════════════════════════════════════════════════════════╗"
info "║              Setup abgeschlossen!                      ║"
info "╚════════════════════════════════════════════════════════╝"
echo ""

echo "📋 Nächste Schritte:"
echo ""
echo "1. Erstellen Sie das Repository auf GitHub:"
echo "   https://github.com/new"
echo "   Name: ${REPO_NAME}"
echo ""
echo "2. Pushen Sie den Code:"
echo "   ${YELLOW}cd ${REPO_NAME}${NC}"
echo "   ${YELLOW}git push -u origin main${NC}"
echo ""
echo "3. Richten Sie GitHub Secrets ein:"
echo "   Repository → Settings → Secrets → Actions"
echo "   - DOCKERHUB_USERNAME: ${DOCKER_USER}"
echo "   - DOCKERHUB_TOKEN: (von https://hub.docker.com/settings/security)"
echo ""
echo "4. GitHub Actions wird automatisch das Image bauen!"
echo ""
echo "📦 Ihr Image wird verfügbar sein als:"
echo "   ${GREEN}docker pull ${DOCKER_USER}/${REPO_NAME}:latest${NC}"
echo "   ${GREEN}docker pull ghcr.io/${GITHUB_USER}/${REPO_NAME}:latest${NC}"
echo ""
echo "📖 Vollständige Dokumentation:"
echo "   Siehe docs/GITHUB_SETUP.md"
echo ""

success "Viel Erfolg mit Ihrem Projekt! 🚀"
