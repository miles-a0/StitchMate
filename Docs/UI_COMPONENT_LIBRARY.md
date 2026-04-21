# 🧶 StitchMate — UI Component Library

**Purpose:**
Defines reusable UI components and design rules to ensure consistency, accessibility, and speed during development.

This prevents:

* Inconsistent layouts
* Hardcoded styling
* UI drift across sessions

---

# 🎨 Design System Foundation

## Colours

* Primary: #7B3F6E
* Use Theme ONLY — never hardcode colours in widgets

## Typography

* Font: Nunito
* Minimum size: 16sp
* Use Theme text styles

## Spacing

* Defined in `dimensions.dart`
* Example:

  * spacingXS = 4
  * spacingSM = 8
  * spacingMD = 16
  * spacingLG = 24
  * spacingXL = 32

---

# 🧱 Core Components

---

## 1. Primary Button

### Usage

Main actions (e.g., Save, Add, Confirm)

### Requirements

* Full width
* Min height: 48dp
* Rounded corners (from theme)
* Uses primary colour

---

## 2. Secondary Button

### Usage

Less prominent actions

### Requirements

* Outlined or tonal
* Same sizing rules as primary

---

## 3. Counter Button (CRITICAL COMPONENT)

### Usage

Row counter increment

### Rules (NON-NEGOTIABLE)

* Must occupy ≥ 40% of screen height
* Full width
* Centered text (large font)
* Instant feedback (haptic/audio)

---

## 4. Card Container

### Usage

Projects, yarn items, dictionary entries

### Requirements

* Elevation (Material 3)
* Rounded corners
* Padding from dimensions system

---

## 5. Section Header

### Usage

Divide content areas

### Requirements

* Bold text style
* Proper vertical spacing
* Accessible contrast

---

## 6. Input Field

### Usage

Forms (project creation, yarn entry)

### Requirements

* Label + hint text
* Validation support
* Uses theme input styles

---

## 7. Toggle / Switch

### Usage

Settings

### Requirements

* Clearly labeled
* Accessible tap target

---

## 8. List Item

### Usage

Reusable row item (dictionary, stash, etc.)

### Requirements

* Leading icon/image
* Title + subtitle
* Optional trailing action

---

# 📱 Layout Patterns

---

## Screen Padding

* Default: spacingMD (16)
* Never edge-to-edge unless intentional (e.g., counter)

---

## Vertical Rhythm

* Maintain consistent spacing scale
* No arbitrary gaps

---

## Tap Targets

* Minimum: 48x48dp
* Enforced everywhere

---

## Responsive Behaviour

### < 600dp (Phone)

* Bottom navigation
* Single column

### ≥ 600dp (Tablet)

* NavigationRail
* Multi-column where appropriate

---

# 🌙 Dark Mode Rules

* Never invert colours blindly
* Use theme-based colours
* Check contrast manually
* Avoid pure black backgrounds

---

# ♿ Accessibility

* Contrast ratio ≥ 4.5:1
* Use Semantics widgets
* Support font scaling
* Do not rely on colour alone

---

# 🚫 Anti-Patterns (Forbidden)

* Hardcoded colours
* Hardcoded font sizes
* Inline styling duplication
* Using Container when a specific widget exists
* Ignoring spacing system

---

# 🧠 Component Usage Rule

Before creating ANY new UI:

Ask:

1. Does a component already exist?
2. Can I extend an existing one?
3. Am I breaking design consistency?

If yes → refactor instead of creating new UI.

---

# 🔁 Future Expansion

Components to add in later sprints:

* Project Card (with progress + timer)
* Yarn Card (with colour swatch)
* Dictionary Entry Tile
* Gauge Calculator Input Block
* Settings Tile

---

# 📌 Final Rule

UI consistency > creativity

If a design decision deviates from this system:
→ It must be justified and documented

---

**End of UI Component Library**
