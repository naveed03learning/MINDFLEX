# MindFlex Flutter App

A full Flutter conversion of the MindFlex web app — the High-Performance Neural Sanctuary for cognitive training.

---

## Features

| Screen | Description |
|---|---|
| **Splash** | Animated logo with progress bar, auto-navigates after 3s |
| **Login** | Username + password with glass-input fields, biometric icons |
| **Interests** | Pick cognitive domains before entering the app |
| **Home** | Level card, stats (XP, streak, accuracy, quizzes), domain grid |
| **Quiz** | Countdown timer ring, 4-option MCQ, hints (-5 XP), streak tracker, XP rewards, results screen |
| **Progress** | XP/level bar, weekly activity chart, topic performance bars, achievement badges |
| **Profile** | Avatar, stats, interest tags, cognitive data list, logout |

---

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── theme.dart                   # AppColors + AppTheme
├── data/
│   ├── quiz_data.dart           # All 19 quiz questions across 4 topics
│   └── storage_service.dart     # SharedPreferences wrapper (XP, level, streaks, etc.)
├── widgets/
│   └── common_widgets.dart      # GlassCard, NeuralButton, XPChip, StreakChip, AmbientGlow
└── screens/
    ├── splash_screen.dart
    ├── login_screen.dart
    ├── interests_screen.dart
    ├── home_screen.dart         # Contains HomeScreen + bottom nav + _HomeTab
    ├── quiz_screen.dart         # Full quiz + results logic
    ├── progress_screen.dart
    └── profile_screen.dart
```

---

## Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Steps

```bash
# 1. Navigate to the project
cd mindflex_flutter

# 2. Install dependencies
flutter pub get

# 3. Run on a device or emulator
flutter run

# 4. Build APK (Android)
flutter build apk --release

# 5. Build IPA (iOS)
flutter build ipa
```

---

## Color Palette

| Name | Hex | Usage |
|---|---|---|
| Background | `#0E0E11` | App background |
| Primary | `#FF8D8E` | Chips, accents, XP |
| Primary Dim | `#DE2B41` | Buttons gradient, progress bars |
| Tertiary | `#C9A1FF` | Hints, lateral thinking |
| Secondary | `#FE81A3` | Memory topic, icons |
| Surface Container High | `#1F1F23` | Cards, nav bar |

---

## Dependencies

```yaml
shared_preferences: ^2.2.2   # Persistent user data (XP, streaks, etc.)
google_fonts: ^6.1.0          # Space Grotesk (headline) + Manrope (body)
fl_chart: ^0.68.0             # Available for future chart enhancements
animate_do: ^3.3.4            # Available for entrance animations
percent_indicator: ^4.2.3     # Available for circular progress
```

---

## Data Flow

```
Login → setUsername()
Interests → setInterests()
Quiz → saveQuizResult() → addXP, addCorrect, recordActivity, setTopicScores
Home/Progress/Profile → read from StorageService getters
```

---

## Topics & Questions

| Topic | Questions | Max XP |
|---|---|---|
| Riddles | 4 | 45 |
| Memory | 5 | 70 |
| Logic | 5 | 65 |
| Lateral Thinking | 5 | 90 |

---

## Notes

- All user data persists locally via `SharedPreferences` (equivalent to `localStorage` in the web version)
- The quiz topic is selected randomly from the user's saved interests, or can be forced via `QuizScreen(forcedTopic: 'Logic')`
- The bottom navigation only appears on the Home screen (Splash, Login, Quiz are full-screen)
