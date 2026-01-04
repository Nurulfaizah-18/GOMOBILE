# 📸 Assets Setup Guide

Ketika Anda siap menambahkan asset (gambar, icon, font), ikuti panduan ini:

## 📂 Folder Structure

```
rental_kendaraan/
└── assets/
    ├── images/        # Gambar kendaraan, background, dll
    │   ├── car_1.png
    │   ├── car_2.png
    │   └── ...
    ├── icons/         # Icon custom (jika perlu)
    │   ├── menu.png
    │   └── ...
    └── fonts/         # Font files
        ├── Poppins-Regular.ttf
        ├── Poppins-Bold.ttf
        └── Poppins-SemiBold.ttf
```

## ✅ Langkah-Langkah

### 1. Buat Folder Assets
```bash
# Buat folder di project root
mkdir assets
mkdir assets/images
mkdir assets/icons
mkdir assets/fonts
```

### 2. Tambahkan File
- Copy file gambar ke `assets/images/`
- Copy file icon ke `assets/icons/`
- Copy font files ke `assets/fonts/`

### 3. Update pubspec.yaml
Buka file `pubspec.yaml` dan uncomment bagian assets:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
```

### 4. Run Flutter
```bash
flutter pub get
flutter run
```

## 🎨 Contoh Penggunaan Asset

### Gunakan Font Custom
```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
)
```

### Gunakan Image
```dart
Image.asset('assets/images/car_1.png')
```

### Gunakan Icon
```dart
Image.asset('assets/icons/menu.png', width: 24, height: 24)
```

## 📝 Recommended Assets

Untuk aplikasi ini, Anda bisa menggunakan:

### Gambar Kendaraan
- Untuk demo, gunakan placeholder dari internet atau
- Download dari situs free stock photo:
  - Unsplash.com
  - Pexels.com
  - Pixabay.com

### Font Poppins
Download dari: https://fonts.google.com/specimen/Poppins

### Icons
- Material Icons (built-in Flutter)
- Custom icons dari: https://www.flaticon.com

## ⚡ Quick Start (Tanpa Asset)

Saat ini aplikasi berjalan dengan:
- ✅ Mock data (data dummy)
- ✅ Material Icons (built-in)
- ✅ Default font

Jadi aplikasi sudah bisa langsung dijalankan sekarang!

Ketika siap menambah asset, follow guide ini.
