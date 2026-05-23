plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    // 🔥 Firebase (Google Services)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.pi_catalogo_peliculas"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.pi_catalogo_peliculas"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Firebase BoM (maneja versiones automáticas)
    implementation(platform("com.google.firebase:firebase-bom:34.13.0"))

    // 🔥 Firebase base (Firestore lo usaremos después)
    implementation("com.google.firebase:firebase-analytics")
}