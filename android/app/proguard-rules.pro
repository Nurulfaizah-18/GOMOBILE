# Flutter-specific ProGuard rules

# Keep Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Dart entry points
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.embedding.android.FlutterFragmentActivity { *; }
-keep class * extends io.flutter.embedding.android.FlutterFragment { *; }

# Keep plugin registration
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*

# Prevent R8 from removing DataBinding methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep serialized classes
-keep class com.gomobile.rentalkendaraan.** { *; }

# OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# Dio (Flutter HTTP client)
-keep class dio.** { *; }
