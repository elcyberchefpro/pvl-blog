/* ============================================================
   PVL BLOG — MAIN JS
   ============================================================ */

/* ── NAV SCROLL BEHAVIOR ─────────────────────────────────── */
const nav = document.getElementById('siteNav');
if (nav) {
  window.addEventListener('scroll', () => {
    nav.classList.toggle('scrolled', window.scrollY > 40);
  }, { passive: true });
}

/* ── MOBILE NAV TOGGLE ───────────────────────────────────── */
const navToggle = document.getElementById('navToggle');
const navLinks  = document.getElementById('navLinks');
if (navToggle && navLinks) {
  navToggle.addEventListener('click', () => {
    navLinks.classList.toggle('open');
    navToggle.classList.toggle('open');
  });
  // Close on link click
  navLinks.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => {
      navLinks.classList.remove('open');
      navToggle.classList.remove('open');
    });
  });
}

/* ── PARALLAX HERO ───────────────────────────────────────── */
const heroLayers = document.querySelectorAll('.hero-layer[data-parallax]');
if (heroLayers.length) {
  window.addEventListener('scroll', () => {
    const y = window.scrollY;
    heroLayers.forEach(layer => {
      const speed = parseFloat(layer.dataset.parallax) || 0.3;
      layer.style.transform = `translateY(${y * speed}px)`;
    });
  }, { passive: true });
}

/* ── MOUSE TILT HERO ─────────────────────────────────────── */
const heroEl = document.querySelector('.hero');
if (heroEl) {
  heroEl.addEventListener('mousemove', (e) => {
    const rect = heroEl.getBoundingClientRect();
    const cx = rect.width / 2;
    const cy = rect.height / 2;
    const dx = (e.clientX - rect.left - cx) / cx;
    const dy = (e.clientY - rect.top  - cy) / cy;
    heroEl.querySelectorAll('.hero-layer').forEach((layer, i) => {
      const depth = (i + 1) * 6;
      layer.style.transform = `translate(${dx * depth}px, ${dy * depth}px)`;
    });
  });
  heroEl.addEventListener('mouseleave', () => {
    heroEl.querySelectorAll('.hero-layer').forEach(layer => {
      layer.style.transform = '';
    });
  });
}

/* ── SCROLL REVEAL ───────────────────────────────────────── */
const revealEls = document.querySelectorAll('.reveal');
if (revealEls.length) {
  const io = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });
  revealEls.forEach(el => io.observe(el));
}

/* ── CV SKILL BAR ANIMATION ──────────────────────────────── */
const skillFills = document.querySelectorAll('.cv-skill-fill');
if (skillFills.length) {
  const skillIO = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.transform = 'scaleX(1)';
        skillIO.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });
  skillFills.forEach(el => skillIO.observe(el));
}

/* ── ACTIVE NAV LINK ─────────────────────────────────────── */
const currentPath = window.location.pathname;
document.querySelectorAll('.nav-link').forEach(link => {
  if (link.getAttribute('href') === currentPath ||
      (currentPath !== '/' && link.getAttribute('href') !== '/' && currentPath.startsWith(link.getAttribute('href')))) {
    link.classList.add('active');
  }
});

/* ── CURSOR GLOW (EASTER EGG) ────────────────────────────── */
let cursorGlow = null;
document.addEventListener('keydown', (e) => {
  if (e.key === 'T' && e.ctrlKey) {
    if (cursorGlow) { cursorGlow.remove(); cursorGlow = null; return; }
    cursorGlow = document.createElement('div');
    cursorGlow.style.cssText = `
      position:fixed; width:300px; height:300px; pointer-events:none; z-index:9999;
      border-radius:50%; background:radial-gradient(circle, rgba(200,70,10,0.15) 0%, transparent 70%);
      transform:translate(-50%,-50%); transition:left 0.1s, top 0.1s;
    `;
    document.body.appendChild(cursorGlow);
    document.addEventListener('mousemove', (ev) => {
      if (cursorGlow) { cursorGlow.style.left = ev.clientX + 'px'; cursorGlow.style.top = ev.clientY + 'px'; }
    });
  }
});
