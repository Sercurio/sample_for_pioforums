#!/bin/bash

# Script pour synchroniser la génération CubeMX avec PlatformIO (Version Simplifiée)
# Ce script s'attend à ce que CubeMX génère les fichiers à la racine du projet.

set -e # Arrête le script si une commande échoue

# Le projet PIO est le dossier parent de ce script
PIO_PROJECT_DIR="$(dirname "$0")/.."

echo "--- Lancement du script de synchronisation (version simplifiée) ---"

# --- Emplacements des dossiers générés par CubeMX (à la racine) ---
CUBE_SRC_DIR="$PIO_PROJECT_DIR/Src"
CUBE_INC_DIR="$PIO_PROJECT_DIR/Inc"
CUBE_DRIVERS_DIR="$PIO_PROJECT_DIR/Drivers"
CUBE_MIDDLEWARES_DIR="$PIO_PROJECT_DIR/Middlewares"

# --- Destinations dans le projet PlatformIO ---
PIO_SRC_DEST="$PIO_PROJECT_DIR/src"
PIO_INC_DEST="$PIO_PROJECT_DIR/include"
PIO_LIB_DEST="$PIO_PROJECT_DIR/lib"

# --- 1. Nettoyage des anciennes configurations dans les dossiers PIO ---
echo "1. Nettoyage des anciennes configurations..."
rm -rf "$PIO_LIB_DEST/Drivers"
rm -rf "$PIO_LIB_DEST/Middlewares"
# find "$PIO_SRC_DEST" -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \) -delete
find "$PIO_INC_DEST" -maxdepth 1 -type f -name "*.h" -delete


# --- 2. Déplacement du nouveau contenu ---
echo "2. Déplacement des nouveaux fichiers..."

# Déplacer le contenu de Inc -> include
if [ -d "$CUBE_INC_DIR" ]; then
    cp -R "$CUBE_INC_DIR/." "$PIO_INC_DEST/"
fi

# Déplacer le contenu de Src -> src (sauf main.c)
# if [ -d "$CUBE_SRC_DIR" ]; then
#     # Sauvegarder main.c pour référence
#     mv "$CUBE_SRC_DIR/main.c" "$PIO_SRC_DEST/main.c.bak"
#     # Copier le reste
#     cp "$CUBE_SRC_DIR/"*.c "$PIO_SRC_DEST/" 2>/dev/null || true
#     cp "$CUBE_SRC_DIR/"*.h "$PIO_SRC_DEST/" 2>/dev/null || true
# fi

# --- 3. Nettoyage des dossiers vides laissés par CubeMX à la racine ---
echo "3. Nettoyage des dossiers temporaires..."
if [ -d "$CUBE_DRIVERS_DIR" ]; then
    rm -rf "$CUBE_DRIVERS_DIR"
fi
if [ -d "$CUBE_MIDDLEWARES_DIR" ]; then
    rm -rf "$CUBE_MIDDLEWARES_DIR" "$PIO_LIB_DEST/"
fi

rm -rf "$CUBE_INC_DIR"

# Supprimer le linker script
rm -rf "$PIO_PROJECT_DIR"/*.ld
# Supprimer le start script
rm -rf "$PIO_PROJECT_DIR"/*.s


echo "✅ Synchronisation terminée avec succès !"