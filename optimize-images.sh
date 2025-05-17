#!/usr/bin/env bash
# This script optimizes images in place in the current directory and its subdirectories.
# Dependencies: jpegoptim, oxipng, cwebp

set -euo pipefail

ROOT_DIR=$(pwd)
SUCCESS="✅"
FAIL="❌"

echo -e "\n=========================="
echo -e "📦 Optimisation des images dans \033[1m$ROOT_DIR\033[0m"
echo -e "==========================\n"

process_image() {
    local img="$1"
    local ext="${img##*.}"
    local webp="${img%.*}.webp"

    echo -e "🖼️  \033[1m$img\033[0m"

    # WebP conversion
    echo -n "    -> Génération de l'image WebP : "
    if cwebp -quiet -q 80 "$img" -o "$webp" > /dev/null; then
        echo -e "$SUCCESS"
    else
        echo -e "$FAIL"
    fi

    # JPEG optimization
    if [[ "$ext" == "jpg" || "$ext" == "jpeg" ]]; then
        echo -n "    -> Optimisation de l'image JPEG : "
        if jpegoptim --strip-all --all-progressive --max=85 "$img" > /dev/null; then
            echo -e "$SUCCESS"
        else
            echo -e "$FAIL"
        fi
    fi

    # PNG optimization
    if [[ "$ext" == "png" ]]; then
        echo -n "    -> Optimisation de l'image PNG : "
        if oxipng -o 4 --strip all "$img" > /dev/null; then
            echo -e "$SUCCESS"
        else
            echo -e "$FAIL"
        fi
    fi
}

# Find and optimize JPEG images
find "$ROOT_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) ! -path "*/resources/*" ! -path "*/public/*" | while read img; do
    process_image "$img"
done

# Find and optimize PNG images
find "$ROOT_DIR" -type f \( -iname "*.png" \) ! -path "*/resources/*" ! -path "*/public/*" | while read img; do
    process_image "$img"
done

echo -e "\n=========================="
echo -e "✅  \033[1mOptimisation terminée.\033[0m"
echo -e "==========================\n"
