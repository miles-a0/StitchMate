# 🧶 StitchMate — Build Checklist

This checklist is used continuously throughout development to ensure code quality, architectural integrity, and alignment with the Harness.

---

## 🔁 Per-Feature Checklist

Before marking ANY feature complete:

### Code Quality

* [ ] `flutter analyze` returns ZERO errors and ZERO warnings
* [ ] No `dynamic` types used
* [ ] No `print()` statements
* [ ] No `// ignore:` without justification
* [ ] Functions < 50 lines
* [ ] Files < 300 lines

---

### Architecture Compliance

* [ ] Files placed in correct `lib/features/<feature>/` structure
* [ ] No cross-feature imports
* [ ] State handled ONLY via Riverpod
* [ ] All mutations persist immediately to Hive
* [ ] Models are immutable with `copyWith()`

---

### UI / UX Compliance

* [ ] No hardcoded strings (use `strings.dart`)
* [ ] No hardcoded dimensions (use theme/dimensions)
* [ ] Tap targets ≥ 48dp
* [ ] Counter button ≥ 40% screen height (if applicable)
* [ ] Max 3 taps from home to feature

---

### Responsiveness

* [ ] LayoutBuilder used where needed
* [ ] Works on phone (<600dp)
* [ ] Works on tablet (>600dp)

---

### Dark Mode

* [ ] Screen tested in dark mode
* [ ] No contrast issues
* [ ] No invisible elements

---

### Persistence & State

* [ ] Data survives app kill/reopen
* [ ] Hive writes happen on EVERY mutation
* [ ] No in-memory-only critical state

---

### Testing

* [ ] Unit test exists for business logic
* [ ] Widget test exists for key UI
* [ ] All tests pass

---

## 🚀 Pre-Commit Checklist

Before EVERY commit:

* [ ] `flutter analyze`
* [ ] `flutter test`
* [ ] `dart format lib/`
* [ ] Feature fully working
* [ ] No debug code left

---

## 🧪 Critical Feature Checks

### Counter

* [ ] Increment persists instantly
* [ ] App kill → state restored
* [ ] Lock mode prevents changes

### Timer

* [ ] Runs in background
* [ ] Survives screen lock
* [ ] No UI lag

---

## 🚫 Never Allowed

* [ ] Adding Phase 2 features
* [ ] Adding network calls
* [ ] Using Navigator.push
* [ ] Using mutable models
* [ ] Skipping Hive persistence

---

## 🧠 Rule of Thumb

If something feels “quick and easy” but bypasses the Harness…

→ It is wrong. Fix it properly.
