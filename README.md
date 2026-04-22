# TimberGuard - Interactive Premium Estimator

> A Flutter Web lead-generation tool for **Shield & Sapling**, a forestry and logging equipment insurance brokerage.
 
---
 
## Overview

TimberGuard gives prospective clients an instant, real-time monthly premium estimate for heavy forestry equipment (feller bunchers, forwarders, harvesters, skidders, loaders, and processors). Inputs update the estimate without any form submission.

---

## Features

| Feature | Detail |
|---------|--------|
| Equipment type selector | Dropdown covering 6 equipment categories |
| Value slider | $50k - $1M range, $5k steps |
| Age input | Validated numeric field; triggers agent CTA for >20 yr equipment |
| Fire suppression toggle | Applies a 15% monthly discount when enabled |
| Live calculation | Premium recalculates on every input change |
| Responsive layout | Two-column desktop / single-column mobile |
| Reset button | Returns all inputs to default values in one click |
| Forestry theme | Forest Green, Slate Greym, Earth Brown palette, Playfair Display + Inter fonts |

---

## Calculation Formula

```
Annual Premium = Equipment Value x 2% x (1 - 0.15) <- if fire suppression is enabled

Monthly Premium = Annual Premium / 12
```

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.3.0
- Chrome browser (for local web development)
- Android Studio (Hedgehog or later) with Flutter plugin

### Run locally

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Chrome
flutter run -d chrome
```

### Build for production

```bash
flutter build web --release --base-href "/"
```

Output is placed in `build/web`.

---