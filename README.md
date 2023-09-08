# Flutter Biometric Auth

## Description

This project is a Flutter application that demonstrates the use of biometric authentication using the `local_auth` package. It opens with a first screen containing a centered button. When the user clicks the button, it triggers the biometric sensor. If the biometric authentication is confirmed, it navigates to the second screen. If not, a toast message saying "Nda bisa" (which means "Cannot" in Indonesian) will be displayed.

## Features

- Biometric authentication using the `local_auth` package.
- Simple and intuitive user interface with a centered button.
- Feedback message ("Nda bisa") for unsuccessful biometric authentication.

## Screenshots

Include screenshots or gifs of your application here.

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android or iOS device/emulator for testing

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/yourproject.git
```

2. Install the depedencies:
```
flutter pub get
```

### Packages and Libraries Used:
1. [local_auth 2.1.7](https://pub.dev/packages/local_auth)
2. [fluttertoast 8.2.2](https://pub.dev/packages/fluttertoast)

