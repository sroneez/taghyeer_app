# Taghyeer Technologies — Flutter Technical Assignment

## Overview

This project is a Flutter application built as part of the technical assessment for Taghyeer
Technologies. It connects to the [DummyJSON API](https://dummyjson.com/) and covers authentication,
paginated data fetching, local caching, and theme persistence — structured with Clean Architecture
and BLoC state management.

---

## Architecture

**Feature-first Clean Architecture**, split across four layers:

- **Core** — shared utilities, error types, network client, and dependency injection setup
- **Domain** — entities, repository contracts, and use cases
- **Data** — repository implementations, remote data sources, local data sources, and
  model-to-entity mappers
- **Presentation** — BLoC/Cubit classes, pages, and widgets

Each feature (`auth`, `products`, `posts`, `settings`) is self-contained and follows this same
layered structure internally.

---

## Tech Stack & Key Packages

| Concern                   | Solution                         |
|---------------------------|----------------------------------|
| State Management          | `flutter_bloc`                   |
| Dependency Injection      | `get_it`                         |
| Functional Error Handling | `dartz` (Either pattern)         |
| Local Session Cache       | `hive` + `hive_flutter`          |
| Token & Theme Persistence | `shared_preferences`             |
| Networking                | `dio`                            |
| Code Generation           | `build_runner`, `hive_generator` |

---

## Features

### Authentication

- Login via the DummyJSON `/auth/login` endpoint
- JWT token stored in `shared_preferences` on success
- User session object cached in **Hive** for auto-login on next app launch — no re-authentication
  needed if the session is still valid

### Bottom Navigation (3 Tabs)

- **Products**, **Posts**, **Settings**
- Built with `IndexedStack` — switching tabs preserves scroll position and already-loaded pagination
  state

### Infinite Scroll Pagination

- Implemented on both **Products** and **Posts** tabs
- Uses `skip` and `limit` query parameters against the DummyJSON API
- Next page fetches trigger automatically as the user approaches the bottom of the list

### Theme Switching

- Light/Dark mode toggle in the **Settings** tab
- Selected theme is persisted via `shared_preferences` and restored on app start

### Error Handling

- All repository calls return `Either<Failure, T>` using `dartz`
- Network and server errors are caught and mapped to typed `Failure` subclasses before surfacing to
  the BLoC layer

---

## Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Run code generation

> **Required.** The app uses Hive type adapters generated at build time. Skipping this step will
> cause compile errors.

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the app

```bash
flutter run
```

---

## Test Credentials

Use the following DummyJSON account to log in:

```
Username: emilys
Password: emilyspass
```

---

## Project Structure (abbreviated)

```
lib/
├── core/
│   ├── error/               # Failure types & exception mappers
│   ├── network/             # Dio client & interceptors
│   └── utils/
├── di/                      # get_it service locator setup
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── products/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── posts/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/
│       └── presentation/
└── main.dart
```

---

## Notes

- Minimum SDK: Flutter 3.x / Dart 3.x
- Tested on a physical **iOS device**
- No flavor configuration required — single environment pointing to `https://dummyjson.com`