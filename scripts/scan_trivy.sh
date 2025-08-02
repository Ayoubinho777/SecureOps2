#!/bin/bash

# Configuration
OUTPUT_DIR="../reports"
DATE=$(date +%Y%m%d)

# Vérification de Trivy
if ! command -v trivy &> /dev/null; then
    echo "Installation de Trivy..."
    sudo apt-get install -y wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install -y trivy
fi

# Scan des images listées
echo "=== Scan Trivy démarré ==="
trivy image --security-checks vuln -f json -o "$OUTPUT_DIR/trivy-$DATE.json" alpine:latest

echo "✅ Scan terminé. Rapport: $OUTPUT_DIR/trivy-$DATE.json"
