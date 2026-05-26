#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#   🐅 PVL BLOG MANAGER — El Tigre Edition v3 (Premium)
#   Gestión Avanzada: Blog, Historias, Fotos, Diario y CV
#   Autor: Pavel Gomez | Cuernavaca, MX
# ═══════════════════════════════════════════════════════════════

# ─── CONFIGURACIÓN DE RUTAS ───────────────────────────────────
BLOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CV_DIR="$HOME/Documents/cv-pavel-gomez"

# ─── PALETA DE COLORES MATE & PREMIUM (Nord/Dracula Theme) ────
RESET="\033[0m"
BOLD="\033[1m"
TIGER="\033[38;5;208m"       # Naranja atenuado
GOLD="\033[38;5;178m"        # Dorado mate antiguo
GREEN="\033[38;5;108m"       # Verde salvia mate
BLUE="\033[38;5;67m"         # Azul acero lavado
RED="\033[38;5;131m"         # Terracota / Rojo oscuro
MUTED="\033[38;5;240m"       # Gris carbón oscuro
WHITE="\033[38;5;250m"       # Blanco hueso
CYAN="\033[38;5;72m"         # Verde azulado mate

# ─── UI HELPERS ───────────────────────────────────────────────
clear_screen() { clear; }

print_header() {
  clear_screen
  echo -e "${TIGER}"
  echo "  ██████╗ ██╗   ██╗██╗         ██████╗ ██╗      ██████╗  ██████╗ "
  echo "  ██╔══██╗██║   ██║██║         ██╔══██╗██║     ██╔═══██╗██╔════╝ "
  echo "  ██████╔╝██║   ██║██║         ██████╔╝██║     ██║   ██║██║  ███╗"
  echo "  ██╔═══╝ ╚██╗ ██╔╝██║         ██╔══██╗██║     ██║   ██║██║   ██║"
  echo "  ██║      ╚████╔╝ ███████╗    ██████╔╝███████╗╚██████╔╝╚██████╔╝"
  echo "  ╚═╝       ╚═══╝  ╚══════╝    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ "
  echo -e "${RESET}"
  echo -e "  ${MUTED}──────────────────────────────────────────────────────────────────${RESET}"
  echo -e "  ${GOLD}${BOLD}  Pavel Gomez — Blog Manager ${TIGER}\"El Tigre Premium v3\"${RESET}"
  echo -e "  ${MUTED}  Cuernavaca, MX · pvl.gom3z@gmail.com · https://pvl-blog.netlify.app/${RESET}"
  echo -e "  ${MUTED}──────────────────────────────────────────────────────────────────${RESET}"
  _check_repo_status "$CV_DIR"   "📄 CV Actual "
  _check_repo_status "$BLOG_DIR" "✍️  Blog Nuevo"
  echo ""
}

_check_repo_status() {
  local dir="$1"
  local label="$2"
  if [ -d "$dir/.git" ]; then
    local branch dirty
    branch=$(git -C "$dir" branch --show-current 2>/dev/null)
    dirty=$(git -C "$dir" status --short 2>/dev/null | wc -l | tr -d ' ')
    if [ "$dirty" -gt 0 ]; then
      echo -e "  ${GOLD}●${RESET} ${label}: ${MUTED}${dir/$HOME/\~}${RESET} ${GOLD}[${dirty} cambios pendientes]${RESET}"
    else
      echo -e "  ${GREEN}●${RESET} ${label}: ${MUTED}${dir/$HOME/\~}${RESET} ${GREEN}[limpio · ${branch}]${RESET}"
    fi
  else
    echo -e "  ${RED}○${RESET} ${label}: ${MUTED}${dir/$HOME/\~} [no encontrado]${RESET}"
  fi
}

print_sep()     { echo -e "  ${MUTED}──────────────────────────────────────────────────────────────────${RESET}"; }
print_ok()      { echo -e "  ${GREEN}✓${RESET} $1"; }
print_err()     { echo -e "  ${RED}✗ ERROR:${RESET} $1"; }
print_info()    { echo -e "  ${BLUE}→${RESET} $1"; }
print_warn()    { echo -e "  ${GOLD}⚠ ADVERTENCIA:${RESET} $1"; }
wait_key()      { echo ""; echo -e "  ${MUTED}[Presiona cualquier tecla para continuar...]${RESET}"; read -rn1 -s; }

make_slug() {
  echo "$1" | tr '[:upper:]' '[:lower:]' \
    | sed 's/[áàäâ]/a/g;s/[éèëê]/e/g;s/[íìïî]/i/g;s/[óòöô]/o/g;s/[úùüû]/u/g;s/ñ/n/g' \
    | tr -cs '[:alnum:]' '-' | sed 's/^-//;s/-$//'
}

# ─── 1. NUEVA PUBLICACIÓN DIARIA (NUEVO SCRIPT) ───────────────
nueva_diario() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ PUBLICACIÓN DIARIA DE TEXTO (RÁPIDA)${RESET}\n"
  
  echo -e "  ${WHITE}¿Qué estás pensando hoy, Tigre? (Escribe tu texto libre):${RESET}"
  echo -ne "  ${MUTED}> ${RESET}"
  read -r texto_diario
  
  if [[ -z "$texto_diario" ]]; then
    print_err "Texto vacío. Cancelando diario."; wait_key; return
  fi

  local fecha slug filename filepath
  fecha=$(date +%Y-%m-%d)
  # Creamos un título automático usando las primeras palabras
  local titulo_corto
  titulo_corto=$(echo "$texto_diario" | cut -d' ' -f1-4)
  slug=$(make_slug "$titulo_corto")
  filename="${fecha}-${slug}.md"
  filepath="${BLOG_DIR}/src/diario/${filename}"
  
  mkdir -p "${BLOG_DIR}/src/diario"

  cat > "$filepath" << FRONT
---
layout: post.njk
title: "Bitácora: ${titulo_corto}..."
date: ${fecha}
category: "Diario"
emoji: "☕"
excerpt: "${texto_diario:0:60}..."
tags:
  - post
  - diario
---

## Pensamiento del día (${fecha})

${texto_diario}

---
*Escrito rápidamente desde la terminal de El Tigre Manager.*
FRONT

  echo ""
  print_ok "Entrada de diario guardada en: ${GOLD}src/diario/${filename}${RESET}"
  wait_key
}

# ─── 2. NUEVA ENTRADA DE HISTORIA ─────────────────────────────
nueva_historia() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ NUEVA HISTORIA PERSONAL${RESET}\n"

  echo -ne "  ${WHITE}Título de la historia: ${RESET}"; read -r titulo
  [[ -z "$titulo" ]] && { print_err "Título vacío."; wait_key; return; }

  echo -ne "  ${WHITE}Lugar del acontecimiento (ej: Utah, USA): ${RESET}"; read -r lugar
  echo -ne "  ${WHITE}Año (ej: 2019): ${RESET}"; read -r anio
  echo -ne "  ${WHITE}Extracto emotivo / Resumen: ${RESET}"; read -r extracto

  local fecha slug filename filepath
  fecha=$(date +%Y-%m-%d)
  slug=$(make_slug "$titulo")
  filename="${fecha}-${slug}.md"
  filepath="${BLOG_DIR}/src/stories/${filename}"
  
  mkdir -p "${BLOG_DIR}/src/stories"

  cat > "$filepath" << FRONT
---
layout: story.njk
title: "${titulo}"
date: ${fecha}
location: "${lugar}"
year: "${anio}"
excerpt: "${extracto}"
tags:
  - historia
  - personal
---

*${lugar:-México}${anio:+ · $anio}*

---

Comienza tu relato aquí...

> Pon aquí una frase poderosa que resuma lo que viviste.

Continúa escribiendo tu historia...
FRONT

  echo ""
  print_ok "Historia creada en: ${GOLD}src/stories/${filename}${RESET}"
  echo -ne "\n  ${WHITE}¿Abrir en VS Code para detallarla? (S/n): ${RESET}"; read -r abrir
  [[ "${abrir,,}" != "n" ]] && command -v code &>/dev/null && code "$filepath"
  wait_key
}

# ─── 3. FOTO CON TEXTO (GALERÍA MEJORADA) ─────────────────────
nueva_foto() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ NUEVA SESIÓN FOTOGRÁFICA + TEXTO${RESET}\n"

  echo -ne "  ${WHITE}Título del álbum / foto: ${RESET}"; read -r titulo
  [[ -z "$titulo" ]] && { print_err "Vacío."; wait_key; return; }

  echo -ne "  ${WHITE}Descripción o historia detrás de la foto: ${RESET}"; read -r desc
  echo -ne "  ${WHITE}Ubicación espacial: ${RESET}"; read -r lugar

  local fecha slug filename filepath assets_path
  fecha=$(date +%Y-%m-%d)
  slug=$(make_slug "$titulo")
  filename="${fecha}-${slug}.md"
  filepath="${BLOG_DIR}/src/photos/${filename}"
  assets_path="${BLOG_DIR}/src/assets/photos/${slug}"

  mkdir -p "${BLOG_DIR}/src/photos"
  mkdir -p "$assets_path"

  cat > "$filepath" << FRONT
---
layout: base.njk
title: "${titulo}"
date: ${fecha}
location: "${lugar}"
description: "${desc}"
tags:
  - foto
  - galeria
---

<div class="photo-entry text-center">
  <p class="location-tag">📍 ${lugar}</p>
  
  <img src="/assets/photos/${slug}/foto1.jpg" alt="${titulo}" class="img-fluid custom-blog-img">
  
  <div class="photo-story mt-4">
    <p>${desc}</p>
  </div>
</div>
FRONT

  echo ""
  print_ok "Entrada de galería guardada."
  print_info "Guarda tus fotos dentro de: ${GOLD}src/assets/photos/${slug}/${RESET}"
  
  # Truco: Abrir la carpeta de fotos automáticamente en el gestor de archivos de Linux
  if command -v xdg-open &>/dev/null; then
    echo -e "  ${BLUE}→ Abriendo carpeta de destino para que arrastres tus fotos...${RESET}"
    xdg-open "$assets_path" &>/dev/null
  fi

  echo -ne "\n  ${WHITE}¿Abrir archivo de configuración en VS Code? (S/n): ${RESET}"; read -r abrir
  [[ "${abrir,,}" != "n" ]] && command -v code &>/dev/null && code "$filepath"
  wait_key
}

# ─── SERVIDOR LOCAL ───────────────────────────────────────────
servidor_local() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ PREVIEW EN VIVO (LOCAL)${RESET}\n"
  cd "$BLOG_DIR" || return
  [ ! -d "node_modules" ] && npm install
  print_ok "Servidor encendido en ${GOLD}http://localhost:8080${RESET}"
  print_info "Presiona Ctrl+C para apagar el
