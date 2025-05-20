#!/usr/bin/env bash
# This script extract aliases from Hugo content files and generates a redirect file for Carrd.
# Dependencies: yq

set -euo pipefail
BASE_REDIRECT_FILE="_redirects.base.carrd"
REDIRECT_FILE="_redirects.carrd"
CONTENT_DIR="content"
PREFIX_URL="https://info.associationcppt.fr"

ROOT_DIR=$(pwd)

echo -e "\n=========================="
echo -e "📦 Extraction des redirections de \033[1m$ROOT_DIR\033[0m"
echo -e "==========================\n"

# Clean up the previous redirect file
if [ -f "$ROOT_DIR/$REDIRECT_FILE" ]; then
    rm "$ROOT_DIR/$REDIRECT_FILE"
fi

# Add redirects from base file to output redirect file
if [ -f "$ROOT_DIR/$BASE_REDIRECT_FILE" ]; then
    echo -e "📄 \033[1m$ROOT_DIR/$BASE_REDIRECT_FILE\033[0m"
    while read -r line; do
        echo "$line" >> "$ROOT_DIR/$REDIRECT_FILE"
    done < "$ROOT_DIR/$BASE_REDIRECT_FILE"
fi

echo -e "\n# Hugo Articles redirects" >> "$ROOT_DIR/$REDIRECT_FILE"

find "$ROOT_DIR/$CONTENT_DIR" -name "index.md"  | while read -r file; do
    echo -e "📄 \033[1m$file\033[0m"

    # Extract frontmatter from the file
    frontmatter=$(awk '/^---/{f=!f; next} f' "$file")

    # Extract the URL and alias from the file
    aliases=$(echo "$frontmatter" | yq '.aliases // [] | .[]')

    # Generate the canonical URL
    canonical=$(echo "$file" | sed "s|^$ROOT_DIR/$CONTENT_DIR||" | sed 's|/index.md$||')

    # Generate the redirect lines
    for alias in $aliases; do
        cleaned_alias=$(echo "$alias" | sed 's:/*$::' | sed 's:^/*:/:')
        echo "$cleaned_alias=$PREFIX_URL$canonical" >> "$ROOT_DIR/$REDIRECT_FILE"
    done
done

echo -e "\n=========================="
echo -e "✅ Redirections Carrd générées dans \033[1m$ROOT_DIR/$REDIRECT_FILE\033[0m"
echo -e "==========================\n"
