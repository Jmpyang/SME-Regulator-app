# Flutter ProGuard rules
# Add project specific ProGuard rules here.

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Flutter Engine
-keep class io.flutter.embedding.** { *; }

# Keep Flutter's native library
-keepclassmembers class * {
    native <methods>;
}

# Keep model classes
-keep class com.example.sme_regulator_flutter.models.** { *; }

# Keep data classes
-keep class com.example.sme_regulator_flutter.data.** { *; }

# Keep network classes
-keep class com.example.sme_regulator_flutter.network.** { *; }

# Keep Gson
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*
-keepattributes Signature
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# Keep Retrofit
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep Dio
-dontwarn dio.**
-keep class dio.** { *; }

# Keep Provider
-keep class androidx.lifecycle.** { *; }

# Keep other Android classes
-keep class androidx.** { *; }
-keep class com.google.android.material.** { *; }
