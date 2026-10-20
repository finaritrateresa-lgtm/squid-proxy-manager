#!/bin/bash
# Script de gestion du blocage de domaines sous Squid

FICHIER="/etc/squid/sites_interdits.txt"

# S'assurer que le fichier existe
touch "$FICHIER"

clear
echo "=========================================="
echo "    GESTION DU FILTRAGE SQUID (SWG)      "
echo "=========================================="
echo "1. Afficher les sites bloqués"
echo "2. Ajouter un site à bloquer"
echo "3. Modifier un site existant"
echo "4. Supprimer un site"
echo "5. Quitter"
echo "=========================================="
read -p "Choix [1-5] : " choix

case $choix in
    1)
        echo -e "\n--- LISTE DES SITES ACTUELLEMENT BLOQUÉS ---"
        if [ ! -s "$FICHIER" ]; then
            echo "(La liste est actuellement vide)"
        else
            cat -n "$FICHIER"
        fi
        ;;
    2)
        read -p "Entrez le domaine à ajouter (ex: exemple.com) : " domaine
        if [ -n "$domaine" ]; then
            echo "$domaine" >> "$FICHIER"
            echo "[+] $domaine ajouté avec succès."
        fi
        ;;
    3)
        read -p "Ancien domaine à modifier : " ancien
        read -p "Nouveau domaine : " nouveau
        if [ -n "$ancien" ] && [ -n "$nouveau" ]; then
            sed -i "s/^$ancien$/$nouveau/g" "$FICHIER"
            echo "[~] $ancien a été remplacé par $nouveau."
        fi
        ;;
    4)
        read -p "Domaine à supprimer : " domaine
        if [ -n "$domaine" ]; then
            sed -i "/^$domaine$/d" "$FICHIER"
            echo "[-] $domaine supprimé."
        fi
        ;;
    5)
        echo "Au revoir !"
        exit 0
        ;;
    *)
        echo "Option invalide."
        exit 1
        ;;
esac

# Rechargement à chaud de la configuration de Squid
echo -e "\nApplication des modifications à Squid..."
systemctl reload squid
echo "✓ Service Squid rechargé !"