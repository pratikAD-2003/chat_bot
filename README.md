# 🤖 Flutter Chatbot App

A simple and clean **Flutter Chatbot Application** built using **GetX**, **Firebase Firestore**, and **Groq API**.
This project is developed as part of a Flutter Developer assignment.

---

## 🚀 Features

* 💬 Chat with AI
* ⚡ Fast responses using Groq API
* 🔥 Store messages in Firebase Firestore
* 🧠 Markdown support for responses
* 📱 Clean and responsive UI
* 🔄 State management using GetX

---

## 🛠️ Tech Stack

* Flutter
* GetX
* Firebase Core
* Cloud Firestore
* HTTP
* Flutter ScreenUtil
* Intl
* Flutter Markdown

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  get: ^4.7.3
  flutter_screenutil: ^5.9.3
  http: ^1.6.0
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.4
  intl: ^0.20.2
  flutter_markdown: ^0.7.3+1
```

---

## 📥 Getting Started

### Clone the repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

---

### Install dependencies

```bash
flutter pub get
```

---

### Firebase Setup

* Create a Firebase project
* Add Android/iOS app
* Download config files

Place files:

* `android/app/google-services.json`
* `ios/Runner/GoogleService-Info.plist`

Enable **Cloud Firestore**

---

### Add API Key

Open:

```
lib/services/api_service.dart
```

Add your Groq API key:

```dart
const String apiKey = "YOUR_GROQ_API_KEY";
```

---

## 🧠 Approach

```
UI
 ↓
GetX Controller
 ↓
Services (API + Firestore)
```

* UI handles chat interface
* Controller manages state and API calls
* Services handle Groq API & Firestore

---

## 📬 Note

* Add valid API key before running
* Firebase setup is required
* Internet connection is needed

---

## 📌 Apk Link
- https://we.tl/t-YaOG2XRVwM6eJYEd
---

## Screen Recording


https://github.com/user-attachments/assets/a20ec360-407b-425b-9549-198d0ea888ca


---
