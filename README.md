# storiez

Storiez is a story sharing application where users can share image stories with friends and embed encrypted secret messages securely for the target recepients.

### Visuals 😋

<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/splash.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/signup.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/login.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/home.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/drawer.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/view-secret.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/choose-image.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/add-caption.png" width="400" height="800">
<img src="https://raw.githubusercontent.com/Crazelu/storiez/main/assets/screenshots/add-secret-message.png" width="400" height="800">

### Getting started

## Prerequisites 🍳

You'll need

- Flutter and Dart installed
- Cloudinary setup for image uploads

## Building the app 🏗️

To build the app, replace the placeholders and run:
```bash
flutter run --release --dart-define="CLOUDINARY_API_KEY={your_key}" --dart-define="CLOUDINARY_API_SECRET={your_secret}" --dart-define="CLOUDINARY_CLOUD_NAME={your_cloud_name}"
```
OR (debug 🐛)
```bash
flutter run --dart-define="CLOUDINARY_API_KEY={your_key}" --dart-define="CLOUDINARY_API_SECRET={your_secret}" --dart-define="CLOUDINARY_CLOUD_NAME={your_cloud_name}" -t lib/main_dev.dart
```

