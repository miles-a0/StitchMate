# 🧶 StitchMate — Sprint 0 Prompt Pack

**Purpose:**
This file contains pre-engineered prompts for Sprint 0 (Project Setup), designed to enforce the Harness constraints while accelerating development.

**Usage Rule:**
At the start of EVERY prompt:

* Paste the relevant section
* Ensure the agent has already read:

  * `StitchMate_HARNESS.md`
  * `StitchMate_PDR_v1_1.md`

---

# 🚀 Sprint 0 Scope

* Project scaffold
* Folder structure (feature-first)
* Riverpod setup
* Hive initialisation
* go_router navigation shell
* Theme system (Material 3)

---

# 🧱 0.1 Project Structure Setup

## Prompt

You are working under the StitchMate Harness constraints.

Task: Generate the full Flutter project folder structure following the feature-first architecture defined in the PDR.

Requirements:

* All features must live under `lib/features/`
* Include:

  * core/
  * data/
  * features/
* Include placeholder files where appropriate

Output:

* Full folder tree
* Brief explanation of each top-level directory

Constraints:

* No cross-feature imports
* Must align with Harness architecture invariants

---

# 🧠 0.2 Core Layer Setup

## Prompt

Create the core system files in `lib/core/`.

Required files:

* theme.dart
* dimensions.dart
* strings.dart

Requirements:

* Material 3 theme
* Primary colour: #7B3F6E
* Font: Nunito (Google Fonts)
* No hardcoded values in UI later

Include:

* Text styles
* Spacing constants
* Radius constants
* Global string placeholders

Ensure:

* Clean, scalable structure
* No unused code
* Fully typed

---

# 🧬 0.3 Hive Initialisation

## Prompt

Set up Hive for the StitchMate project.

Requirements:

* Initialise Hive in `main.dart`
* Set up app document directory using path_provider
* Prepare for multiple boxes (do NOT open all at startup unnecessarily)
* Include placeholder for adapter registration

Explain:

* Where adapters will be registered
* How future models will connect

Constraints:

* No blocking UI thread
* No premature box loading

---

# 🔄 0.4 Riverpod Setup

## Prompt

Set up Riverpod v2 as the global state management system.

Requirements:

* Wrap app in ProviderScope
* Create base provider structure
* Include example provider (simple test provider)

Ensure:

* No nested ProviderScopes
* No legacy Provider usage
* Fully typed

---

# 🧭 0.5 Navigation Shell (go_router)

## Prompt

Create the go_router navigation system.

Requirements:

* 5 main tabs:

  * Home
  * Projects
  * Dictionary
  * Stash
  * Tools

* Use:

  * BottomNavigationBar (phones)
  * NavigationRail (tablets via LayoutBuilder)

Output:

* Router configuration
* Shell route setup
* Example navigation usage

Constraints:

* Use go_router ONLY
* No Navigator.push
* Must support future deep linking

---

# 🎨 0.6 App Scaffold

## Prompt

Create the base app scaffold in `main.dart`.

Requirements:

* Integrate:

  * Theme system
  * Router
  * Riverpod
  * Hive init

* Include:

  * MaterialApp.router
  * Dark/light theme support

Ensure:

* Clean separation of concerns
* No logic inside UI layer

---

# 📱 0.7 Responsive Layout Base

## Prompt

Create a reusable responsive layout wrapper.

Requirements:

* Use LayoutBuilder
* Breakpoint at 600dp
* Return:

  * Mobile layout
  * Tablet layout

This will be reused across screens.

---

# 🧪 0.8 Initial Test Setup

## Prompt

Set up initial testing infrastructure.

Requirements:

* Add example unit test
* Add example widget test
* Show how to test Riverpod providers

Ensure:

* Tests compile and pass
* Structure ready for expansion

---

# ✅ Sprint 0 Completion Prompt

## Prompt

Validate Sprint 0 against the StitchMate Harness.

Checklist:

* flutter analyze (zero warnings/errors)
* Riverpod correctly set up
* Hive initialised correctly
* Navigation shell working
* Theme system applied
* Folder structure correct

Output:

* PASS / FAIL per item
* Fix any failures before finalising

---

# 🧠 Usage Tip

Do NOT run all prompts at once.

Correct sequence:

1. Structure
2. Core
3. Hive
4. Riverpod
5. Router
6. Scaffold
7. Responsive
8. Tests
9. Validation

---

**End of Sprint 0 Prompt Pack**
