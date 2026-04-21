

🧶

**StitchMate**

Knitting & Crochet Companion App

**PROJECT OUTLINE & PRODUCT DESIGN REQUIREMENTS**

Version 1.1  |  April 2026

Platform: Flutter (iOS & Android)  |  IDE: VSCode \+ OpenCode

*CONFIDENTIAL — DEVELOPER WORKING DOCUMENT*

> ⚠️ **AI Agent Build Notice — v1.1**
> This document has been updated to work alongside a companion Harness file: **`StitchMate_HARNESS.md`**.
> If you are an AI coding agent (OpenCode, Claude Code, or similar), you must read `StitchMate_HARNESS.md` in full before acting on any instruction in this PDR. The Harness defines the constraints, quality gates, and build protocol that govern how this spec is implemented. This PDR defines **what** to build. The Harness defines **how** to build it.

---

# **1\. Executive Summary**

StitchMate is a lightweight, beautifully designed mobile companion app for knitters and crocheters. It targets crafters of all skill levels on both iOS and Android, providing the essential toolkit they reach for during every project — without the bloat, subscription fatigue, or performance issues found in competing apps.

The app is deliberately scoped for solo development using VSCode with the OpenCode AI coding assistant (connected to OpenRouter and a premium LLM such as Claude Opus). The goal is a polished, stable v1.0 that can be shipped to both app stores, with a clean architecture that makes future feature additions easy.

| Core Philosophy: Do fewer things, but do them exceptionally well. Every tool in StitchMate should feel as if it was designed by someone who actually knits. |
| :---- |

# **2\. Market Research & Competitive Analysis**

## **2.1 What Crafters Actually Need**

Research into the top knitting and crochet apps on the App Store and Google Play (YarnBuddy, Loopsy, knitCompanion, StitchCraft, YarnPal, LoopCraft, Knit Net) reveals consistent patterns in what users love and loathe:

### **What Users Love**

* Row counters that stay on screen and are impossible to accidentally reset

* Pattern PDF viewer with a row-tracking highlight bar

* Yarn stash inventory — especially with barcode scanning

* Abbreviation / stitch dictionary for quick lookups mid-project

* Multiple simultaneous project tracking

* Time tracking per project

* Apple Watch companion (nice-to-have, not MVP)

### **What Users Consistently Complain About**

* Lag and sluggish performance under counter \+ timer \+ PDF simultaneously

* Accidental counter resets with no undo

* Subscription paywalls for basic features

* Overly complex onboarding

* Poor tablet / large screen layout

* Pattern inaccuracies in built-in libraries (risky for DIY content)

## **2.2 Competitive Gap \= Our Opportunity**

No single app in this space nails all three: performance, simplicity, and design. StitchMate's opportunity is to be the fastest, cleanest, most reliable tool — not the most feature-rich. Users consistently say they would pay once (no subscription) for an app that just works without lag.

| App | Strengths | Weaknesses | Our Advantage |
| :---- | :---- | :---- | :---- |
| YarnBuddy | Clean UI, Apple Watch | iOS only, subscription | Android \+ one-time purchase option |
| Loopsy | Pattern import, smart steps | Heavy, laggy, subscription | Performance-first architecture |
| knitCompanion | Deep pattern tools | Complex UI, steep learning | Simpler, friendlier UX |
| YarnPal | Pattern library | Pattern errors, expensive | No built-in pattern library risk |
| StitchCraft | MCP integration, live activities | Subscription, overloaded | Focused tool set |

# **3\. Feature Set — MVP v1.0**

Features are grouped into MVP (must ship), Phase 2 (post-launch update), and Future (roadmap). Every MVP feature must work offline — no network dependency for core functionality.

## **3.1 Row Counter (Core Tool)**

| Priority: MVP — this is the \#1 tool every crafter opens the app for. |
| :---- |

* **Large, thumb-friendly tap target to increment counter (full-width button)**

* Swipe down to decrement (undo last tap)

* Long-press to set a specific row number manually

* Configurable stitch markers / repeat reminders at set intervals (e.g., "increase every 6 rows")

* Optional audio click / haptic feedback on increment

* Multiple independent counters per project (e.g., Row Counter \+ Repeat Counter simultaneously)

* Counter state persists on app close — cannot be lost without explicit user confirmation

* "Lock" mode to prevent accidental increments when phone in pocket

* Large-font display optimised for reading at arm's length

## **3.2 Project Manager**

| Priority: MVP — organises all tools around real projects. |
| :---- |

* **Create project with: name, craft type (knit/crochet), start date, notes**

* Attach photos to a project (from camera or gallery)

* Set needle/hook size and yarn details per project

* Project status: Active, Paused, Completed, Frogged (abandoned)

* View all projects in a card grid with progress indicator

* Each project has its own independent row counter(s) and timer

* Archive/delete completed projects

## **3.3 Stitch & Abbreviation Dictionary**

| Priority: MVP — offline reference, no external calls needed. |
| :---- |

* **Built-in dictionary of common knitting abbreviations (k, p, yo, k2tog, ssk, sl, psso, CO, BO, etc.)**

* Built-in dictionary of common crochet abbreviations (ch, sc, dc, hdc, tr, sl st, inc, dec, MR, etc.)

* Each entry has: full name, description, step-by-step technique note, difficulty level

* Searchable — type abbreviation or name to find

* Tab switcher: Knitting | Crochet | Both

* Favourites — star stitches you use frequently for quick access

* Categorised browsing: Basic, Increases, Decreases, Cables, Lace, Special Techniques

## **3.4 Yarn Stash Manager**

| Priority: MVP — extremely popular feature; simple to implement well. |
| :---- |

* **Add yarn with: brand, colour name, weight (lace → super bulky), fibre type, yardage/meterage per skein, number of skeins, hex colour swatch**

* Photo per yarn entry

* Link yarn entries to a project (tracks estimated usage)

* "Do I have enough?" simple calculator: project yardage needed vs stash available

* Filter/search stash by weight, colour, fibre

* "In Use" vs "Available" status

## **3.5 Project Timer**

| Priority: MVP — lightweight addition, high user value. |
| :---- |

* **Start/Pause/Stop timer per project**

* Cumulative time shown on project card

* Timer runs in background (foreground notification to keep it alive on both platforms)

* Session history: date \+ duration per session

* Timer does NOT cause UI lag — runs independently of counters

## **3.6 Gauge Calculator**

| Priority: MVP — essential maths tool, beloved by crafters. |
| :---- |

* **Input: stitches and rows in a 10cm/4in swatch**

* Calculate: how many stitches/rows needed for any target measurement

* Reverse: given a stitch count, what finished measurement will result?

* Unit toggle: cm / inches

* Save gauge per project

## **3.7 Needle & Hook Size Reference**

| Priority: MVP — simple static reference, zero maintenance. |
| :---- |

* **Conversion chart: US needle sizes ↔ metric mm ↔ UK/Canadian sizes**

* Crochet hook: US letter ↔ mm

* Suggested yarn weight per needle/hook size

* User can mark which sizes they own

## **3.8 Yarn Weight Reference & WPI Calculator**

| Priority: MVP — pairs naturally with needle reference. |
| :---- |

* **Lace, Fingering, Sport, DK, Worsted, Aran, Bulky, Super Bulky explained**

* WPI (Wraps Per Inch) calculator: user enters WPI and app identifies yarn weight

* Recommended needle/hook range per weight

## **3.9 Pattern Notes & Highlighter**

| Priority: Phase 2 — complex to do well; save for post-MVP update. |
| :---- |

* Import pattern as PDF (from Files, iCloud, Google Drive)

* Scrollable PDF viewer with a draggable row-highlight bar (horizontal line follows current row)

* Annotate with text notes per page

* Pattern syncs with project row counter

## **3.10 Quick Counter (No Project)**

| Priority: MVP — many users just want a fast standalone counter. |
| :---- |

* **Accessible from home screen without creating a project**

* Single counter, resets on close (with confirmation prompt)

* Prominent on dashboard

## **3.11 Settings & Personalisation**

* **Light / Dark / System theme**

* Accent colour picker (6 preset palette options)

* Default craft type (Knitting / Crochet / Both)

* Units: metric / imperial

* Counter haptics: On / Off

* Counter sound: Off / Soft click / Loud click

* Keep screen awake while counter is active

# **4\. Technical Architecture**

## **4.1 Technology Stack — Why Flutter**

Flutter is the recommended framework for StitchMate. Here is the rationale:

| Factor | Flutter | React Native | Winner |
| :---- | :---- | :---- | :---- |
| Language | Dart (easy to learn) | JavaScript / TypeScript | RN (if JS dev) |
| Performance | Native ARM compile, own render engine (Impeller) | JS bridge (improving with Fabric) | Flutter |
| UI Consistency | Pixel-perfect same on iOS & Android | Uses native components, can vary | Flutter |
| VSCode Support | Excellent Flutter \+ Dart extensions | Excellent RN extensions | Tie |
| AI Coding (Opus/OpenCode) | Dart is well-represented in training data | JS is very well-represented | Slight RN edge |
| Tablet Support | Excellent responsive layouts | Requires extra work | Flutter |
| Code Reuse | 95%+ across iOS/Android | \~70% mobile only | Flutter |
| App Store Readiness | Mature, production-proven | Mature, production-proven | Tie |

| Verdict: Use Flutter. Its rendering consistency across phones and tablets, hot reload for fast iteration with OpenCode, and 95%+ code reuse make it the superior choice for a solo developer shipping to both platforms. |
| :---- |

## **4.2 Project Structure**

Follow a clean feature-first folder structure for easy AI-assisted development:

| Folder / File | Purpose |
| :---- | :---- |
| lib/main.dart | App entry point, theme, routing |
| lib/core/ | App-wide constants, theme, utils |
| lib/features/counter/ | Row counter feature: widgets, logic, state |
| lib/features/projects/ | Project management screens and models |
| lib/features/dictionary/ | Stitch dictionary data and search UI |
| lib/features/stash/ | Yarn stash screens and models |
| lib/features/calculator/ | Gauge, WPI, yarn calculators |
| lib/features/reference/ | Needle/hook charts, yarn weight guide |
| lib/features/settings/ | App settings and preferences |
| lib/data/local/ | Hive / SQLite database helpers |
| lib/data/models/ | Data models (Project, Yarn, Counter, etc.) |
| assets/data/ | Static JSON: stitch dictionary, needle charts |

## **4.3 State Management**

* **Use Riverpod (v2) for state management — clear, testable, works perfectly with Flutter**

* Each feature has its own Provider / Notifier — avoids tangled global state

* Counter state uses StateNotifier with an immutable CounterState class

* No state is stored only in memory — every mutation persists to local DB immediately

## **4.4 Local Data Persistence**

* **Hive (NoSQL, pure Dart) for project, yarn stash, and counter data — extremely fast, zero native dependencies**

* SharedPreferences for simple settings (theme, units, defaults)

* All data is local and offline-first — no account or cloud required in v1

* Export: allow full data backup as JSON file (save to Files app / Downloads)

## **4.5 Key Packages**

| Package | Purpose | Why Chosen |
| :---- | :---- | :---- |
| flutter\_riverpod | State management | Type-safe, testable, community standard |
| hive / hive\_flutter | Local database | Fast, pure Dart, no setup friction |
| shared\_preferences | Settings storage | Simple key/value, official plugin |
| go\_router | Navigation / routing | Official, supports deep links and tablets |
| flutter\_svg | SVG icons & illustrations | Sharp at any screen density |
| audioplayers | Counter click sound | Lightweight, cross-platform |
| vibration | Haptic feedback | Works on both iOS and Android |
| image\_picker | Photo attachment for projects/yarn | Official plugin |
| share\_plus | Export / share data files | Cross-platform sharing sheet |
| intl | Date/number formatting | Official Dart internationalisation |
| path\_provider | File system access | Official, required for Hive |

## **4.6 UI Design System**

* **Material 3 (Material You) design language — feels native on Android, clean on iOS**

* Custom colour scheme: warm mauve/rose palette (approachable, crafty, not corporate)

* Font: Google Fonts — Nunito (friendly, rounded, excellent readability)

* Minimum tap target: 48×48dp (accessibility standard)

* Counter button: full-width, minimum 120dp height — cannot be missed

* Responsive layouts using LayoutBuilder — phones get bottom navigation; tablets get a side rail navigation

* Dark mode: full support, carefully chosen dark palette (not just inverted)

# **5\. Screen Map & Navigation**

## **5.1 Navigation Structure**

| Navigation Pattern: Bottom navigation bar (phones) with 5 tabs. On tablets (\>600dp width), this becomes a NavigationRail on the left side. |
| :---- |

| Tab | Icon | Screens within Tab |
| :---- | :---- | :---- |
| Home / Dashboard | Home | Quick Counter widget, Active Projects summary, Today's session time |
| Projects | Folder | Project list → Project Detail → Counter, Timer, Notes, Photos |
| Dictionary | Book | Stitch dictionary search, category browse, favourites |
| Stash | Yarn ball | Yarn list, Add yarn, Yarn detail, 'Do I have enough?' calc |
| Tools | Wrench | Gauge Calc, WPI Calc, Needle chart, Yarn weight guide, Settings |

## **5.2 Screen Inventory**

Complete list of screens to be built in v1.0:

1. Splash Screen (app open, 1.5s max)

2. Dashboard / Home

3. Quick Counter (full-screen, accessible from dashboard)

4. Project List

5. New Project (create / edit form)

6. Project Detail (tabs: Counter | Timer | Notes | Photos)

7. Stitch Dictionary — Search & Browse

8. Stitch Detail

9. Yarn Stash List

10. Add / Edit Yarn

11. Yarn Detail

12. Gauge Calculator

13. WPI Calculator

14. Needle & Hook Size Chart

15. Yarn Weight Reference Guide

16. Settings

17. About / Acknowledgements

# **6\. Data Models**

## **6.1 Project**

| Field | Type | Notes |
| :---- | :---- | :---- |
| id | String (UUID) | Auto-generated on create |
| name | String | Required |
| craftType | Enum (knit/crochet/other) | Filters dictionary tab |
| status | Enum (active/paused/done/frogged) |  |
| startDate | DateTime |  |
| endDate | DateTime? | Nullable |
| notes | String | Free text, markdown supported |
| yarnIds | List\<String\> | References Yarn entries |
| needleSize | String | e.g. '4.0mm / US 6' |
| gaugeStitches | double? | Per 10cm swatch |
| gaugeRows | double? | Per 10cm swatch |
| counters | List\<Counter\> | Embedded counter objects |
| totalTimeSeconds | int | Running total from timer |
| photoUris | List\<String\> | Local file paths |
| tags | List\<String\> | User-defined tags |

## **6.2 Counter**

| Field | Type | Notes |
| :---- | :---- | :---- |
| id | String | UUID |
| label | String | e.g. 'Rows', 'Repeats', 'Short rows' |
| currentValue | int | Persisted immediately on change |
| targetValue | int? | Optional goal — shows progress bar |
| reminderEvery | int? | Alert every N increments |
| reminderNote | String? | e.g. 'Increase 1 stitch each side' |
| isLocked | bool | Prevents accidental taps |

## **6.3 Yarn**

| Field | Type | Notes |
| :---- | :---- | :---- |
| id | String | UUID |
| brand | String |  |
| colourName | String |  |
| colourHex | String? | Hex code for swatch display |
| weight | Enum | lace / fingering / sport / dk / worsted / aran / bulky / super\_bulky |
| fibre | String | e.g. '100% Merino Wool' |
| yardsPerSkein | double? |  |
| metresPerSkein | double? | One or both |
| gramsPerSkein | double? |  |
| skeinCount | double | Can be fractional (0.5 skeins) |
| status | Enum | available / in\_use / used\_up |
| photoUri | String? |  |
| purchaseLocation | String? |  |
| notes | String |  |

# **7\. Development Plan & Milestones**

## **7.1 Recommended Development Order**

This order is optimised for solo development with an AI coding assistant. It builds the most complex, interdependent parts first (data \+ state), then adds features on top of a stable foundation.

| Sprint | Duration | Deliverables | Risk |
| :---- | :---- | :---- | :---- |
| 0 — Setup | 3 days | Flutter project scaffold, folder structure, Riverpod \+ Hive wired up, design system (theme, fonts, colours), go\_router navigation shell with 5 tabs | Low |
| 1 — Counter | 5 days | Full row counter with persist, haptics, sound, lock mode, multiple counters per project, quick counter on dashboard | Low |
| 2 — Projects | 7 days | Project CRUD, project list, project detail screen, link counter to project, project photos, status management | Medium |
| 3 — Dictionary | 5 days | Static JSON data for \~80 knit \+ \~80 crochet stitches/abbreviations, search, category browse, favourites, stitch detail screen | Low |
| 4 — Stash | 5 days | Yarn CRUD, stash list, yarn detail, colour swatch, link to project, 'enough yarn?' calculator | Low |
| 5 — Tools | 5 days | Gauge calculator, WPI calculator, needle chart, yarn weight guide, units toggle cm/inch | Low |
| 6 — Timer | 3 days | Project timer with background service, session history, foreground notification | Medium |
| 7 — Settings & Polish | 5 days | Settings screen, dark mode, accent colour, onboarding flow (3 screens), app icon, splash screen | Low |
| 8 — QA & Release Prep | 7 days | Device testing (phones \+ tablets, iOS \+ Android), bug fixes, App Store / Play Store assets, privacy policy, submission | Medium |

| Total Estimated Duration: \~45 working days (9 weeks) for a solo developer using OpenCode \+ Claude Opus as coding assistant. With AI assistance, expect 30–40% time savings vs unassisted development. |
| :---- |

## **7.2 OpenCode \+ OpenRouter Workflow Tips**

> 📋 **Before starting any sprint:** Read `StitchMate_HARNESS.md` and the relevant PDR section for that sprint. The Harness defines the sprint protocol (Plan → Execute → Verify), the Sprint Completion Checklist, and the Tier Boundary Rules that govern what the agent may do autonomously.

* **Always provide OpenCode with the full feature spec from this document before starting a sprint**

* **Always provide OpenCode with `StitchMate_HARNESS.md` at the start of each new session** — the Harness contains the architectural invariants, UX constraints, and quality gates that must be followed

* Commit to Git after every working feature — OpenCode can sometimes hallucinate Dart syntax; git diff makes rollbacks easy

* Ask OpenCode to write tests alongside the feature code (Riverpod providers are very testable)

* Use OpenCode for boilerplate (model classes, CRUD screens, form validation) — it excels at this

* Handle the UX polish (animations, spacing, colour) yourself by reviewing hot-reload output

* Keep a PROMPTS.md file per sprint with the exact prompts that worked well — reuse them

* Maintain `SPRINT_LOG.md` (see Harness Section 5.2) — this is the memory bridge between sessions

# **8\. UX Design Principles**

## **8.1 The Crafter's Context**

Knitters and crocheters use their phones in a uniquely challenging way: one hand holds yarn, the other holds needles/hooks. The phone is often in the user's lap, on a table beside them, or propped against something. Fingers may be slightly tangled in yarn.

| Design Implication: Every interactive element must be tappable with a thumb, from any angle, without looking carefully. If a user has to squint or reach with a pinky, it's a design failure. |
| :---- |

## **8.2 Non-Negotiable UX Rules**

* **The row counter increment button must occupy at least 40% of the screen height when in use**

* No confirmation dialogs for non-destructive actions (incrementing, decrementing)

* Destructive actions (delete project, reset counter) always require a 2-step confirmation

* No feature should require more than 3 taps from the home screen

* All text must be readable at arm's length — minimum body font size 16sp

* Screen must stay awake when counter is active (configurable, but default ON)

* App must launch and reach the counter in under 2 seconds on a 3-year-old mid-range phone

## **8.3 Accessibility**

* **Minimum contrast ratio: 4.5:1 for all text (WCAG AA)**

* All interactive elements have semantic labels for screen readers

* Support system font size scaling (do not fix font sizes in pixels)

* Do not rely on colour alone to convey information

# **9\. Monetisation Strategy**

## **9.1 Model: Free \+ One-Time Purchase**

Based on user sentiment research, crafters are subscription-fatigued. The recommended model is a free tier with a single one-time in-app purchase to unlock all features. No recurring charges.

| Tier | Price | Included Features |
| :---- | :---- | :---- |
| Free | $0 | Quick Counter (single), 1 active project, Stitch Dictionary (read-only, no favourites), Needle chart |
| StitchMate Pro | $4.99 one-time | Everything: unlimited projects, multiple counters, yarn stash, timer, gauge calculator, favourites, colour themes, data export |

| Rationale: A $4.99 one-time purchase removes all friction. Users who love the app will happily pay this. Do not complicate v1 with ads or subscriptions — they are the \#1 user complaint across competing apps. |
| :---- |

## **9.2 Future Revenue Options (Phase 3+)**

* Optional "tip jar" in-app purchase at $1.99 / $4.99 / $9.99

* Seasonal stitch pattern pack add-ons (curated, tested, pay once)

* Pro subscription for cloud sync \+ multi-device in v3 (if demand exists)

# **10\. Risks & Mitigations**

| Risk | Likelihood | Impact | Mitigation |
| :---- | :---- | :---- | :---- |
| Background timer killed by OS (iOS/Android battery optimisation) | High | High | Use flutter\_foreground\_task with a persistent notification. Test on real devices, not just simulator. |
| Counter state lost on crash | Medium | High | Write counter to Hive on every single increment, not on app close. Use Hive transactions. |
| Dart / Flutter version breaking changes | Low | Medium | Pin to a stable Flutter channel. Run flutter upgrade only before a planned sprint. |
| App Store rejection (iOS) | Low | High | Follow Apple HIG. Include privacy policy. Declare no data collection. |
| OpenCode generates incorrect Dart syntax | Medium | Low | Always run flutter analyze after AI-generated code. Keep unit tests for core logic. |
| Tablet layout breaks on unexpected screen sizes | Medium | Medium | Use LayoutBuilder breakpoints. Test on emulators for 7" and 10" tablets. |
| Stitch dictionary data is incorrect | Low | High | Have data proofread by at least one experienced knitter/crocheter before shipping. |

# **11\. Pre-Launch Checklist**

## **11.1 Technical**

* **flutter analyze returns zero errors or warnings**

* All features tested on physical iPhone (iOS 16+) and Android phone (API 31+)

* Tablet layout tested on 7" and 10" form factors

* Counter persist verified: kill app mid-count, reopen, count preserved

* Timer background test: lock phone for 10 minutes, timer still accurate

* Dark mode: all screens checked

* Large font size: system font at maximum tested

* Data export and import tested

* App size: target \< 30MB install

## **11.2 App Store Assets Needed**

* **App icon: 1024×1024px PNG (no alpha, no rounded corners — stores apply masks)**

* iOS screenshots: 6.7" (iPhone 15 Pro Max) and 12.9" (iPad Pro) sizes

* Android screenshots: phone and tablet sizes

* Short description: ≤80 chars

* Full description: ≤4000 chars

* Privacy policy URL (required by both stores)

* App category: Lifestyle or Utilities

* Age rating: 4+ / Everyone

## **11.3 Legal / Compliance**

* **Privacy policy clearly states: no data collected, no analytics, no ads, all data stored locally**

* No third-party tracking SDKs

* Open source licences for all packages included in About screen

# **12\. Future Roadmap (Phase 2 & Beyond)**

| Phase | Feature | Notes |
| :---- | :---- | :---- |
| 2 | PDF pattern import \+ row highlight bar | Use syncfusion\_flutter\_pdfviewer or pdfrx |
| 2 | Pattern annotation (draw notes on PDF) | Complex — consider flutter\_drawing\_board |
| 2 | Apple Watch / Wear OS counter companion | High effort; requires separate Watch target |
| 2 | Barcode scanner for yarn (ISBN lookup) | Use mobile\_scanner package \+ yarn API |
| 2 | Ravelry integration (pattern library sync) | Requires Ravelry API key — check their terms |
| 3 | iCloud / Google Drive sync | Allows multi-device use; high complexity |
| 3 | Knitting chart / stitch chart builder | Visual grid editor — large feature |
| 3 | Community pattern sharing | Backend required — Supabase or Firebase |
| 3 | AI stitch identifier (photo → stitch name) | On-device ML with TFLite or server API |
| 3 | Left-handed mode mirror | Flip illustration SVGs horizontally |

# **13\. Stitch Dictionary — Data Specification**

The stitch dictionary is stored as a static JSON file bundled with the app (assets/data/stitches.json). No network required. The schema for each entry:

| Field | Type | Description |
| :---- | :---- | :---- |
| id | string | Unique slug e.g. 'k2tog' |
| abbreviation | string | e.g. 'k2tog' |
| fullName | string | e.g. 'Knit Two Together' |
| craft | string | 'knitting' | 'crochet' | 'both' |
| category | string | 'basic' | 'increase' | 'decrease' | 'cable' | 'lace' | 'special' |
| difficulty | string | 'beginner' | 'intermediate' | 'advanced' |
| description | string | Plain English explanation of what the stitch does |
| steps | string\[\] | Array of step-by-step instructions |
| also\_known\_as | string\[\] | Alternative names or abbreviations |
| usRegion | bool | Is this a US-convention stitch term? |
| ukRegion | bool | Is this a UK-convention stitch term? |

## **13.1 Minimum Dictionary Content for v1.0**

### **Knitting Abbreviations (target: 60+ entries)**

CO, BO/Cast off, k, p, yo, k2tog, ssk, sl, psso, kfb, M1L, M1R, w\&t, pm, sm, rm, RS, WS, cn, C4F, C4B, rnd, rep, st(s), inc, dec, tbl, wyif, wyib, k1tbl, p1tbl, SK2P, S2KP, CDD, ktbl, skp, k3tog, p2tog, p3tog, pfb, LLI, RLI, LRI, RRI, MB, PB, sl1k, sl1p, SKPO, k1b, p1b

### **Crochet Abbreviations (target: 60+ entries)**

ch, sl st, sc, hdc, dc, tr, dtr, trtr, inc, dec, MR/magic ring, FO, BLO, FLO, FPdc, BPdc, FPsc, BPsc, ch sp, join, turn, rnd, rep, sp, st(s), sk, yo, pm, sc2tog, dc2tog, hdc2tog, inv dec, shell, cluster, bobble, puff, popcorn, spike sc, waistcoat st, bean st, v-stitch, X-stitch, crossed dc, bullion st, crocodile st, broomstick lace, hairpin lace

# **Appendix A: Recommended VSCode Extensions**

| Extension | Publisher | Purpose |
| :---- | :---- | :---- |
| Dart | Dart Code | Dart language support |
| Flutter | Dart Code | Flutter development tools, hot reload |
| Flutter Widget Snippets | Alexiva | Code snippets for common widgets |
| Bracket Pair Colorizer 2 | CoenraadS | Visual bracket matching for Dart |
| GitLens | GitKraken | Enhanced git history and blame |
| Error Lens | Alexander | Inline error highlighting |
| Todo Tree | Gruntfuggly | Track TODO comments across files |
| REST Client | Huachao | Test any future API calls inline |

# **Appendix B: Useful Flutter CLI Commands**

| Command | Purpose |
| :---- | :---- |
| flutter create stitch\_mate | Create new Flutter project |
| flutter run | Run on connected device/emulator |
| flutter build apk \--release | Build Android release APK |
| flutter build appbundle \--release | Build Android App Bundle (Play Store) |
| flutter build ios \--release | Build iOS release (requires Mac \+ Xcode) |
| flutter analyze | Static analysis (run before every commit) |
| flutter test | Run all unit and widget tests |
| flutter pub get | Install packages from pubspec.yaml |
| flutter pub upgrade | Upgrade packages to latest compatible |
| dart format lib/ | Auto-format all Dart files |

# **Appendix C: Useful OpenCode / Claude Opus Prompts**

> 📋 **See also:** `StitchMate_HARNESS.md` Part 9 (Appendix) for the full set of recommended prompt templates that encode harness constraints directly into each prompt. The templates below are a quick-start reference; the Harness versions are preferred as they embed quality gates into the prompt itself.

These prompt patterns work well when using OpenCode with Claude Opus for Flutter development:

* **"Generate a Hive-backed Riverpod StateNotifier for \[Model\]. Include the HiveType adapter, box initialisation, and CRUD methods. Use immutable state with copyWith."**

* "Create a Flutter screen for \[FeatureName\]. Use Material 3 widgets, match this colour scheme: primary=\#7B3F6E. Include proper padding and responsiveness using LayoutBuilder for tablets."

* "Write a widget test for \[WidgetName\] that verifies \[behaviour\]. Use flutter\_test and Riverpod's ProviderContainer for mocking."

* "Refactor this provider to use Riverpod's AsyncNotifier pattern and handle loading/error/data states properly."

* "Generate the full JSON data for 20 knitting stitch abbreviations following this schema: \[paste schema from Section 13\]. Include realistic, accurate descriptions."

*— End of Document —*

StitchMate v1.1 PDR  |  April 2026

*v1.1 changes from v1.0: Added AI Agent Build Notice (top of document), updated Section 7.2 with Harness integration guidance, updated Appendix C with reference to Harness prompt templates. All feature specs unchanged.*