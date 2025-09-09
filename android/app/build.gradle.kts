plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Apply Google Services here (version is set in project-level build.gradle.kts)
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.yusuf_flutter_test_p1"
    compileSdk = flutter.compileSdkVersion

    // Plugins (e.g., url_launcher_android, video_player_android, etc.) require NDK r27
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.yusuf_flutter_test_p1"

        // Firebase core requires 23+
        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Use Java 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildTypes {
        release {
            // Debug signing so `flutter run --release` works for now
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

