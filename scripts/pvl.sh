#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
#   PVL BLOG MANAGER — El Tigre Edition
#   Menú interactivo para gestionar tu blog personal
#   Autor: Pavel Gomez | Cuernavaca, MX
# ═══════════════════════════════════════════════════════════

# ─── COLORES ────────────────────────────────────────────────
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
TIGER="\033[38;5;208m"       # Naranja tigre
GOLD="\033[38;5;220m"        # Dorado
GREEN="\033[38;5;82m"        # Verde terminal
BLUE="\033[38;5;39m"         # Azul info
RED="\033[38;5;196m"         # Rojo error
MUTED="\033[38;5;244m"       # Gris apagado
WHITE="\033[97m"
BG_DARK="\033[48;5;235m"

# ─── DIRECTORIO DEL PROYECTO ─────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$SCRIPT_DIR"

# ─── FUNCIONES DE UI ─────────────────────────────────────────
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
  echo -e "  ${GOLD}${BOLD}  Pavel Gomez — Blog Manager ${TIGER}\"El Tigre Edition\"${RESET}"
  echo -e "  ${MUTED}  Cuernavaca, MX · pvl.gom3z@gmail.com${RESET}"
  echo -e "  ${MUTED}──────────────────────────────────────────────────────────────────${RESET}"
  echo ""
}

print_separator() {
  echo -e "  ${MUTED}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${RESET}"
}

print_success() { echo -e "  ${GREEN}✓ ${WHITE}$1${RESET}"; }
print_error()   { echo -e "  ${RED}✗ ${WHITE}$1${RESET}"; }
print_info()    { echo -e "  ${BLUE}→ ${WHITE}$1${RESET}"; }
print_warn()    { echo -e "  ${GOLD}⚠ ${WHITE}$1${RESET}"; }

wait_key() {
  echo ""
  echo -e "  ${MUTED}[Presiona cualquier tecla para continuar...]${RESET}"
  read -n1 -rs
}

# ─── GENERAR SLUG ─────────────────────────────────────────────
make_slug() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | \
    sed 's/[áàäâ]/a/g; s/[éèëê]/e/g; s/[íìïî]/i/g; s/[óòöô]/o/g; s/[úùüû]/u/g; s/ñ/n/g' | \
    tr -cs '[:alnum:]' '-' | \
    sed 's/^-//;s/-$//'
}

# ─── 1. NUEVA ENTRADA DE BLOG ─────────────────────────────────
nueva_post() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ NUEVA ENTRADA DE BLOG${RESET}"
  echo ""

  echo -e "  ${WHITE}Título del artículo:${RESET} "
  read -r titulo
  [[ -z "$titulo" ]] && { print_error "Título vacío. Cancelando."; wait_key; return; }

  echo -e "  ${WHITE}Categoría (Blog/Tech/Vida/Cocina) [Blog]:${RESET} "
  read -r categoria
  categoria="${categoria:-Blog}"

  echo -e "  ${WHITE}Emoji representativo [📝]:${RESET} "
  read -r emoji
  emoji="${emoji:-📝}"

  echo -e "  ${WHITE}Extracto corto (1-2 líneas):${RESET} "
  read -r extracto

  echo -e "  ${WHITE}¿Es el post destacado? (s/N):${RESET} "
  read -r featured
  featured_val="false"
  [[ "${featured,,}" == "s" ]] && featured_val="true"

  local fecha
  fecha=$(date +%Y-%m-%d)
  local slug
  slug=$(make_slug "$titulo")
  local filename="${fecha}-${slug}.md"
  local filepath="${BLOG_DIR}/src/posts/${filename}"

  cat > "$filepath" << FRONTMATTER
---
layout: post.njk
title: "${titulo}"
date: ${fecha}
category: "${categoria}"
emoji: "${emoji}"
excerpt: "${extracto}"
featured: ${featured_val}
tags:
  - post
  - ${categoria,,}
---

<!-- Escribe aquí tu artículo en Markdown -->

## Introducción

Escribe tu introducción aquí...

## Desarrollo

Continúa tu artículo...

## Conclusión

Cierra con tus pensamientos finales.
FRONTMATTER

  echo ""
  print_success "Post creado: ${GOLD}${filename}${RESET}"
  echo ""

  echo -e "  ${WHITE}¿Abrir en VS Code ahora? (S/n):${RESET} "
  read -r abrir
  if [[ "${abrir,,}" != "n" ]]; then
    if command -v code &>/dev/null; then
      code "$filepath"
      print_success "Abierto en VS Code."
    elif command -v xdg-open &>/dev/null; then
      xdg-open "$filepath"
    else
      print_warn "VS Code no encontrado. Abre el archivo en: ${filepath}"
    fi
  fi

  echo ""
  echo -e "  ${MUTED}Ruta: ${filepath}${RESET}"
  wait_key
}

# ─── 2. NUEVA HISTORIA PERSONAL ────────────────────────────────
nueva_historia() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ NUEVA HISTORIA PERSONAL${RESET}"
  echo ""

  echo -e "  ${WHITE}Título de la historia:${RESET} "
  read -r titulo
  [[ -z "$titulo" ]] && { print_error "Título vacío. Cancelando."; wait_key; return; }

  echo -e "  ${WHITE}Lugar / Ubicación (ej: Utah, USA):${RESET} "
  read -r lugar

  echo -e "  ${WHITE}Extracto emotivo (1-2 líneas):${RESET} "
  read -r extracto

  echo -e "  ${WHITE}Año en que ocurrió (ej: 2019):${RESET} "
  read -r anio

  local fecha
  fecha=$(date +%Y-%m-%d)
  local slug
  slug=$(make_slug "$titulo")
  local filename="${fecha}-${slug}.md"
  local filepath="${BLOG_DIR}/src/stories/${filename}"

  mkdir -p "${BLOG_DIR}/src/stories"

  cat > "$filepath" << FRONTMATTER
---
layout: story.njk
title: "${titulo}"
date: ${fecha}
location: "${lugar}"
year: "${anio:-}"
excerpt: "${extracto}"
tags:
  - historia
  - personal
---

<!-- Cuenta tu historia aquí -->

*${lugar:-México}${anio:+ · $anio}*

---

Comienza tu relato aquí...

> Una cita que marcó ese momento.

Continúa la historia...
FRONTMATTER

  echo ""
  print_success "Historia creada: ${GOLD}${filename}${RESET}"
  echo ""

  echo -e "  ${WHITE}¿Abrir en VS Code? (S/n):${RESET} "
  read -r abrir
  if [[ "${abrir,,}" != "n" ]]; then
    command -v code &>/dev/null && code "$filepath" || print_warn "Archivo en: ${filepath}"
  fi

  wait_key
}

# ─── 3. NUEVA ENTRADA DE FOTOS ────────────────────────────────
nueva_foto() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ NUEVA ENTRADA DE FOTOS${RESET}"
  echo ""

  echo -e "  ${WHITE}Título / Nombre de la sesión:${RESET} "
  read -r titulo
  [[ -z "$titulo" ]] && { print_error "Vacío. Cancelando."; wait_key; return; }

  echo -e "  ${WHITE}Descripción breve:${RESET} "
  read -r desc

  echo -e "  ${WHITE}Ubicación de las fotos:${RESET} "
  read -r lugar

  local fecha
  fecha=$(date +%Y-%m-%d)
  local slug
  slug=$(make_slug "$titulo")
  local filename="${fecha}-${slug}.md"

  mkdir -p "${BLOG_DIR}/src/photos"
  mkdir -p "${BLOG_DIR}/src/assets/photos/${slug}"

  cat > "${BLOG_DIR}/src/photos/${filename}" << FRONTMATTER
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
<!-- Agrega tus imágenes en: src/assets/photos/${slug}/ -->
<!-- Luego referencia con: /assets/photos/${slug}/nombre.jpg -->
FRONTMATTER

  print_success "Entrada de fotos creada: ${GOLD}${filename}${RESET}"
  print_info  "Carpeta para imágenes: ${MUTED}src/assets/photos/${slug}/${RESET}"
  wait_key
}

# ─── 4. SERVIDOR LOCAL ────────────────────────────────────────
servidor_local() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ SERVIDOR LOCAL DE DESARROLLO${RESET}"
  echo ""

  cd "$BLOG_DIR" || return

  if ! command -v node &>/dev/null; then
    print_error "Node.js no está instalado."
    print_info  "Instálalo desde: https://nodejs.org"
    wait_key; return
  fi

  if [ ! -d "node_modules" ]; then
    print_info "Instalando dependencias por primera vez..."
    npm install
  fi

  print_success "Iniciando servidor en ${GOLD}http://localhost:8080${RESET}"
  print_info  "Ctrl+C para detener"
  echo ""
  npm run dev
}

# ─── 5. BUILD Y DEPLOY ────────────────────────────────────────
build_y_deploy() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ BUILD & DEPLOY → NETLIFY${RESET}"
  echo ""

  cd "$BLOG_DIR" || return

  # Git status
  if ! git -C "$BLOG_DIR" rev-parse --git-dir &>/dev/null 2>&1; then
    print_warn "Este directorio no es un repositorio Git."
    echo -e "  ${WHITE}¿Inicializar repositorio Git ahora? (S/n):${RESET} "
    read -r init
    if [[ "${init,,}" != "n" ]]; then
      git init
      git add .
      git commit -m "🐅 Initial commit — pvl-blog"
      print_success "Repositorio Git inicializado."
      echo ""
      print_info "Sigue estos pasos para subir a GitHub:"
      echo ""
      echo -e "  ${GOLD}1.${RESET} Crea un repo en https://github.com/new"
      echo -e "  ${GOLD}2.${RESET} Copia la URL y ejecuta:"
      echo -e "     ${MUTED}git remote add origin https://github.com/TUUSUARIO/pvl-blog.git${RESET}"
      echo -e "     ${MUTED}git push -u origin main${RESET}"
      echo -e "  ${GOLD}3.${RESET} En Netlify → 'Add new site → Import from Git'"
      echo -e "     ${MUTED}Build command:${RESET} ${GREEN}npm run build${RESET}"
      echo -e "     ${MUTED}Publish dir:${RESET}   ${GREEN}_site${RESET}"
    fi
    wait_key; return
  fi

  print_info "Construyendo el sitio..."
  npm run build

  if [ $? -eq 0 ]; then
    print_success "Build completado. Archivos en: ${GOLD}_site/${RESET}"
  else
    print_error "El build falló. Revisa los errores arriba."
    wait_key; return
  fi

  echo ""
  echo -e "  ${WHITE}¿Hacer commit y push automático? (S/n):${RESET} "
  read -r dopush
  if [[ "${dopush,,}" != "n" ]]; then
    echo -e "  ${WHITE}Mensaje del commit [actualizar blog]:${RESET} "
    read -r msg
    msg="${msg:-actualizar blog}"
    git add .
    git commit -m "🐅 ${msg}"
    git push
    echo ""
    print_success "Push enviado. Netlify desplegará en ~30 segundos."
    print_info  "Monitorea en: ${GOLD}https://app.netlify.com${RESET}"
  fi

  wait_key
}

# ─── 6. VER POSTS EXISTENTES ──────────────────────────────────
ver_posts() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ ENTRADAS EXISTENTES${RESET}"
  echo ""

  local count=0

  echo -e "  ${GOLD}── BLOG POSTS ──────────────────────────────${RESET}"
  if compgen -G "${BLOG_DIR}/src/posts/*.md" > /dev/null 2>&1; then
    for f in "${BLOG_DIR}/src/posts/"*.md; do
      local nombre
      nombre=$(basename "$f")
      echo -e "  ${GREEN}•${RESET} ${nombre}"
      ((count++))
    done
  else
    echo -e "  ${MUTED}  (ninguno aún)${RESET}"
  fi

  echo ""
  echo -e "  ${GOLD}── HISTORIAS ────────────────────────────────${RESET}"
  if compgen -G "${BLOG_DIR}/src/stories/*.md" > /dev/null 2>&1; then
    for f in "${BLOG_DIR}/src/stories/"*.md; do
      echo -e "  ${GREEN}•${RESET} $(basename "$f")"
      ((count++))
    done
  else
    echo -e "  ${MUTED}  (ninguna aún)${RESET}"
  fi

  echo ""
  echo -e "  ${MUTED}Total: ${count} archivos${RESET}"

  echo ""
  echo -e "  ${WHITE}¿Abrir un archivo en VS Code? Escribe el nombre (o Enter para cancelar):${RESET} "
  read -r archivo
  if [[ -n "$archivo" ]]; then
    local found
    found=$(find "$BLOG_DIR/src" -name "$archivo" 2>/dev/null | head -1)
    if [[ -n "$found" ]]; then
      code "$found" 2>/dev/null || print_warn "Abre manualmente: $found"
    else
      print_error "Archivo no encontrado: $archivo"
    fi
  fi

  wait_key
}

# ─── 7. EDITAR CURRICULUM ────────────────────────────────────
editar_curriculum() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ EDITAR CURRÍCULUM${RESET}"
  echo ""
  local cv="${BLOG_DIR}/src/curriculum.njk"
  print_info "Abriendo: ${GOLD}src/curriculum.njk${RESET}"
  echo ""
  echo -e "  ${MUTED}Edita el archivo en VS Code y guarda.${RESET}"
  echo -e "  ${MUTED}El servidor local actualizará automáticamente.${RESET}"
  command -v code &>/dev/null && code "$cv" || print_warn "Abre manualmente: $cv"
  wait_key
}

# ─── 8. ESTADO DEL SITIO ─────────────────────────────────────
estado_sitio() {
  print_header
  echo -e "  ${TIGER}${BOLD}✦ ESTADO DEL SITIO${RESET}"
  echo ""

  # Git status
  if git -C "$BLOG_DIR" rev-parse --git-dir &>/dev/null 2>&1; then
    local branch
    branch=$(git -C "$BLOG_DIR" branch --show-current 2>/dev/null)
    local commits
    commits=$(git -C "$BLOG_DIR" rev-list --count HEAD 2>/dev/null)
    print_success "Git: rama ${GOLD}${branch}${RESET} · ${commits} commits"

    local unpushed
    unpushed=$(git -C "$BLOG_DIR" status --short 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$unpushed" -gt 0 ]]; then
      print_warn "${unpushed} cambios sin commit"
    else
      print_success "Todo sincronizado"
    fi
  else
    print_warn "Sin repositorio Git"
  fi

  echo ""

  # Conteo de contenido
  local posts stories photos
  posts=$(find "${BLOG_DIR}/src/posts" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  stories=$(find "${BLOG_DIR}/src/stories" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  photos=$(find "${BLOG_DIR}/src/photos" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

  echo -e "  ${GOLD}── CONTENIDO ────────────────────────${RESET}"
  echo -e "  ${GREEN}•${RESET} Blog posts:  ${WHITE}${posts}${RESET}"
  echo -e "  ${GREEN}•${RESET} Historias:   ${WHITE}${stories}${RESET}"
  echo -e "  ${GREEN}•${RESET} Fotos:       ${WHITE}${photos}${RESET}"

  echo ""
  echo -e "  ${GOLD}── ENLACES ──────────────────────────${RESET}"
  echo -e "  ${GREEN}•${RESET} Local:    ${BLUE}http://localhost:8080${RESET}"
  echo -e "  ${GREEN}•${RESET} Online:   ${BLUE}https://pvlcv.netlify.app${RESET}"
  echo -e "  ${GREEN}•${RESET} LinkedIn: ${BLUE}linkedin.com/in/pavelgomez1509${RESET}"

  wait_key
}

# ─── MENÚ PRINCIPAL ───────────────────────────────────────────
main_menu() {
  while true; do
    print_header

    echo -e "  ${GOLD}${BOLD}¿Qué deseas hacer hoy, El Tigre?${RESET}"
    echo ""
    echo -e "  ${TIGER}[1]${RESET}  ✍️  Nueva entrada de blog"
    echo -e "  ${TIGER}[2]${RESET}  📖  Nueva historia personal"
    echo -e "  ${TIGER}[3]${RESET}  📸  Nueva entrada de fotos"
    print_separator
    echo -e "  ${TIGER}[4]${RESET}  🖥️  Ver posts existentes & editar"
    echo -e "  ${TIGER}[5]${RESET}  👤  Editar Currículum"
    print_separator
    echo -e "  ${TIGER}[6]${RESET}  🚀  Servidor local (preview)"
    echo -e "  ${TIGER}[7]${RESET}  📡  Build & Deploy → Netlify"
    echo -e "  ${TIGER}[8]${RESET}  📊  Estado del sitio"
    print_separator
    echo -e "  ${MUTED}[0]${RESET}  Salir"
    echo ""
    echo -ne "  ${WHITE}Opción:${RESET} ${TIGER}"
    read -r opcion
    echo -e "${RESET}"

    case "$opcion" in
      1) nueva_post ;;
      2) nueva_historia ;;
      3) nueva_foto ;;
      4) ver_posts ;;
      5) editar_curriculum ;;
      6) servidor_local ;;
      7) build_y_deploy ;;
      8) estado_sitio ;;
      0)
        clear_screen
        echo -e "\n  ${TIGER}${BOLD}🐅 El Tigre descansa... hasta la próxima.${RESET}\n"
        exit 0
        ;;
      *)
        print_error "Opción inválida."
        sleep 1
        ;;
    esac
  done
}

# ─── SOPORTE DE ARGUMENTOS DIRECTOS ──────────────────────────
# Uso: ./pvl.sh nueva post | ./pvl.sh nueva historia | ./pvl.sh deploy
case "${1:-}" in
  "nueva")
    case "${2:-}" in
      "post"|"blog") nueva_post; exit 0 ;;
      "historia"|"story") nueva_historia; exit 0 ;;
      "foto"|"photo") nueva_foto; exit 0 ;;
    esac
    ;;
  "deploy") build_y_deploy; exit 0 ;;
  "server"|"dev") servidor_local; exit 0 ;;
  "status") estado_sitio; exit 0 ;;
esac

# ─── INICIAR MENÚ ─────────────────────────────────────────────
main_menu
