# Kokology Game - Modernized for HarmonyOS Wearable

**Kokology Game** is a HarmonyOS-based wearable application that explores personality through psychological questions and imagination-based choices. This fork significantly upgrades the original project with modern ArkUI standards and deep wearable hardware integration.

## Major Enhancements

### 1. ⌚ Wearable-First UI Design
- **Redesigned Layouts:** Replaced manual positioning with a clean, list-based `HomePage` that adapts perfectly to circular smartwatch screens.
- **Improved Glanceability:** Increased font sizes (`14fp` - `18fp`) and touch targets (`44vp` button height) for better accessibility and readability.
- **Resource Modernization:** Fully migrated hardcoded strings and colors to HarmonyOS resource files (`string.json`, `color.json`, `float.json`).

### 2. 📳 Tactile Choice Engine (Haptics)
- Integrated `@kit.SensorServiceKit` (Vibrator) to provide physical confirmation for every choice.
- **Short clicks** for navigation and answer selection.
- **Success vibration** upon completing a quiz category.

### 3. 👑 Digital Crown Navigation
- Support for physical crown scrolling in `HomePage`, `HistoryPage`, and `ResultPage`.
- Components are properly focused to ensure a seamless "touchless" experience.

### 4. 🗄️ Personality Archive (Persistent Storage)
- Added a **History** feature using `@kit.ArkData` (Preferences).
- Users can now revisit their past psychological insights and track their journey over time.
- Integrated a new `HistoryPage` to view and manage past results.

## Technology Stack

- **Languages**: ArkTS, ArkUI
- **Frameworks**: HarmonyOS SDK 5.1.1
- **Kits Integrated**:
    - `@kit.ArkUI`: Modern declarative UI and navigation.
    - `@kit.SensorServiceKit`: Haptics (Vibrator).
    - `@kit.ArkData`: Persistent storage (Preferences).

## Directory Structure

```
KokologyGame
|--- entry/src/main/ets/
| |--- model/          # Data models
| |--- viewmodel/      # MVVM Logic
| |--- pages/          # UI Pages (HomePage, GamePage, ResultPage, HistoryPage)
| |--- util/           # Utilities (Haptics, Storage)
| |--- resources/      # Centralized strings, colors, and dimensions
```

## License

**Kokology Game** is distributed under the terms of the MIT License.
See the [license](/LICENSE) for more information.
