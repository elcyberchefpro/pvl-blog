# 🐅 PVL Blog — Pavel Gomez "El Tigre"

Blog personal construido con **Eleventy (11ty)** + **Netlify** + **GitHub**.

## 📁 Estructura del Proyecto

```
pvl-blog/
├── pvl.sh                  ← 🎛️ MENÚ INTERACTIVO (tu comando principal)
├── scripts/pvl.sh          ← Copia del script
├── netlify.toml            ← Configuración de Netlify
├── package.json            ← Dependencias (solo Eleventy)
├── .eleventy.js            ← Configuración del generador
└── src/
    ├── index.njk           ← Portada principal
    ├── blog.njk            ← Lista del blog
    ├── historias.njk       ← Lista de historias
    ├── fotos.njk           ← Galería de fotos
    ├── curriculum.njk      ← Tu CV completo
    ├── posts/              ← ✍️ Tus artículos de blog (Markdown)
    ├── stories/            ← 📖 Tus historias personales (Markdown)
    ├── photos/             ← 📸 Entradas de fotos (Markdown)
    ├── assets/             ← Imágenes, favicon
    ├── css/main.css        ← Todos los estilos
    ├── js/main.js          ← JavaScript del sitio
    └── _includes/          ← Layouts y partials de plantilla
```

## 🚀 Instalación (Primera vez)

```bash
# 1. Instalar Node.js desde https://nodejs.org (versión 18+)

# 2. Clonar o descomprimir este proyecto
cd pvl-blog

# 3. Instalar dependencias
npm install

# 4. Dar permisos al script
chmod +x pvl.sh

# 5. Iniciar el menú interactivo
./pvl.sh
```

## 🎛️ Uso Diario (EL COMANDO)

```bash
# Abrir el menú interactivo
./pvl.sh

# Atajos directos desde terminal:
./pvl.sh nueva post       # Nueva entrada del blog
./pvl.sh nueva historia   # Nueva historia personal
./pvl.sh nueva foto       # Nueva sesión de fotos
./pvl.sh dev              # Servidor local en localhost:8080
./pvl.sh deploy           # Build + Git push → Netlify auto-deploy
./pvl.sh status           # Estado del sitio
```

## 🌐 Publicar en Netlify + GitHub

### Paso 1 — Subir a GitHub
```bash
git init
git add .
git commit -m "🐅 Mi blog personal"

# Crear repo en github.com/new (pvl-blog)
git remote add origin https://github.com/TUUSUARIO/pvl-blog.git
git push -u origin main
```

### Paso 2 — Conectar Netlify
1. Ve a [app.netlify.com](https://app.netlify.com)
2. "Add new site → Import an existing project"
3. Conecta tu cuenta de GitHub
4. Selecciona el repo `pvl-blog`
5. Configuración automática (netlify.toml ya lo hace todo):
   - **Build command:** `npm run build`
   - **Publish directory:** `_site`
6. Click "Deploy site"

Tu sitio estará en línea en ~60 segundos. Cada `git push` despliega automáticamente.

### Paso 3 — Dominio personalizado (opcional)
En Netlify → Domain settings → Add custom domain.

## ✍️ Cómo Escribir

Cada entrada es un archivo **Markdown** con un encabezado YAML (frontmatter).

### Ejemplo de post de blog:
```markdown
---
layout: post.njk
title: "Mi artículo sobre cocina y código"
date: 2025-03-15
category: "Tech"
emoji: "💻"
excerpt: "Resumen corto que aparece en las tarjetas."
---

## Introducción

Tu artículo aquí en Markdown normal.

> Una cita con este formato.
```

### Sintaxis Markdown básica:
```
# Título H1
## Título H2
**negrita** | *cursiva* | `código`
> cita en bloque
- lista con guiones
[link](https://url.com)
![imagen](ruta/imagen.jpg)
```

## 🎨 Personalización

Para editar colores/estilos: `src/css/main.css` (variables al inicio)
Para editar el CV: `src/curriculum.njk`
Para editar la portada: `src/index.njk`

## 🛡️ Tecnologías

- **Eleventy 2.x** — Generador de sitios estáticos (ultra rápido, sin JS en producción)
- **Nunjucks** — Motor de plantillas
- **Netlify** — Hosting gratuito con CDN global
- **GitHub** — Control de versiones
- **VS Code** — Editor recomendado
