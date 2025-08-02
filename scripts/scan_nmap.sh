#!/bin/bash

# Configuration
TARGETS_FILE="../config/targets.list"
OUTPUT_DIR="../reports"
DATE=$(date +%Y%m%d)

# Vérification des dépendances
command -v nmap >/dev/null 2>&1 || { 
    echo >&2 "Nmap n'est pas installé. Installation en cours...";
    sudo apt-get install -y nmap
}

# Création du dossier de rapports
mkdir -p "$OUTPUT_DIR"

echo "=== Scan Nmap démarré ==="
echo "Cibles: $(grep -v '^#' $TARGETS_FILE | tr '\n' ' ')"

# Scan complet avec détection de vulnérabilités
while read -r target; do
    if [[ -n "$target" && ! "$target" =~ ^# ]]; then
        echo "🔍 Scanning $target..."
        nmap -sV -T4 -O -F --script vuln -oN "$OUTPUT_DIR/nmap-$DATE.txt" "$target"
        
        # Conversion en HTML
        xsltproc "$OUTPUT_DIR/nmap-$DATE.txt" -o "$OUTPUT_DIR/nmap-$DATE.html"
    fi
done < "$TARGETS_FILE"

echo "✅ Scan terminé. Rapports:"
echo "- Texte: $OUTPUT_DIR/nmap-$DATE.txt"
echo "- HTML: $OUTPUT_DIR/nmap-$DATE.html"
