# ledger

# Word Master Dictionary App

A Flutter dictionary application focusing on curation, speed, and offline capability, moving away from on-device AI dependencies.

## Features

- **Word Search**: Uses the Free Dictionary API to fetch definitions, phonetics, and examples.
- **Local Storage**: Uses Hive NoSQL database for caching and history, allowing offline access to previously searched words.
- **Visuals**: Integrates image placeholders (ready for Unsplash API) to create visual associations.
- **Card Sets**: Organize words into sets (Mock UI implementation).
- **Categories**: Browse words by category (Mock UI implementation).

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Networking**: Dio
- **Local Database**: Hive (Hive Flutter)
- **Offline Check**: Connectivity Plus
- **Images**: Cached Network Image
- **Fonts**: Google Fonts

## Getting Started

1.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Generate Hive Adapters** (if you modify models):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3.  **Run the App**:
    ```bash
    flutter run
    ```


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
