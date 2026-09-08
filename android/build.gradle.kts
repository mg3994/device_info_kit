plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "in.antinna.deviceinfo"
    compileSdk = 36
    ndkVersion = "28.2.13676358" // 16 KB page-size compliance (Play/Android 15+); NDK r28+ aligns LOAD segments to 16 KB

    defaultConfig {
        minSdk = 24
        ndk {
            abiFilters.addAll(setOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64"))
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }

    externalNativeBuild {
        cmake {
            path = file("CMakeLists.txt")
            version = "3.22.1"
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.annotation:annotation:1.7.1")
    val dartNativeProject = rootProject.findProject(":dartnative_android")
    if (dartNativeProject != null) {
        add("compileOnly", dartNativeProject)
    } else {
        add("compileOnly", "io.flutter:flutter_embedding_release:1.0.0-e7119a0e10")
    }
}
