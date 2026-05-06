<div align="center">

<svg width="100%" height="340" viewBox="0 0 1200 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="KharchaAI">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#0A0E1A"/>
      <stop offset="50%" stop-color="#0F1729"/>
      <stop offset="100%" stop-color="#0A0E1A"/>
    </linearGradient>
    <linearGradient id="barGrad" x1="0" y1="1" x2="0" y2="0">
      <stop offset="0%" stop-color="#00D4C5" stop-opacity="0.2"/>
      <stop offset="100%" stop-color="#00D4C5" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="textGrad" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%" stop-color="#FFFFFF"/>
      <stop offset="50%" stop-color="#00D4C5"/>
      <stop offset="100%" stop-color="#FFFFFF"/>
      <animate attributeName="x1" values="-1;1" dur="4s" repeatCount="indefinite"/>
      <animate attributeName="x2" values="0;2" dur="4s" repeatCount="indefinite"/>
    </linearGradient>
    <radialGradient id="glow" cx="0.5" cy="0.5" r="0.5">
      <stop offset="0%" stop-color="#00D4C5" stop-opacity="0.4"/>
      <stop offset="100%" stop-color="#00D4C5" stop-opacity="0"/>
    </radialGradient>
    <filter id="blur"><feGaussianBlur stdDeviation="3"/></filter>
  </defs>

  <rect width="1200" height="340" fill="url(#bg)"/>

  <!-- Ambient grid -->
  <g stroke="#00D4C5" stroke-opacity="0.04" stroke-width="1">
    <line x1="0" y1="80" x2="1200" y2="80"/>
    <line x1="0" y1="160" x2="1200" y2="160"/>
    <line x1="0" y1="240" x2="1200" y2="240"/>
  </g>

  <!-- Glow halo behind wordmark -->
  <circle cx="600" cy="150" r="180" fill="url(#glow)">
    <animate attributeName="r" values="160;200;160" dur="3s" repeatCount="indefinite"/>
    <animate attributeName="opacity" values="0.6;1;0.6" dur="3s" repeatCount="indefinite"/>
  </circle>

  <!-- Floating ₹ particles -->
  <g fill="#00D4C5" font-family="system-ui" font-size="20" opacity="0.5">
    <text x="120" y="280">₹
      <animate attributeName="y" from="320" to="40" dur="6s" repeatCount="indefinite"/>
      <animate attributeName="opacity" values="0;0.6;0" dur="6s" repeatCount="indefinite"/>
    </text>
    <text x="280" y="280">₹
      <animate attributeName="y" from="320" to="40" dur="7s" begin="2s" repeatCount="indefinite"/>
      <animate attributeName="opacity" values="0;0.5;0" dur="7s" begin="2s" repeatCount="indefinite"/>
    </text>
    <text x="950" y="280">₹
      <animate attributeName="y" from="320" to="40" dur="8s" begin="1s" repeatCount="indefinite"/>
      <animate attributeName="opacity" values="0;0.6;0" dur="8s" begin="1s" repeatCount="indefinite"/>
    </text>
    <text x="1080" y="280">₹
      <animate attributeName="y" from="320" to="40" dur="6.5s" begin="3s" repeatCount="indefinite"/>
      <animate attributeName="opacity" values="0;0.5;0" dur="6.5s" begin="3s" repeatCount="indefinite"/>
    </text>
  </g>

  <!-- Bars left -->
  <g>
    <rect x="60" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="60" dur="1.2s" fill="freeze"/>
      <animate attributeName="y" from="280" to="220" dur="1.2s" fill="freeze"/>
    </rect>
    <rect x="100" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="110" dur="1.4s" begin="0.15s" fill="freeze"/>
      <animate attributeName="y" from="280" to="170" dur="1.4s" begin="0.15s" fill="freeze"/>
    </rect>
    <rect x="140" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="80" dur="1.2s" begin="0.3s" fill="freeze"/>
      <animate attributeName="y" from="280" to="200" dur="1.2s" begin="0.3s" fill="freeze"/>
    </rect>
    <rect x="180" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="140" dur="1.5s" begin="0.45s" fill="freeze"/>
      <animate attributeName="y" from="280" to="140" dur="1.5s" begin="0.45s" fill="freeze"/>
    </rect>
  </g>

  <!-- Bars right -->
  <g>
    <rect x="990" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="100" dur="1.3s" begin="0.2s" fill="freeze"/>
      <animate attributeName="y" from="280" to="180" dur="1.3s" begin="0.2s" fill="freeze"/>
    </rect>
    <rect x="1030" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="70" dur="1.2s" begin="0.35s" fill="freeze"/>
      <animate attributeName="y" from="280" to="210" dur="1.2s" begin="0.35s" fill="freeze"/>
    </rect>
    <rect x="1070" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="130" dur="1.5s" begin="0.5s" fill="freeze"/>
      <animate attributeName="y" from="280" to="150" dur="1.5s" begin="0.5s" fill="freeze"/>
    </rect>
    <rect x="1110" y="280" width="28" height="0" rx="4" fill="url(#barGrad)">
      <animate attributeName="height" from="0" to="55" dur="1.2s" begin="0.65s" fill="freeze"/>
      <animate attributeName="y" from="280" to="225" dur="1.2s" begin="0.65s" fill="freeze"/>
    </rect>
  </g>

  <!-- Pulse dot -->
  <circle cx="600" cy="80" r="5" fill="#00D4C5">
    <animate attributeName="r" values="4;9;4" dur="1.8s" repeatCount="indefinite"/>
    <animate attributeName="opacity" values="1;0.3;1" dur="1.8s" repeatCount="indefinite"/>
  </circle>

  <!-- Wordmark -->
  <text x="600" y="170" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="78" font-weight="800" fill="url(#textGrad)" letter-spacing="-2">
    KharchaAI
  </text>

  <!-- Tagline -->
  <text x="600" y="210" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="18" font-weight="400" fill="#9CA3AF" letter-spacing="3">
    M O N E Y &nbsp;·&nbsp; I N T E L L I G E N C E &nbsp;·&nbsp; I N D I A
  </text>

  <!-- Animated underline -->
  <line x1="500" y1="232" x2="500" y2="232" stroke="#00D4C5" stroke-width="2">
    <animate attributeName="x2" from="500" to="700" dur="1.5s" begin="0.8s" fill="freeze"/>
  </line>
</svg>

<br/>

**Your money, finally answering back.**

</div>

---

## The Problem It Solves

Indian users juggle bank SMS chaos, scattered receipts, and tax-season panic. Most finance apps either demand bank credentials, drown users in graphs, or pretend a chatbot is "AI." KharchaAI is built for the gap between *spreadsheet discipline* and *zero discipline* — for people who want clarity without surrendering account access.

<br/>

<div align="center">

<svg width="100%" height="40" viewBox="0 0 1200 40" xmlns="http://www.w3.org/2000/svg">
  <path d="M0,20 Q150,5 300,20 T600,20 T900,20 T1200,20" stroke="#00D4C5" stroke-width="2" fill="none" stroke-opacity="0.6">
    <animate attributeName="d"
      values="M0,20 Q150,5 300,20 T600,20 T900,20 T1200,20;
              M0,20 Q150,35 300,20 T600,20 T900,20 T1200,20;
              M0,20 Q150,5 300,20 T600,20 T900,20 T1200,20"
      dur="6s" repeatCount="indefinite"/>
  </path>
</svg>

</div>

## What You Actually Get

<table>
<tr>
<td width="33%" valign="top">

### 🧠 An advisor that knows *your* numbers
Not a generic chatbot. Gemini 2.5 Flash sees your real balance, recent transactions, and category splits before answering. Ask *"can I afford this?"* and get an answer grounded in last week's biryani spend, not boilerplate.

</td>
<td width="33%" valign="top">

### 📷 A camera that does the typing
Point at any printed receipt — kirana, Swiggy, fuel, hospital. On-device ML Kit OCR pulls the total in under a second. No upload, no cloud round-trip, no awkward forms.

</td>
<td width="33%" valign="top">

### 📊 A dashboard that updates as you breathe
Add a transaction. Watch the category bars redistribute. Watch the percentages move. Insights aren't a weekly report — they're the next frame after you tap *Save*.

</td>
</tr>
</table>

<br/>

<div align="center">

<svg width="100%" height="40" viewBox="0 0 1200 40" xmlns="http://www.w3.org/2000/svg">
  <path d="M0,20 Q150,5 300,20 T600,20 T900,20 T1200,20" stroke="#00D4C5" stroke-width="2" fill="none" stroke-opacity="0.6">
    <animate attributeName="d"
      values="M0,20 Q150,5 300,20 T600,20 T900,20 T1200,20;
              M0,20 Q150,35 300,20 T600,20 T900,20 T1200,20;
              M0,20 Q150,5 300,20 T600,20 T900,20 T1200,20"
      dur="6s" begin="-2s" repeatCount="indefinite"/>
  </path>
</svg>

</div>

## Inside the Build

<details open>
<summary><b>🔐 &nbsp; Authentication that doesn't get in the way</b></summary>
<br/>

Firebase Auth with persistent sessions — open the app three weeks later, you're still in. Glassmorphic login flow with backdrop blur, password visibility toggle, and animated transitions that don't waste your time.

</details>

<details open>
<summary><b>💸 &nbsp; Transactions that respect your time</b></summary>
<br/>

One tap on the floating action button. Pick from 9 curated categories (Food, Transport, Bills, Salary, Freelance, and the rest). Swipe-to-delete in the Activity tab. Running balance recalculates instantly. Everything persists locally via SharedPreferences — no network, no waiting.

</details>

<details open>
<summary><b>🤖 &nbsp; A financial advisor with context</b></summary>
<br/>

Powered by **Gemini 2.5 Flash**. Before each response, the model is fed the user's actual balance, expense categories, income breakdown, and recent transactions. Answers are calibrated to **Indian tax law (FY 2025-26)** — 80C, PPF, ELSS, the lot. Chat history persists across sessions. One-tap suggestion chips for the questions everyone has but nobody types. 30-second timeout with graceful fallback.

</details>

<details open>
<summary><b>📷 &nbsp; OCR that runs on the device</b></summary>
<br/>

Camera or gallery → Google ML Kit text recognition → automatic total detection. Nothing leaves the phone. Works offline. Built for messy real-world receipts, not sample data.

</details>

<details open>
<summary><b>⚙️ &nbsp; Settings that survive reboot</b></summary>
<br/>

Dark / Light mode with full theme propagation. Notification toggles, biometric login, auto-read SMS — all backed by SharedPreferences. Profile pulls live from Firebase, not a local cache that drifts.

</details>

<details open>
<summary><b>🎨 &nbsp; A design that earns the dark mode label</b></summary>
<br/>

`#00D4C5` teal accent on glassmorphic dark surfaces. Poppins for display, Inter for body — paired the way they're meant to be. Staggered fade-ins via `flutter_animate`. Time-aware greetings (Good Morning / Afternoon / Evening). Bottom navigation with three tabs that actually need to be tabs.

</details>

<br/>

## Engineering Stack

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Gemini](https://img.shields.io/badge/Gemini_2.5_Flash-8E75B2?style=for-the-badge&logo=google&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-3B82F6?style=for-the-badge&logo=flutter&logoColor=white)
![ML Kit](https://img.shields.io/badge/ML_Kit-4285F4?style=for-the-badge&logo=google&logoColor=white)

</div>

| Layer | Choice | Why |
|---|---|---|
| **Framework** | Flutter | One codebase, native performance |
| **State** | Riverpod | Compile-safe, testable, no `BuildContext` games |
| **Routing** | GoRouter (ShellRoute) | Bottom nav that doesn't fight back navigation |
| **Auth** | Firebase Auth | Persistent sessions out of the box |
| **AI** | Gemini 2.5 Flash | Latency low enough for chat, context window large enough for real data |
| **OCR** | Google ML Kit | On-device, no network, no privacy concession |
| **Storage** | SharedPreferences | Zero ceremony for local-first state |
| **Config** | flutter_dotenv | Keys in `.env`, not in source |
| **Build** | Java 17 + AGP Kotlin DSL | Modern toolchain, suppressed warning noise |

<br/>

## Architecture, in One Glance

<div align="center">

<svg width="100%" height="280" viewBox="0 0 1000 280" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#00D4C5"/>
    </marker>
  </defs>

  <!-- User -->
  <g>
    <rect x="40" y="110" width="140" height="60" rx="10" fill="#0F1729" stroke="#00D4C5" stroke-width="1.5"/>
    <text x="110" y="138" text-anchor="middle" fill="#fff" font-family="system-ui" font-size="14" font-weight="600">User Action</text>
    <text x="110" y="156" text-anchor="middle" fill="#9CA3AF" font-family="system-ui" font-size="11">tap · scan · ask</text>
  </g>

  <!-- Flutter UI -->
  <g>
    <rect x="240" y="110" width="160" height="60" rx="10" fill="#0F1729" stroke="#00D4C5" stroke-width="1.5"/>
    <text x="320" y="138" text-anchor="middle" fill="#fff" font-family="system-ui" font-size="14" font-weight="600">Flutter UI</text>
    <text x="320" y="156" text-anchor="middle" fill="#9CA3AF" font-family="system-ui" font-size="11">Riverpod · GoRouter</text>
  </g>

  <!-- Branches -->
  <g>
    <rect x="460" y="30" width="170" height="50" rx="10" fill="#0F1729" stroke="#00D4C5" stroke-width="1.5"/>
    <text x="545" y="60" text-anchor="middle" fill="#fff" font-family="system-ui" font-size="13" font-weight="600">Firebase Auth</text>
  </g>
  <g>
    <rect x="460" y="115" width="170" height="50" rx="10" fill="#0F1729" stroke="#00D4C5" stroke-width="1.5"/>
    <text x="545" y="138" text-anchor="middle" fill="#fff" font-family="system-ui" font-size="13" font-weight="600">ML Kit (on-device)</text>
    <text x="545" y="153" text-anchor="middle" fill="#9CA3AF" font-family="system-ui" font-size="10">OCR · text recognition</text>
  </g>
  <g>
    <rect x="460" y="200" width="170" height="50" rx="10" fill="#0F1729" stroke="#00D4C5" stroke-width="1.5"/>
    <text x="545" y="223" text-anchor="middle" fill="#fff" font-family="system-ui" font-size="13" font-weight="600">Gemini 2.5 Flash</text>
    <text x="545" y="238" text-anchor="middle" fill="#9CA3AF" font-family="system-ui" font-size="10">+ user context payload</text>
  </g>

  <!-- Storage -->
  <g>
    <rect x="700" y="110" width="240" height="60" rx="10" fill="#0F1729" stroke="#00D4C5" stroke-width="1.5"/>
    <text x="820" y="138" text-anchor="middle" fill="#fff" font-family="system-ui" font-size="14" font-weight="600">SharedPreferences</text>
    <text x="820" y="156" text-anchor="middle" fill="#9CA3AF" font-family="system-ui" font-size="11">transactions · settings · chat</text>
  </g>

  <!-- Animated flow lines -->
  <g stroke="#00D4C5" stroke-width="2" fill="none" marker-end="url(#arrow)">
    <line x1="180" y1="140" x2="240" y2="140" stroke-dasharray="4 4">
      <animate attributeName="stroke-dashoffset" from="0" to="-16" dur="0.8s" repeatCount="indefinite"/>
    </line>
    <line x1="400" y1="125" x2="460" y2="60" stroke-dasharray="4 4">
      <animate attributeName="stroke-dashoffset" from="0" to="-16" dur="0.8s" repeatCount="indefinite"/>
    </line>
    <line x1="400" y1="140" x2="460" y2="140" stroke-dasharray="4 4">
      <animate attributeName="stroke-dashoffset" from="0" to="-16" dur="0.8s" repeatCount="indefinite"/>
    </line>
    <line x1="400" y1="160" x2="460" y2="220" stroke-dasharray="4 4">
      <animate attributeName="stroke-dashoffset" from="0" to="-16" dur="0.8s" repeatCount="indefinite"/>
    </line>
    <line x1="630" y1="140" x2="700" y2="140" stroke-dasharray="4 4">
      <animate attributeName="stroke-dashoffset" from="0" to="-16" dur="0.8s" repeatCount="indefinite"/>
    </line>
  </g>
</svg>

</div>

Auth stays in Firebase. AI runs in the cloud. OCR stays on-device. Everything else lives locally — which is why the app feels instant and works on a flaky train.

<br/>

## Privacy Posture

- **No bank credentials. Ever.** This isn't an aggregator.
- **OCR is on-device.** Your receipts don't leave the phone.
- **API keys via `.env`**, gitignored, never compiled into source.
- **Only the AI advisor touches the network** for inference — and the prompt is the data, not your account.

<br/>


## Built For

The Indian millennial and Gen-Z user who wants to know *where the money went* without handing over net banking credentials, who has a folder of receipts they'll "deal with later," and who has googled *"how to save tax"* at least three times this year.

<br/>

<div align="center">

<svg width="200" height="40" viewBox="0 0 200 40" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="20" r="4" fill="#00D4C5">
    <animate attributeName="r" values="3;6;3" dur="1.5s" repeatCount="indefinite"/>
  </circle>
  <circle cx="80" cy="20" r="3" fill="#00D4C5" opacity="0.6">
    <animate attributeName="r" values="2;5;2" dur="1.5s" begin="0.2s" repeatCount="indefinite"/>
  </circle>
  <circle cx="120" cy="20" r="3" fill="#00D4C5" opacity="0.6">
    <animate attributeName="r" values="2;5;2" dur="1.5s" begin="0.2s" repeatCount="indefinite"/>
  </circle>
  <circle cx="60" cy="20" r="2" fill="#00D4C5" opacity="0.3">
    <animate attributeName="r" values="1;4;1" dur="1.5s" begin="0.4s" repeatCount="indefinite"/>
  </circle>
  <circle cx="140" cy="20" r="2" fill="#00D4C5" opacity="0.3">
    <animate attributeName="r" values="1;4;1" dur="1.5s" begin="0.4s" repeatCount="indefinite"/>
  </circle>
</svg>

<sub>Crafted in Flutter · Powered by Gemini · Built in India</sub>

</div>