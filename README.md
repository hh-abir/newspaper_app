# 📰 NewsPaper App

A modern, high-performance News Reader application built with **Flutter**. This project was developed as a deep dive into **Clean Architecture** principles, focusing on separation of concerns, testability, and maintainability.

---

## 📸 Screenshots

| Home Page | Detail Page | Saved Page |
| :---: | :---: |
| ![Home](docs/Capture1.PNG) | ![Details](docs/Capture2.PNG) |  ![Saved](docs/Capture3.PNG) |

---

## 🎯 Purpose of this Project
The primary goal of this project was to master **Clean Architecture** in Flutter. It is structured into three distinct layers:
1.  **Data Layer:** Handles API calls (Retrofit/Dio) and local storage (Shared Preferences).
2.  **Domain Layer:** Contains Business Logic, Entities, and Use Cases (using Dartz for Functional Error Handling).
3.  **Presentation Layer:** Managed by Riverpod for reactive state management.

## 🚀 Key Features

* **Clean Architecture:** Strict separation of layers for a scalable codebase.
* **Functional Error Handling:** Utilizing the `Either` type from **Dartz** to handle successes and failures gracefully.
* **Type-Safe Networking:** Powered by **Retrofit** and **Dio** for robust API communication.
* **State Management:** Reactive UI updates using **Riverpod**.
* **Dynamic UI:** Implements a beautiful masonry layout using `flutter_staggered_grid_view` and smooth loading states with `shimmer`.
* **Offline Awareness:** Real-time connectivity checks with `internet_connection_checker`.

## 🛠️ Tech Stack

* **State Management:** [Riverpod](https://riverpod.dev/)
* **Networking:** [Dio](https://pub.dev/packages/dio) + [Retrofit](https://pub.dev/packages/retrofit)
* **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
* **Data Parsing:** [JSON Serializable](https://pub.dev/packages/json_serializable)
* **Functional Programming:** [Dartz](https://pub.dev/packages/dartz) (Either, Option)
* **Image Caching:** [CachedNetworkImage](https://pub.dev/packages/cached_network_image)

## 📦 Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/hh-abir/newspaper_app.git](https://github.com/hh-abir/newspaper_app.git)
    cd newspaper_app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation:**
    Since this project uses Retrofit and JSON Serializable, you need to generate the `.g.dart` files:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Launch the app:**
    ```bash
    flutter run
    ```

## 🏗️ Architecture Detail

* **Use Cases:** Each user action is isolated into a specific class.
* **Repositories:** Abstract interfaces in the Domain layer with implementations in the Data layer.
* **Mappers:** Converting Data Models (JSON) into Domain Entities to keep the UI decoupled from the API structure.

---
**Developed by Abir** - *Exploring the depths of Clean Architecture and Functional Programming in Flutter.*
