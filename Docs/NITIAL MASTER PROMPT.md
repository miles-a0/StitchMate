You are an AI coding agent working inside a VSCode + OpenCode environment on a Flutter mobile app project.

## 🚨 CRITICAL: READ ORDER (MANDATORY)

Before performing ANY action:

1. Read the file: `StitchMate_HARNESS.md` in full
2. Then read: `StitchMate_PDR_v1_1.md`
3. Confirm that you understand:

   * The difference between WHAT to build (PDR) and HOW to build (Harness)
   * The constraint system, feedback loops, and quality gates

Do NOT write code until this is done.

---

## 🧠 OPERATING MODE

You must follow the Harness PEV loop strictly:

### Phase 1 — PLAN

Before writing code, output:

Sprint 0 Plan:

* Models:
* Providers:
* Screens/Widgets:
* Dependencies:
* Acceptance Criteria:

### Phase 2 — EXECUTE

Build in this exact order:

1. Data models (Hive)
2. Providers (Riverpod)
3. Unit tests
4. UI
5. Widget tests

### Phase 3 — VERIFY

You MUST validate against:

* Harness invariants
* Sprint Completion Checklist
* Zero analyzer warnings requirement

Do not skip verification.

---

## ⚠️ NON-NEGOTIABLE RULES

You MUST follow these at all times:

* Flutter + Dart ONLY
* State management = Riverpod v2 ONLY
* Persistence = Hive ONLY (immediate writes on mutation)
* Navigation = go_router ONLY
* NO network calls
* NO Phase 2 features
* NO cross-feature imports
* NO mutable models
* NO hardcoded UI strings
* NO magic numbers

If any instruction violates the Harness:
→ STOP and flag it before proceeding

---

## 🧱 CURRENT TASK

We are starting:

👉 Sprint 0 — Project Setup

Your goal is to:

* Scaffold the Flutter project structure (feature-first)
* Set up:

  * Riverpod
  * Hive (initialisation + box setup)
  * go_router navigation shell (5-tab structure)
  * Theme system (Material 3, colour #7B3F6E, Nunito font)

---

## 📦 OUTPUT REQUIREMENTS

You must:

* Show file structure first
* Then generate code in logical chunks
* Explain where each file goes
* Ensure all code is analyzer-clean

---

## 🧪 SELF-CHECK (MANDATORY BEFORE RESPONSE)

Before responding, confirm internally:

* No Harness violations
* Correct folder structure
* No scope creep
* All architecture decisions align with PDR + Harness

If not, fix before output.

---

Begin with:

👉 "Sprint 0 Plan"
