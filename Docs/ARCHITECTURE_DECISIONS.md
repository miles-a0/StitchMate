# 🧶 StitchMate — Architecture Decisions Log

This document records all significant architectural decisions made during development.

Purpose:

* Prevent re-deciding the same problems
* Maintain consistency across AI sessions
* Provide context for future refactoring

---

## 📌 Decision Format

Each entry must follow:

### [DATE] — [Decision Title]

**Context:**
What problem were we solving?

**Decision:**
What was chosen?

**Rationale:**
Why this approach over alternatives?

**Alternatives Considered:**

* Option A
* Option B

**Impact:**
What areas of the app this affects

---

## 🧱 Decisions

---

### [Initial] — State Management Choice

**Decision:**
Use Riverpod v2 exclusively

**Rationale:**

* Testable
* Scalable
* Aligns with Harness constraints

**Impact:**
All features must use providers; no setState for logic

---

### [Initial] — Local Persistence

**Decision:**
Use Hive for all structured data

**Rationale:**

* Fast
* Pure Dart
* Offline-first

**Impact:**
All models require Hive adapters and immediate writes

---

### [Initial] — Navigation System

**Decision:**
Use go_router only

**Rationale:**

* Declarative routing
* Deep link ready
* Enforced by Harness

**Impact:**
Navigator.push is forbidden

---

### [Initial] — Feature Architecture

**Decision:**
Feature-first folder structure

**Rationale:**

* Prevents coupling
* Easier AI generation
* Scales cleanly

**Impact:**
Strict separation of concerns required

---

## ⚠️ Rules

* Every non-trivial decision MUST be logged here
* If changing an existing decision → update entry, don’t overwrite silently
* AI must check this file before proposing architectural changes
