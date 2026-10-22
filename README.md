# Daily Azkar (እስላማዊ አዝካር)

A Flutter app for morning, evening and daily adhkar, the 99 names of Allah, and duas.
Arabic text with Amharic meanings, in the dark green and gold style of the original mockup.

## What's in the app

| Tab | Contents |
|---|---|
| መነሻ (Home) | Verse of the day, morning and evening shortcuts, 99 names, duas, tasbih counter |
| አዝካር | Six categories: morning, after prayer (noon), evening, home, travel, other |
| ጸሎት | 99 names entry point and nine duas from the Qur'an and Sunnah |
| ተወዳጅ | Favourites (saved items from any section) |
| ቅንብር | Name for the greeting, text size, reset counters, app info |

Each dhikr has a counter that counts up to its required repeat count (for example 33 or 100).
Progress, favourites, the tasbih counter and settings are saved on the device.
Search is available from the Azkar tab, and the 99 names can be searched by name, number or meaning.

## Setup

This folder has the Dart code and assets only. It does not include the Android and iOS platform folders.

```bash
cd daily_azkar
flutter create --project-name daily_azkar --platforms=android,ios .   # adds android/ and ios/
flutter pub get
flutter run                  # on a connected phone or emulator
flutter test                 # checks the content data
flutter build apk --release  # release APK at build/app/outputs/flutter-apk/
```

`flutter create .` leaves existing files such as `lib/` and `pubspec.yaml` alone.
Set the app name and package id in `android/app/build.gradle` and the Android manifest.

## Content files

All text is in `assets/data/`:

- `azkar.json`: categories, with each item's `id`, `title`, `ar` (Arabic), `am` (Amharic), `repeat` and `source`.
- `names.json`: the 99 names, with `n`, `ar`, `tr` (transliteration) and `am` (Amharic meaning).
- `duas.json`: duas in the same format as `azkar.json` items.

To add or change text, edit these files. No code changes are needed.

## Before publishing: please review

- **Arabic text**: the morning and evening texts are carried over from the original HTML file. The other sections were written from the standard collections (Hisn al-Muslim style). Please check every Arabic text against a trusted printed source before release.
- **Amharic meanings**: the translations for new sections, the 99 names and the duas were written for this version. Please have an Amharic-speaking scholar or native reader check them.
- **Sources**: the `source` field is a reference only (for example ቡኻሪ = Bukhari, ሙስሊም = Muslim). Please confirm each one.
- **Font**: `assets/fonts/Quran.ttf` came from the original HTML file. Check its licence before publishing.
- **Audio**: not included in this version.

## Notes on the port

- The original HTML used a Ethiopic-script transliteration field. Many of its entries were incomplete or inconsistent, so it was removed. The Arabic and Amharic are kept.
- Background images are the same as in the original.
