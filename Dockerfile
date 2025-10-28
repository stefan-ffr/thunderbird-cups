FROM jlesage/thunderbird:latest

LABEL maintainer="stefan-ffr"
LABEL description="Thunderbird with integrated CUPS print server"
LABEL version="1.0"

# Als root für Installation
USER root

# CUPS Core installieren (definitiv verfügbar in Alpine)
RUN apk add --no-cache \
    cups \
    cups-client \
    cups-filters \
    ghostscript \
    && rm -rf /var/cache/apk/*

# Optionale Pakete einzeln hinzufügen (falls verfügbar)
RUN apk add --no-cache avahi avahi-tools || true
RUN apk add --no-cache hplip || true
RUN apk add --no-cache gutenprint || true
RUN apk add --no-cache foomatic-db foomatic-db-engine || true
RUN apk add --no-cache cups-pdf || true

# CUPS-Verzeichnisse erstellen
RUN mkdir -p \
    /var/spool/cups \
    /var/cache/cups \
    /var/log/cups \
    /etc/cups/ppd \
    && chmod 755 /var/spool/cups /var/cache/cups /var/log/cups

# CUPS-Konfiguration anpassen
RUN cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.original 2>/dev/null || true && \
    sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf 2>/dev/null || true && \
    echo 'ServerAlias *' >> /etc/cups/cupsd.conf && \
    sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf 2>/dev/null || true

# Einfachere Admin-Zugriff-Konfiguration
RUN echo '<Location />' >> /etc/cups/cupsd.conf && \
    echo '  Order allow,deny' >> /etc/cups/cupsd.conf && \
    echo '  Allow all' >> /etc/cups/cupsd.conf && \
    echo '</Location>' >> /etc/cups/cupsd.conf && \
    echo '<Location /admin>' >> /etc/cups/cupsd.conf && \
    echo '  Order allow,deny' >> /etc/cups/cupsd.conf && \
    echo '  Allow all' >> /etc/cups/cupsd.conf && \
    echo '</Location>' >> /etc/cups/cupsd.conf

# Startup-Skript für CUPS
COPY rootfs/ /

# Startup-Skript ausführbar machen
RUN chmod +x /etc/cont-init.d/95-cups.sh 2>/dev/null || true

# CUPS-Port freigeben
EXPOSE 631

# Zurück zum Standard-User
USER app

# Health Check
HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
    CMD lpstat -r 2>/dev/null || exit 1

# Standard Entrypoint bleibt erhalten
# CUPS wird über 95-cups.sh gestartet
