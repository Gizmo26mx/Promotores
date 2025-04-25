plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    //id("com.google.gms.google-services") // Añade este plugin para Firebase
}

android {
    namespace = "com.example.promotores"
    compileSdk = flutter.compileSdkVersion.toInteger() // Asegúrate de convertirlo a Integer
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.promotores"
        minSdk = flutter.minSdkVersion.toInteger() // Convertir a Integer
        targetSdk = flutter.targetSdkVersion.toInteger() // Convertir a Integer
        versionCode = flutter.versionCode.toInteger() // Convertir a Integer
        versionName = flutter.versionName
        multiDexEnabled = true // Recomendado para Firebase
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // Opcional: configuración para reducción de código
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }

    buildscript {
        dependencies {
           // classpath("com.google.gms:google-services:4.3.15")
            // ... otras dependencias
        }
    }

}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.22") // Versión compatible
    implementation(platform("com.google.firebase:firebase-bom:32.3.1")) // Firebase BoM
    implementation("com.google.firebase:firebase-analytics-ktx") // Analytics
    implementation("com.google.firebase:firebase-firestore-ktx") // Firestore
    implementation("com.google.firebase:firebase-auth-ktx") // Autenticación
    implementation("com.google.firebase:firebase-storage-ktx") // Storage (si necesitas fotos)
    implementation("androidx.multidex:multidex:2.0.1") // Necesario para minSdk < 21
}