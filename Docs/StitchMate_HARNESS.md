# 🧶 StitchMate — AI Agent Harness

**Version 1.0 | April 2026**
**For use with: OpenCode + OpenRouter + Claude Opus (or equivalent frontier LLM)**
**Read this file in full before executing any task from the PDR.**

---

## What This File Is

This is the **Harness** for the StitchMate project. It is not a feature spec — that is the PDR (`StitchMate_PDR_v1_0.md`). This file is the **control layer** that governs *how* you build, not *what* you build.

Harness engineering is the discipline of designing constraints, feedback loops, and quality gates that make AI-assisted development reliable across multiple sessions. The principle is simple: whenever an agent makes a mistake, the harness prevents that exact mistake from ever happening again. Every rule in this file exists because a real category of AI-generated code failure would occur without it.

**The model: `Agent = PDR (spec) + Harness (constraints)`.**

Read the PDR for the *what*. Follow this Harness for the *how*.

---

## Part 1 — Project Identity Lock

Before writing a single line of code, internalise these fixed facts. They are the anchor that prevents concept drift across sessions.

| Property | Value |
|---|---|
| App name | StitchMate |
| Tagline | "Do fewer things, but do them exceptionally well." |
| Target user | Knitters and crocheters of all skill levels |
| Platform | Flutter (iOS + Android) — no web, no desktop in v1 |
| Language | Dart (Flutter SDK, latest stable channel) |
| IDE | VSCode with OpenCode extension |
| State management | Riverpod v2 only — no Provider, no Bloc, no GetX |
| Local persistence | Hive (NoSQL) + SharedPreferences for settings |
| Navigation | go_router only |
| UI system | Material 3 (Material You) |
| Primary colour | `#7B3F6E` (warm mauve) |
| Font | Nunito (via google_fonts) |
| Core philosophy | Performance-first, offline-first, no subscriptions |
| Monetisation | Free tier + one-time $4.99 in-app purchase. No ads, no subscriptions, ever. |
| v1.0 scope | Everything in PDR Section 3 marked "MVP" — nothing else |

**If a session prompt asks you to add a feature not in the MVP list, or suggests a different stack, stop and flag it before proceeding.**

---

## Part 2 — The Three Harness Layers

This harness operates as three reinforcing layers, applied in order. Do not skip a layer.

### Layer 1 — Constraint Harnesses (Prevent failures before they happen)

These are the invariants. They cannot be broken. Every piece of code generated must satisfy all of them.

#### 1.1 Architecture Invariants (NEVER violate)

- **Feature-first folder structure is mandatory.** Every feature lives in `lib/features/<feature_name>/`. No exceptions. Code for `counter` never appears in `projects/`, and vice versa.
- **No cross-feature imports.** Features communicate only through shared Riverpod providers in `lib/core/` or `lib/data/`. Direct imports between feature folders are forbidden.
- **All state is in Riverpod.** No `setState()` except for purely local, transient UI animation state (e.g., a button press ripple). Business logic and app state live in Riverpod StateNotifiers or AsyncNotifiers only.
- **All mutations persist immediately.** Every counter increment, project update, and yarn stash change must write to Hive in the same operation. No buffering. No write-on-close.
- **No hardcoded strings in UI.** All user-visible strings go in a constants file (`lib/core/strings.dart`) for future l10n readiness.
- **No magic numbers in UI.** Spacing, sizing, border radius, and font sizes go in `lib/core/dimensions.dart` and `lib/core/theme.dart`.
- **All data models are immutable.** Every model class (Project, Counter, Yarn) uses `final` fields and a `copyWith()` method. No mutable state on models.

#### 1.2 Code Quality Invariants

- **`flutter analyze` must return zero errors and zero warnings** before any sprint is considered complete. Not "mostly clean" — zero.
- **No `dynamic` types.** Every variable, parameter, and return type must be explicitly typed in Dart.
- **No `// ignore:` directives** unless accompanied by a detailed comment explaining exactly why the suppression is necessary and approved.
- **No `print()` statements** in committed code. Use `debugPrint()` for debug output, and remove it before finalising a sprint.
- **Function length limit: 50 lines.** If a function exceeds 50 lines, it must be refactored into smaller, named helper functions.
- **File length limit: 300 lines.** If a file exceeds 300 lines, extract logical sections into separate files.

#### 1.3 UX Invariants (Non-Negotiable — from PDR Section 8.2)

- The row counter increment button must occupy at least 40% of screen height when in use.
- Every destructive action (delete, reset) requires a two-step confirmation. No single-tap destructive actions.
- No feature requires more than 3 taps from the home screen.
- Minimum body font size: 16sp. Never fix font sizes in pixels — use `sp` units.
- Screen must stay awake when the counter is active (default ON, configurable in Settings).
- Minimum tap target: 48×48dp on all interactive elements.
- Counter state must survive an app kill/reopen cycle. This is the #1 user trust feature.

#### 1.4 Scope Invariants

- **v1.0 = MVP features only.** Do not implement Phase 2 features (PDF viewer, Apple Watch, barcode scanner, Ravelry integration) during v1.0 sprints, even if they seem easy.
- **No network calls in v1.0.** All data is local. No HTTP clients, no Firebase, no REST calls. If you find yourself importing `http`, `dio`, or `firebase_*`, stop — this is out of scope.
- **No built-in pattern library.** PDR explicitly identifies this as a risk (Section 2.2). Do not add one.
- **Stitch dictionary data is static JSON** (`assets/data/stitches.json`), bundled with the app. It is never fetched from a server.

---

### Layer 2 — Feedback Loops (Self-correction without human intervention)

After generating any code, run these checks before declaring a task complete. The feedback loop means you fix violations yourself — do not present code that fails these checks.

#### 2.1 The Sprint Completion Checklist

Every sprint is only "done" when ALL of the following pass:

```
[ ] flutter analyze — zero errors, zero warnings
[ ] flutter test — all tests pass
[ ] dart format lib/ — code is formatted
[ ] Feature works on simulated iOS device
[ ] Feature works on simulated Android device
[ ] Counter state persist verified (if counter was touched): kill app, reopen, value preserved
[ ] Dark mode tested on all new screens
[ ] No hardcoded colour values in new widgets (all from theme)
[ ] No hardcoded string literals in new widgets (all from strings.dart)
[ ] LayoutBuilder used for any screen with a list or complex layout (tablet safety)
```

#### 2.2 The Self-Critique Gate

Before presenting any generated code, ask yourself these questions internally:

1. **Scope check:** Does this code implement only what was asked for in the current sprint? If it adds unrequested features, remove them.
2. **Architecture check:** Does every new file live in the correct feature folder? Do any files cross feature boundaries?
3. **State check:** Is every state mutation written to Hive immediately? Is any state held only in memory where it could be lost?
4. **UX check:** If this involves the counter, is the tap target at least 40% screen height? If it involves a destructive action, is there a two-step confirmation?
5. **Test check:** Has at least one unit test been written for any new business logic (provider/notifier methods)?

If the answer to any of these is "no" or "unsure," fix the issue before presenting the output.

#### 2.3 Dart/Flutter-Specific Feedback Rules

These are known failure modes for LLM-generated Flutter code. Check for all of them:

- **Hive adapter registration:** Every `@HiveType` model must have its adapter registered in `main.dart` before `runApp()`. If you create a new Hive model, verify the adapter is registered.
- **Riverpod ProviderScope:** The entire app must be wrapped in a `ProviderScope` at the root. Never create nested or duplicate `ProviderScope` widgets.
- **go_router:** Never use `Navigator.push()` directly. All navigation goes through the `GoRouter` instance. Use `context.go()` or `context.push()`.
- **Async providers:** All async Riverpod providers must handle loading, error, and data states in the UI (`when(data:, error:, loading:)`). Never leave an unhandled async state.
- **Image picker:** All `image_picker` results must null-check the returned `XFile?` before use.
- **Background timer:** The project timer uses `flutter_foreground_task` with a persistent notification. Never implement the timer using `Timer` alone — it will be killed by the OS.
- **Hive writes on counter increment:** The counter value is written to Hive on *every single increment*, not on app pause or close. This is explicit and intentional.

---

### Layer 3 — Quality Gates (Hard enforcement before sprint sign-off)

These are the gates a sprint must pass before it is considered shippable. They are binary — pass or fail.

| Gate | Command / Method | Must Pass |
|---|---|---|
| Static analysis | `flutter analyze` | Zero issues |
| Tests | `flutter test` | All pass |
| Code format | `dart format lib/ --set-exit-if-changed` | No unformatted files |
| Counter persist | Kill app mid-count, reopen | Count preserved |
| Destructive action guard | Attempt delete/reset without confirmation | Blocked by 2-step confirm |
| Dark mode | All new screens in dark mode | No broken layouts or invisible text |
| Tablet layout | Widen simulator to >600dp | Layout does not break |
| App launch speed | Cold launch on mid-range emulator | Reaches home screen <2 seconds |

---

## Part 3 — The Build Protocol (PEV Loop)

Every sprint follows the **Plan → Execute → Verify** loop. Do not collapse these phases.

### Phase 1: Plan (Before writing any code)

When starting a new sprint:

1. **Re-read the relevant PDR section** for the sprint (e.g., for Sprint 1, re-read Section 3.1 Row Counter).
2. **State the acceptance criteria** for this sprint in plain English before writing any code. What does "done" look like?
3. **Identify the data model(s) involved** — will any new Hive models be needed? Are there existing models to extend?
4. **Identify the Riverpod providers needed** — new StateNotifier? AsyncNotifier? Simple Provider?
5. **Identify the screens/widgets** to be built.
6. **Check for scope creep** — does anything in this plan touch Phase 2 features? If so, remove it.

Output a brief plan before executing. Example format:
```
Sprint [N] Plan:
- Models: [list]
- Providers: [list]
- Screens/Widgets: [list]
- New packages needed (if any): [list]
- Acceptance criteria: [list of testable conditions]
```

### Phase 2: Execute (The build)

Build in this order within every sprint:
1. Data model(s) and Hive adapters first
2. Riverpod provider(s) / StateNotifier(s) next
3. Unit tests for the provider logic
4. UI screens and widgets last
5. Widget tests for key UI interactions

This order ensures the foundation is correct before the UI is built on top of it.

### Phase 3: Verify (Gate check)

Run the full Sprint Completion Checklist from Section 2.1 before declaring the sprint done. Fix any failures and re-run the checklist. Only when all items are checked is the sprint complete.

---

## Part 4 — Sprint Reference Guide

Use the PDR (Section 7.1) for full sprint details. This is a quick reference to keep each sprint on target.

| Sprint | Focus | Key Harness Risks to Watch |
|---|---|---|
| 0 — Setup | Project scaffold, Riverpod + Hive wiring, design system, go_router shell | Get the folder structure right before adding any features. This is the foundation. |
| 1 — Counter | Row counter with persist, haptics, sound, lock mode, quick counter | Hive write on EVERY increment. Lock mode must be real. Counter survive app kill. |
| 2 — Projects | Project CRUD, project detail, link counter to project | Projects are containers — counters and timers are children. Don't let counter logic bleed into project logic. |
| 3 — Dictionary | Static JSON, search, browse, favourites | Data accuracy is critical. Do not hallucinate stitch definitions. Use exact data from PDR Section 13. |
| 4 — Stash | Yarn CRUD, colour swatch, link to project, "enough yarn?" calc | Yarn weight enum must match exactly: `lace / fingering / sport / dk / worsted / aran / bulky / super_bulky` |
| 5 — Tools | Gauge calc, WPI calc, needle chart, yarn weight guide | Unit toggle (cm/inch) must propagate globally via a settings provider — no per-screen unit state. |
| 6 — Timer | Background timer, session history, foreground notification | `flutter_foreground_task` is non-negotiable for background survival. Test on real device, not just emulator. |
| 7 — Settings & Polish | Settings screen, dark mode, accent colour, onboarding, icon, splash | Dark mode is not "invert colours." Every screen must be explicitly tested. |
| 8 — QA & Release | Device testing, bug fixes, store assets | See PDR Section 11 Pre-Launch Checklist in full. |

---

## Part 5 — Session Continuity Rules

AI agents lose context between sessions. These rules preserve coherence across the full 9-week build.

### 5.1 Starting a New Session

At the start of every new OpenCode session, do the following:
1. Re-read this Harness file (`StitchMate_HARNESS.md`) in full.
2. Re-read the relevant PDR section for the current sprint.
3. Check the `SPRINT_LOG.md` file (see Section 5.2) to understand what was completed in the previous session.
4. State the current sprint, current task, and acceptance criteria before writing code.

### 5.2 The Sprint Log (Maintain This File)

Maintain a `SPRINT_LOG.md` file in the project root. Update it at the end of every session. Format:

```markdown
## Sprint [N] — [Sprint Name]

### Session [date]
**Completed:**
- [list what was built and passes all gates]

**In Progress:**
- [what was started but not finished]

**Next Session:**
- [exact next task to pick up]

**Issues / Decisions Made:**
- [any architectural decisions, workarounds, or problems encountered]
```

This file is the memory bridge between sessions. Without it, the agent starts each session blind.

### 5.3 Git Discipline

- **Commit after every passing feature.** Do not accumulate uncommitted changes across a session.
- **One commit per logical unit** (one model, one screen, one provider). Not one commit per file, not one commit per sprint.
- **Commit message format:** `feat(counter): persist counter value to Hive on every increment`
- **Run `flutter analyze` before every commit.** Never commit code with analyzer warnings.
- **If OpenCode generates incorrect Dart syntax that breaks the build:** use `git diff` to identify the bad code and revert before proceeding.

### 5.4 Avoiding Instruction Fade-Out

LLMs in long sessions experience "instruction fade-out" — early constraints are forgotten as context grows. Mitigations:

- **Keep sessions focused on one sprint.** Start a new session for a new sprint.
- **Re-state key constraints at the top of any long prompt.** e.g., "Reminder: all counter writes go to Hive immediately, all navigation uses go_router, all state uses Riverpod."
- **If the agent produces code that violates a harness rule,** do not accept it. Say: "This violates harness rule [X]. Regenerate following the harness constraint."

---

## Part 6 — Tier Boundary Rules

These define what the agent may do autonomously, what requires a check, and what is never permitted. Based on the GitHub three-tier boundary pattern.

### ALWAYS (Do without asking)
- Write to Hive on every counter increment
- Use `flutter analyze` after every code generation
- Use Riverpod for all state (no setState for business logic)
- Use go_router for all navigation
- Handle loading/error/data states in every async Riverpod consumer
- Use LayoutBuilder for responsive layouts
- Follow the feature-first folder structure

### ASK FIRST (Pause and confirm before proceeding)
- Adding any package not listed in PDR Section 4.5
- Changing a data model schema (may require Hive migration)
- Adding any screen not in the PDR Section 5.2 Screen Inventory
- Changing the navigation structure from the 5-tab design
- Modifying the monetisation tier logic (free vs Pro gating)
- Adding any network call (should be zero in v1.0)

### NEVER (Hard stops — always refuse, always flag)
- Implement any Phase 2 feature during v1.0 sprints
- Add subscriptions, ads, or recurring charges of any kind
- Store any user data outside the device (no cloud, no analytics, no tracking)
- Use `dynamic` types in Dart code
- Use `Navigator.push()` — go_router only
- Accept AI-generated stitch dictionary data without cross-referencing against the exact list in PDR Section 13.1
- Suppress `flutter analyze` warnings with `// ignore:` without a written justification
- Write a counter value to Hive only on app close (must be on every increment)

---

## Part 7 — Stitch Dictionary Data Integrity

This is a special rule because data accuracy here directly affects the user's craft work. An incorrect stitch definition could cause a user to make an error in their knitting or crochet project.

**Rule: No AI-generated stitch definitions without verification.**

When generating `assets/data/stitches.json`:
1. Use the exact abbreviation list from PDR Section 13.1 as the source of truth for *which* stitches to include.
2. Descriptions and step-by-step instructions should be accurate and based on established knitting/crochet convention — not invented.
3. After generation, the JSON must be flagged for human verification by an experienced knitter/crocheter before the app ships. Mark this in `SPRINT_LOG.md`.
4. The schema must exactly match PDR Section 13 — every field, every type, every enum value.
5. `usRegion` and `ukRegion` flags must be set correctly. Many abbreviations differ between US and UK conventions (e.g., UK "dc" = US "sc").

---

## Part 8 — Free vs Pro Feature Gating

The monetisation boundary is defined in PDR Section 9.1. This must be implemented as a single, shared `proStatusProvider` — not scattered conditionals throughout the codebase.

```
Free Tier:
- Quick Counter (single counter, no project)
- 1 active project
- Stitch Dictionary (read-only, no favourites)
- Needle & Hook chart

Pro Tier ($4.99 one-time):
- Unlimited projects
- Multiple counters per project
- Yarn stash manager
- Project timer
- Gauge calculator
- Stitch dictionary favourites
- Colour theme picker
- Data export/import
```

**Implementation rule:** All Pro feature gates must check `ref.watch(proStatusProvider)`. Never hardcode `true` for Pro access during development — use a `devProOverride` flag in a debug configuration that is explicitly removed before release builds.

---

## Part 9 — Performance Non-Negotiables

These are drawn from the competitive analysis in PDR Section 2.1 — the #1 user complaint across competing apps is lag. StitchMate wins on performance.

- **Timer runs independently of counter UI.** The timer uses `flutter_foreground_task` on a separate isolate path. It must never cause a single frame drop in the counter screen.
- **Counter increment must feel instantaneous.** The Hive write on increment must be fire-and-forget (`addAsync` without `await` blocking the UI thread) — use `unawaited()` from `dart:async` or write via the StateNotifier without blocking the widget rebuild.
- **Stitch dictionary search must be instant.** The JSON is loaded once into memory at app start and filtered in-memory. No async I/O on search keystrokes.
- **App launch target:** Cold launch to home screen in under 2 seconds on a 3-year-old mid-range device. Hive initialisation is the main risk — initialise only required boxes on startup, defer others.
- **Image loading:** Use `cached_network_image` is not needed (all images are local). Use `Image.file()` with a loading placeholder. Never block the main thread on image I/O.

---

## Part 10 — Accessibility Baseline

Every screen must meet these standards before a sprint is signed off:

- Minimum contrast ratio 4.5:1 for all text (WCAG AA)
- All interactive elements have `Semantics` labels (for screen readers / TalkBack / VoiceOver)
- Font sizes use `sp` units and respond to system accessibility font size settings
- Information is never conveyed by colour alone (always pair colour with an icon or label)
- Minimum tap target: 48×48dp enforced everywhere

---

## Appendix: Recommended Prompt Templates for OpenCode

Use these prompt patterns when starting each sprint task. They encode the harness constraints into the prompt itself.

**Model Setup (Sprint 0 / new data model):**
> "Generate a Hive-backed data model for [ModelName] in `lib/data/models/[model_name].dart`. The model must: use `@HiveType` with `typeId: [N]`, use `final` fields only, include a `copyWith()` method, and exactly match this schema: [paste schema from PDR Section 6]. Also generate the type adapter and show where to register it in `main.dart`."

**Provider / StateNotifier:**
> "Create a Riverpod StateNotifier for [FeatureName] in `lib/features/[feature]/[feature]_provider.dart`. The state class must be immutable with `copyWith()`. All mutations must call Hive to persist immediately — not on app close. Include a unit test file alongside it. Use Riverpod v2 patterns only."

**Screen / UI:**
> "Create the [ScreenName] screen in `lib/features/[feature]/screens/[screen_name].dart`. Use Material 3 widgets. Primary colour `#7B3F6E`, font Nunito. Use `LayoutBuilder` for responsive layout — phones get [X layout], tablets (>600dp) get [Y layout]. Minimum tap targets 48dp. All navigation via `context.go()` from go_router. No hardcoded strings — use `AppStrings` constants."

**Test:**
> "Write a widget test for [WidgetName] that verifies [behaviour]. Use `flutter_test` and a `ProviderContainer` with mocked providers for Riverpod state. Test both the normal state and the error/empty state."

**Stitch Dictionary Data:**
> "Generate 20 entries for `assets/data/stitches.json` for the following knitting abbreviations: [list from PDR 13.1]. Each entry must exactly follow this JSON schema: [paste schema from PDR Section 13]. Descriptions must be accurate to established knitting convention. Flag any US/UK convention differences using the `usRegion`/`ukRegion` fields correctly."

---

*StitchMate Harness v1.0 | April 2026*
*This file is a living document — update it whenever a new class of agent failure is identified.*
*"Whenever the agent makes a mistake, build a harness rule that prevents that mistake from ever happening again." — Mitchell Hashimoto*
