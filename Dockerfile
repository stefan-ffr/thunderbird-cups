FROM jlesage/thunderbird:latest

LABEL maintainer="stefan-ffr"
LABEL description="Thunderbird with integrated CUPS print server"
LABEL version="1.0"

# Als root für Installation
USER root

# CUPS und alle Druckertreiber installieren
# Hinweis: Einige Pakete sind in Alpine nicht verfügbar oder haben andere Namen
RUN apk add --no-cache \
    cups \
    cups-client \
    cups-filters \
    cups-pdf \
    ghostscript \
    avahi \
    avahi-tools \
    hplip \
    gutenprint \
    foomatic-db \
    foomatic-db-engine \
    && rm -rf /var/cache/apk/*

# CUPS-Verzeichnisse erstellen
RUN mkdir -p \
    /var/spool/cups \
    /var/cache/cups \
    /var/log/cups \
    /etc/cups/ppd \
    && chmod 755 /var/spool/cups /var/cache/cups /var/log/cups

# CUPS-Konfiguration anpassen
RUN cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.original && \
    # Erlaube Zugriff von allen Interfaces
    sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    # Server-Alias setzen
    echo 'ServerAlias *' >> /etc/cups/cupsd.conf && \
    # Browsing aktivieren
    sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
    # Admin-Zugriff erlauben (für Docker-Container sicher)
    sed -i '/<Location \//a\  Order allow,deny\n  Allow all' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/admin/a\  Order allow,deny\n  Allow all' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/admin\/conf/a\  Order allow,deny\n  Allow all' /etc/cups/cupsd.conf

# Startup-Skript für CUPS
COPY rootfs/ /

# Startup-Skript ausführbar machen
RUN chmod +x /etc/cont-init.d/95-cups.sh

# CUPS-Port freigeben
EXPOSE 631

# Zurück zum Standard-User
USER app

# Health Check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD lpstat -r || exit 1

# Standard Entrypoint bleibt erhalten
# CUPS wird über startup-cups.sh gestartet
