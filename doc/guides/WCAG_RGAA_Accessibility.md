# Guide Accessibilité - WCAG 2.1 AA & RGAA 4

**HealthAI Coach - Conformité normes d'accessibilité numériques**

---

## 1. Standards applicables

**WCAG 2.1 (Web Content Accessibility Guidelines):**

- Niveau AA: Conformité visée pour MSPR 1 ✓
- Niveau AAA: Visé pour MSPR 2 (recommandations, visualisations avancées)

**RGAA 4 (Référentiel Général d'Accessibilité des Administrations):**

- Applicable en France pour tout service public digital
- 106 critères alignés WCAG 2.1 AA
- Évaluation par audit externe

---

## 2. Principes fondamentaux

```
┌────────────────────────────────────────────────────┐
│     WCAG 2.1 - 4 Principes Fondamentaux           │
├────────────────────────────────────────────────────┤
│                                                    │
│ 1. PERCEPTIBLE                                     │
│    └─ Contenu doit être perceptible par l'user    │
│       ├─ Images: textes alternatifs               │
│       ├─ Vidéos: sous-titres, audio-descriptions │
│       └─ Couleurs: pas uniquement info par couleur│
│                                                    │
│ 2. UTILISABLE                                      │
│    └─ Interface & navigation doivent être usables │
│       ├─ Clavier entièrement utilisable           │
│       ├─ Pas de pièges keyboard (no time limits)  │
│       ├─ Lecteurs d'écran supportés               │
│       └─ Pas de contenu flash/vidéo qui clignote  │
│                                                    │
│ 3. COMPRÉHENSIBLE                                  │
│    └─ Texte & interface clairs & compréhensibles  │
│       ├─ Langage clair & simple                   │
│       ├─ Abréviations expliquées                  │
│       ├─ Navigation cohérente & prévisible        │
│       └─ Aide & correction d'erreurs présentes    │
│                                                    │
│ 4. ROBUSTE                                         │
│    └─ Compatible avec technologies d'assistance   │
│       ├─ HTML valide & sémantique                 │
│       ├─ ARIA labels pour contenus complexes      │
│       ├─ Mobile & lecteurs d'écran supportés      │
│       └─ Version texte pour graphiques            │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 3. Critères WCAG 2.1 AA implémentés

### 3.1 Perception (Guideline 1)

#### 1.1 Alternatives textuelles (A)

```html
<!-- ❌ Mauvais -->
<img src="dashboard.png" />

<!-- ✅ Bon -->
<img
  src="dashboard.png"
  alt="Tableau de bord affichant KPIs santé: 
       1500 patients, BMI moyen 24.5, cholestérol moyen 190"
/>

<!-- Pour images complexes (graphique) -->
<figure>
  <img src="chart.png" alt="Graphique KPI santé" />
  <figcaption>
    <p>Évolution cholestérol: baisse de 15% en 90 jours</p>
    <table>
      <thead>
        <tr>
          <th>Période</th>
          <th>Valeur</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Jour 1</td>
          <td>210 mg/dL</td>
        </tr>
        <tr>
          <td>Jour 90</td>
          <td>178 mg/dL</td>
        </tr>
      </tbody>
    </table>
  </figcaption>
</figure>
```

#### 1.3 Adaptabilité (A)

```html
<!-- Responsive design -->
<meta name="viewport" content="width=device-width, initial-scale=1" />

<!-- Structure logique (sémantique) -->
<header>
  <nav aria-label="Main navigation">...</nav>
</header>

<main>
  <section aria-label="Health KPIs">
    <h1>Indicateurs Santé</h1>
    <article>
      <h2>Cholestérol</h2>
      ...
    </article>
  </section>
</main>

<footer>...</footer>
```

#### 1.4 Distinguishable (AA)

**Contraste minimum 4.5:1 (texte normal), 3:1 (large)**

```css
/* ✅ Texte normal blanc sur noir */
.stat-card {
  color: #ffffff; /* #FFF */
  background: #000000; /* #000 */
  /* Ratio: 21/1 = ✓ Conforme AAA */
}

/* ✅ Texte 18pt sur fond */
.heading-large {
  color: #555555;
  background: #ffffff;
  font-size: 24px; /* ≥18pt = "large text" */
  font-weight: bold;
  /* Ratio: 12.6/1 = ✓ Conforme AAA */
}

/* ❌ Contraste insuffisant */
.disabled-text {
  color: #cccccc; /* Gris clair */
  background: #ffffff; /* Blanc */
  /* Ratio: 1.8/1 = ✗ Non conforme */
}

/* ✅ Éviter info uniquement par couleur */
.success {
  color: green;
  border-left: 4px solid green;
  background: #e8f5e9;
}
```

**Pas de perte d'info en niveau de gris:**

```css
/* ❌ Info uniquement couleur */
.status {
  color: red; /* Critique */
}

/* ✅ Info explicite + couleur */
.status-critical {
  color: red;
  text-content: "🔴 CRITIQUE: ";
}
```

### 3.2 Utilisabilité (Guideline 2)

#### 2.1 Accessible au clavier (A)

```html
<!-- Tous les composants doivent être accessibles au clavier -->

<!-- ✅ Bouton natif (keyboard accessible par défaut) -->
<button onclick="openRecommendations()">Voir recommandations</button>

<!-- ✗ Div cliquable (NOT keyboard accessible) -->
<div onclick="openRecommendations()">Cliquer</div>

<!-- ✅ Div + keyboard support ARIA -->
<div
  role="button"
  tabindex="0"
  onclick="openRecommendations()"
  onkeypress="if(event.key === 'Enter') openRecommendations()"
  aria-label="Voir recommandations"
>
  Cliquer
</div>

<!-- Ordre de tabulation explicite -->
<form>
  <input name="age" tabindex="1" />
  <input name="gender" tabindex="2" />
  <button type="submit" tabindex="3">Soumettre</button>
</form>
```

#### 2.4 Navigation visible (AA)

```css
/* Focus indicator visible */
button:focus {
  outline: 3px solid #4A90E2;  /* Bleu vif, contraste >3:1 */
  outline-offset: 2px;
}

input:focus {
  border: 2px solid #4A90E2;
  box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
}

/* Skip to main content link -->
<a href="#main-content" class="skip-link">
  Aller au contenu principal
</a>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #FFF;
  padding: 8px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;  /* Visible au focus */
}
</style>
```

#### 2.5 Input modalities (AAA for MSPR 2)

```html
<!-- Clavier & souris doivent marcher -->

<!-- ✓ Formulaire facile -->
<label for="age">Âge:</label>
<input id="age" type="number" min="18" max="120" />

<!-- ✓ Champs explicitement liés via labels -->
<fieldset>
  <legend>Objectif santé</legend>
  <label>
    <input type="radio" name="goal" value="weight_loss" />
    Perte de poids
  </label>
  <label>
    <input type="radio" name="goal" value="muscle_gain" />
    Gain musculaire
  </label>
</fieldset>
```

### 3.3 Compréhensibilité (Guideline 3)

#### 3.1 Lisibilité (A)

```html
<!-- Langue explicite -->
<html lang="fr">
  <!-- Abbréviations expliquées -->
  <p>
    L'<abbr title="Indice de Masse Corporelle">IMC</abbr> est un indicateur clé.
  </p>

  <!-- Langage clair & simple -->
  <p>Votre IMC est 24.5. Cela signifie un poids sain.</p>
  <!-- Vs: "Statut pondéral optimisé" (jargon) -->
</html>
```

#### 3.2 Prévisibilité (AA)

```html
<!-- Navigation cohérente -->
<!-- Même location, même fonction sur toutes pages -->
<nav class="main-nav">
  <a href="/dashboard">Tableau de bord</a>
  <a href="/health">Santé</a>
  <a href="/nutrition">Nutrition</a>
  <a href="/activity">Activité</a>
</nav>

<!-- Absence de changements surprises -->
<!-- ❌ Ouvrir nouvelle fenêtre sans avertir -->
<a href="/report.pdf">Voir rapport</a>

<!-- ✅ Avertir utilisateur -->
<a href="/report.pdf" aria-label="Voir rapport (ouvre PDF)"> Voir rapport </a>
```

#### 3.3 Assistance erreurs (A/AA)

```html
<!-- Validation claire d'erreurs -->
<form novalidate onsubmit="return validate()">
  <label for="age">Âge (18-120):</label>
  <input
    id="age"
    type="number"
    min="18"
    max="120"
    aria-describedby="age-error"
    required
  />

  <div id="age-error" role="alert" aria-live="polite">
    <!-- Erreur affichée ici -->
  </div>

  <!-- Suggestion correction -->
  <div id="age-suggestion">💡 Veuillez entrer un âge entre 18 et 120 ans.</div>
</form>
```

### 3.4 Robustesse (Guideline 4)

#### 4.1 Compatible (A)

```html
<!-- HTML valide & sémantique -->
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <title>HealthAI Coach</title>
  </head>
  <body>
    <header>
      <nav aria-label="Navigation principale">...</nav>
    </header>

    <main id="main-content">
      <article>
        <h1>Santé</h1>
        <section>
          <h2>Cholestérol</h2>
          <p>...</p>
        </section>
      </article>
    </main>

    <footer>
      <p>&copy; 2026 HealthAI Coach</p>
    </footer>
  </body>
</html>

<!-- ARIA pour contenus complexes -->
<div
  role="region"
  aria-label="KPIs temps réel"
  aria-live="polite"
  aria-atomic="true"
>
  <!-- Contenu qui change dynamiquement -->
</div>
```

---

## 4. ARIA (Accessible Rich Internet Applications)

### 4.1 Landmarks

```html
<header role="banner">
  <!-- Logo, titre site -->
</header>

<nav aria-label="Main navigation">
  <!-- Menu principal -->
</nav>

<main role="main">
  <!-- Contenu principal -->
</main>

<aside role="complementary" aria-label="Sidebar">
  <!-- Contenu auxiliaire -->
</aside>

<footer role="contentinfo">
  <!-- Infos site -->
</footer>
```

### 4.2 Live Regions

```html
<!-- Notifications dynamiques -->
<div role="alert" aria-live="assertive" aria-atomic="true">
  ✓ Recommandation créée avec succès!
</div>

<!-- Mise à jour polite (non-intrusive) -->
<div aria-live="polite" aria-label="KPIs santé">
  <!-- Données mises à jour périodiquement -->
</div>
```

### 4.3 Labels & Descriptions

```html
<!-- Label explicit -->
<label for="goal-select">Objectif santé:</label>
<select id="goal-select" aria-label="Sélectionner objectif">
  <option>Perte de poids</option>
  <option>Gain musculaire</option>
</select>

<!-- Description longue -->
<p id="bmi-explanation">
  IMC (Indice Masse Corporelle) = poids (kg) / (taille(m))² Sain: 18.5-24.9 |
  Surpoids: 25-29.9 | Obèse: ≥30
</p>
<input type="number" aria-describedby="bmi-explanation" />
```

---

## 5. Checklist conformité MSPR 1 & 2

### MSPR 1 (Cible AA)

- [ ] Images: tous textes alternatifs présents
- [ ] Contraste: 4.5:1 minimum (texte normal)
- [ ] Clavier: TAB/Enter/Esc navigation complète
- [ ] Focus: visible & navigable
- [ ] Formulaires: labels associés
- [ ] Erreurs: messages clairs & suggestions
- [ ] Sémantique: HTML valide, headings structure
- [ ] Lecteur écran: ARIA landmarks, live regions
- [ ] Mobile: responsive 320px+ wide
- [ ] Pas de clignotement >3x/sec

### MSPR 2 (Cible AAA)

- [ ] Tout MSPR 1 +
- [ ] Contrastes: 7:1 minimum (AAA)
- [ ] Visualisations 3D: descriptions détaillées
- [ ] Recommandations: explications explicites
- [ ] Video: sous-titres + audio description
- [ ] Texte agrandi: lisible 200% sans scrolling horizontal
- [ ] Animations: respectent prefers-reduced-motion
- [ ] Multiple moyens: navigation & recherche
- [ ] Audit externe RGAA 4

---

## 6. Testing & Validation

### 6.1 Outils automatisés

- **axe DevTools** - Chrome extension (quick scan)
- **WAVE** - WebAIM validator
- **Lighthouse** - Google Chrome Audits
- **Pa11y** - CLI automated checker

```bash
# Testing avec pa11y
npm install -g pa11y
pa11y http://localhost:5173
```

### 6.2 Testing manuel

- Clavier seul (pas souris) 5 min complets
- Lecteur écran (NVDA Windows, JAWS, VoiceOver Mac)
- Zoom 200% lisibilité
- Gris mode (simulation daltonisme)
- Validation HTML: https://validator.w3.org

### 6.3 Audit tiers

- Cabinet agréé (RGAA France)
- Rapport formalisé
- Recommandations correctifs

---

## 7. Ressources & références

- [WCAG 2.1 Official](https://www.w3.org/WAI/WCAG21/quickref/)
- [RGAA 4 France](https://www.numerique.gouv.fr/publications/rgaa-accessibilite/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
- [WebAIM](https://webaim.org/)
