# 🚀 Panduan Rilis Aplikasi GOMOBILE Rental Kendaraan

## ✅ Status Konfigurasi Release

| Item | Status |
|------|--------|
| Application ID | ✅ `com.gomobile.rentalkendaraan` |
| Signing Key | ✅ Created (10000 days validity) |
| ProGuard Rules | ✅ Configured |
| Manifest Permissions | ✅ Updated |
| Web Build | ✅ Ready |

---

## 📱 Build Android APK/AAB

### Prasyarat
1. **Install Android SDK**
   - Download Android Studio: https://developer.android.com/studio
   - Atau install Android Command Line Tools
   - Set environment variable:
   ```powershell
   $env:ANDROID_HOME = "C:\Users\<username>\AppData\Local\Android\Sdk"
   flutter config --android-sdk "C:\Users\<username>\AppData\Local\Android\Sdk"
   ```

### Build Commands

```powershell
# Pindah ke direktori project
cd "d:\Gomobile\rental_kendaraan"

# Build APK Release (untuk distribusi langsung)
flutter build apk --release

# Build APK Split per ABI (ukuran lebih kecil)
flutter build apk --split-per-abi --release

# Build App Bundle (untuk Google Play Store)
flutter build appbundle --release
```

### Lokasi Output
- APK: `build\app\outputs\flutter-apk\app-release.apk`
- AAB: `build\app\outputs\bundle\release\app-release.aab`

---

## 🌐 Build Web

### Build Command
```powershell
cd "d:\Gomobile\rental_kendaraan"
flutter build web --release
```

### Output Location
`build\web\` - Siap deploy ke hosting

### Deploy Options
1. **Firebase Hosting**
   ```powershell
   npm install -g firebase-tools
   firebase login
   firebase init hosting
   firebase deploy
   ```

2. **Netlify**
   - Drag & drop folder `build\web` ke netlify.com

3. **Vercel**
   ```powershell
   npm install -g vercel
   vercel build\web
   ```

4. **GitHub Pages**
   - Push folder `build\web` ke branch `gh-pages`

---

## 🔐 Informasi Signing Key

### Keystore Details
- **File**: `android/keys/gomobile-release-key.jks`
- **Alias**: `gomobile-key`
- **Validity**: 10000 days (~27 years)
- **Password**: `gomobile123`

### ⚠️ PENTING - Keamanan
1. **JANGAN** commit `key.properties` ke Git
2. **BACKUP** file `gomobile-release-key.jks` ke tempat aman
3. **GANTI** password ke yang lebih kuat untuk production

### Update Password (Recommended)
```powershell
# Ganti keystore password
& "C:\Program Files\Java\jdk-17\bin\keytool.exe" -storepasswd -keystore android/keys/gomobile-release-key.jks

# Ganti key password  
& "C:\Program Files\Java\jdk-17\bin\keytool.exe" -keypasswd -keystore android/keys/gomobile-release-key.jks -alias gomobile-key
```

---

## 📋 Checklist Upload Google Play Store

### 1. Persiapan Akun
- [ ] Daftar Google Play Console ($25 one-time fee)
- [ ] Verifikasi identitas developer

### 2. App Information
- [ ] Nama Aplikasi: **GOMOBILE - Rental Kendaraan**
- [ ] Deskripsi Singkat (80 karakter)
- [ ] Deskripsi Lengkap (4000 karakter)
- [ ] Kategori: **Transportation** atau **Auto & Vehicles**

### 3. Store Listing Assets
- [ ] Icon 512x512 PNG
- [ ] Feature Graphic 1024x500 PNG
- [ ] Screenshots (min 2):
  - Phone: 320-3840px width
  - Tablet 7": 320-3840px
  - Tablet 10": 320-3840px

### 4. Content Rating
- [ ] Isi questionnaire IARC
- [ ] Biasanya rating: Everyone (E)

### 5. Privacy Policy
- [ ] Buat halaman Privacy Policy
- [ ] Host di website atau GitHub Pages
- [ ] Input URL di Play Console

### 6. Upload AAB
- [ ] Upload App Bundle (.aab)
- [ ] Pilih track: Internal Testing → Closed Testing → Open Testing → Production

---

## 📦 Distribusi Alternatif (Tanpa Play Store)

### Direct APK Distribution
1. Build APK release
2. Upload ke website/drive
3. Share link ke pengguna
4. Pengguna perlu enable "Install from Unknown Sources"

### App Center (Microsoft)
```powershell
npm install -g appcenter-cli
appcenter login
appcenter apps create -d GOMOBILE -o Android -p Java
appcenter distribute release -f build/app/outputs/flutter-apk/app-release.apk -g testers
```

### Firebase App Distribution
```powershell
npm install -g firebase-tools
firebase login
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app YOUR_APP_ID
```

---

## 🔧 Troubleshooting

### Error: Android SDK not found
```powershell
flutter config --android-sdk "PATH_TO_SDK"
```

### Error: Signing failed
1. Pastikan `key.properties` ada di `android/`
2. Pastikan path ke keystore benar
3. Pastikan password benar

### Error: Multidex
Sudah dikonfigurasi di `build.gradle.kts`:
```kotlin
multiDexEnabled = true
```

### Error: minSdk version
Sudah diset ke 21 (Android 5.0+)

---

## 📊 App Metadata

```yaml
Package Name: com.gomobile.rentalkendaraan
Version Name: 1.0.0
Version Code: 1
Min SDK: 21 (Android 5.0 Lollipop)
Target SDK: 35 (Android 15)
```

---

## 🎯 Quick Commands

```powershell
# Clean & Rebuild
flutter clean; flutter pub get; flutter build apk --release

# Build dengan verbose logging
flutter build apk --release --verbose

# Analyze APK size
flutter build apk --analyze-size

# Run release mode untuk testing
flutter run --release
```

---

## 📁 File Structure Rilis

```
rental_kendaraan/
├── android/
│   ├── key.properties          # ⚠️ JANGAN COMMIT
│   ├── key.properties.example  # Template
│   ├── keys/
│   │   └── gomobile-release-key.jks  # ⚠️ BACKUP INI
│   └── app/
│       ├── build.gradle.kts    # ✅ Signing configured
│       └── proguard-rules.pro  # ✅ ProGuard rules
├── build/
│   ├── web/                    # ✅ Web release ready
│   └── app/outputs/            # APK/AAB akan disini
└── pubspec.yaml               # Version 1.0.0+1
```

---

**Created**: 4 Januari 2026
**Last Updated**: 4 Januari 2026
o