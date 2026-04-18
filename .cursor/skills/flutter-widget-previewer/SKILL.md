---
name: flutter-widget-previewer
description: >-
  Use Flutter Widget Previewer (@Preview, flutter widget-preview start) to
  render widgets in Chrome or the IDE preview panel, respect web-only limits, and
  structure preview code in packages. Use when the user adds or edits widget
  previews, asks about Widget Preview / widget previewer, or implements UI that
  should be visually verified outside a full app run.
---

# Flutter Widget Previewer

## Purpose

Enable **live widget previews** (Chrome or IDE “Flutter Widget Preview” tab) separate from a full app, using the **`@Preview`** annotation and the **`flutter widget-preview`** CLI.

Official reference: [Flutter Widget Previewer](https://docs.flutter.dev/tools/widget-previewer)

## When this skill applies

- Adding **`@Preview`** to functions or widgets.
- Running **`flutter widget-preview start`** from a project root.
- Designing **package** UI so previews stay **web-safe** (no `dart:io` / `dart:ffi` in the previewed tree).
- Customizing previews (**`size`**, **`brightness`**, **`theme`**, **`wrapper`**, **`MultiPreview`**).

## Prerequisites

- Flutter **3.38+** (IDE integration); docs target recent stable (see site footer on the doc page).
- Import: `package:flutter/widget_previews.dart` and `package:flutter/material.dart` (or Cupertino) as needed.

## Start the previewer

From the **Flutter package or app root**:

```bash
flutter widget-preview start
```

Launches a local server and opens a Widget Preview environment in **Chrome**; updates follow project changes.

**IDE**: Android Studio / IntelliJ / VS Code can show **“Flutter Widget Preview”** in the sidebar (may auto-start on launch per doc).

## Define a preview

`@Preview` applies to:

- **Top-level functions** returning `Widget` or `WidgetBuilder`.
- **Static methods** on a class returning `Widget` or `WidgetBuilder`.
- **Public** `Widget` constructors or factories with **no required arguments**.

Minimal example:

```dart
import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';

@Preview(name: 'My Sample Text')
Widget mySampleText() {
  return const Text('Hello, World!');
}
```

### Grouping and layout

- **`name`**: Label in the preview list.
- **`group`**: Groups related previews.
- **`size`**: `Size(width, height)` — prefer explicit constraints; unconstrained widgets may get **~half** previewer size (behavior may change).

### Light / dark

```dart
@Preview(name: 'Light', brightness: Brightness.light)
@Preview(name: 'Dark', brightness: Brightness.dark)
Widget myButtonPreview() => const ButtonShowcase();
```

Or use **`MultiPreview`** to reduce duplication (see doc: custom `MultiPreview` subclasses).

### Theming and wrappers

- **`theme`**: `PreviewThemeData` via `Preview` (or custom annotation extending `Preview`).
- **`wrapper`**: Wrap the preview to inject `InheritedWidget`s or `MaterialApp`-like shells.
- **`textScaleFactor`**, **`localizations`**: Match accessibility / locale scenarios.

## Restrictions (web / previewer)

Previews run in an environment built for **Flutter Web** constraints:

| Topic | Rule |
|--------|------|
| **dart:io** | Avoid in previewed code paths; if transitively imported, APIs **throw** when called. |
| **dart:ffi** | Widgets depending on FFI may **fail to load** entirely. |
| **Plugins** | Native plugins **not** supported; web plugins **may** work in Chrome but are not guaranteed in all environments. |
| **Preview annotation callbacks** | **`wrapper` / similar parameters** must use **public** names and be compatible with the previewer’s codegen (follow current doc). |
| **Assets** | Use **package** paths for `dart:ui` `fromAsset`-style loading, e.g. `packages/<package>/<asset>`. |

Structure **conditional imports** if platform code must coexist with previews ([Dart conditional imports](https://dart.dev/tools/pub/create-packages#conditionally-importing-and-exporting)).

## Packages (`session_insight_kit`)

- Keep **`@Preview`** entry points under `lib/` (e.g. `lib/src/presentation/previews/…`) so the previewer discovers them.
- **Do not** re-export preview-only files from the public barrel unless product requirements explicitly need it; previews can remain **library-private** imports.
- Prefer **thin** preview functions that wrap public widgets with **fake / stub** data—**no** real capture, speech, or filesystem calls.

## Agent workflow

1. Implement or change a **StatelessWidget** / **StatefulWidget** with **pure Flutter** dependencies on the preview path.
2. Add a **top-level** `Widget …()` (or eligible constructor) with `@Preview(name: …, group: …)` and optional **`size`** / **`brightness`**.
3. Run **`flutter widget-preview start`** (or use the IDE preview tab) and confirm light/dark if relevant.
4. If a preview **fails to load**, check for **`dart:io`**, **FFI**, or **native plugins** in the transitive import graph and split **stub** UI.

## Related

- API: [`Preview` class](https://api.flutter.dev/flutter/widget_previews/Preview-class.html)
- [`MultiPreview`](https://api.flutter.dev/flutter/widget_previews/MultiPreview-class.html) for shared preview lists
