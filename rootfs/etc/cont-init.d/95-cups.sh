#!/bin/sh
# CUPS Initialization Script
# Compatible with jlesage/baseimage

set -e

echo "[cont-init.d] Starting CUPS initialization..."

# CUPS-Verzeichnisse sicherstellen
mkdir -p /var/spool/cups /var/cache/cups /var/log/cups
chmod 755 /var/spool/cups /var/cache/cups /var/log/cups

# Konfiguration aus Umgebungsvariablen anpassen
if [ -n "${CUPS_ADMIN_USER}" ]; then
    echo "[cont-init.d] Configuring CUPS admin user..."
    # Admin-User könnte hier gesetzt werden
fi

# Drucker automatisch hinzufügen (falls Umgebungsvariablen gesetzt)
if [ -n "${PRINTER_NAME}" ] && [ -n "${PRINTER_URI}" ]; then
    echo "[cont-init.d] Auto-configuring printer: ${PRINTER_NAME}"
    # Wir speichern diese für später, wenn CUPS läuft
    mkdir -p /tmp/cups-autoconfig
    cat > /tmp/cups-autoconfig/printer.conf << EOF
NAME=${PRINTER_NAME}
URI=${PRINTER_URI}
DESC=${PRINTER_DESC:-Auto-configured printer}
EOF
fi

# CUPS im Hintergrund starten
echo "[cont-init.d] Starting CUPS daemon..."
cupsd

# Kurz warten bis CUPS bereit ist
sleep 2

# Drucker hinzufügen, falls konfiguriert
if [ -f /tmp/cups-autoconfig/printer.conf ]; then
    . /tmp/cups-autoconfig/printer.conf
    echo "[cont-init.d] Adding printer: ${NAME}"
    lpadmin -p "${NAME}" -v "${URI}" -D "${DESC}" -m everywhere -E 2>/dev/null || true
    
    # Als Standard setzen, falls gewünscht
    if [ "${SET_DEFAULT}" = "true" ]; then
        lpoptions -d "${NAME}" 2>/dev/null || true
    fi
    
    rm -rf /tmp/cups-autoconfig
fi

echo "[cont-init.d] CUPS initialization complete"
