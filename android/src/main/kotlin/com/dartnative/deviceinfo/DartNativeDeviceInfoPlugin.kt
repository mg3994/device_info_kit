package com.dartnative.deviceinfo

import android.app.Application
import android.content.Context
import android.os.Build
import android.provider.Settings
import androidx.annotation.Keep
import org.json.JSONArray
import org.json.JSONObject

@Keep
class DartNativeDeviceInfoPlugin {
    companion object {
        init {
            try {
                System.loadLibrary("device_info_kit")
            } catch (_: UnsatisfiedLinkError) {}
        }

        @JvmStatic
        private var appContext: Context? = null

        @JvmStatic
        fun setApplicationContext(context: Context) {
            appContext = context.applicationContext
        }

        private fun getContext(): Context? {
            if (appContext != null) return appContext
            return try {
                val activityThreadClass = Class.forName("android.app.ActivityThread")
                val currentApplicationMethod = activityThreadClass.getDeclaredMethod("currentApplication")
                val app = currentApplicationMethod.invoke(null) as? Application
                appContext = app?.applicationContext
                appContext
            } catch (_: Exception) {
                null
            }
        }

        @JvmStatic
        fun getAndroidInfoJson(): String {
            val json = JSONObject()

            val baseOS = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Build.VERSION.BASE_OS ?: ""
            } else {
                ""
            }

            val versionJson = JSONObject().apply {
                put("baseOS", baseOS)
                put("sdkInt", Build.VERSION.SDK_INT)
                put("release", Build.VERSION.RELEASE ?: "")
                put("incremental", Build.VERSION.INCREMENTAL ?: "")
                put("codename", Build.VERSION.CODENAME ?: "")
            }

            json.put("version", versionJson)
            json.put("board", Build.BOARD ?: "")
            json.put("bootloader", Build.BOOTLOADER ?: "")
            json.put("brand", Build.BRAND ?: "")
            json.put("device", Build.DEVICE ?: "")
            json.put("display", Build.DISPLAY ?: "")
            json.put("fingerprint", Build.FINGERPRINT ?: "")
            json.put("hardware", Build.HARDWARE ?: "")
            json.put("host", Build.HOST ?: "")
            json.put("id", Build.ID ?: "")
            json.put("manufacturer", Build.MANUFACTURER ?: "")
            json.put("model", Build.MODEL ?: "")
            json.put("product", Build.PRODUCT ?: "")

            val abisJson = JSONArray()
            for (abi in Build.SUPPORTED_ABIS) {
                abisJson.put(abi)
            }
            json.put("supportedAbis", abisJson)

            val isPhysicalDevice = !(Build.FINGERPRINT.startsWith("generic")
                    || Build.FINGERPRINT.startsWith("unknown")
                    || Build.MODEL.contains("google_sdk")
                    || Build.MODEL.contains("Emulator")
                    || Build.MODEL.contains("Android SDK built for x86")
                    || Build.MANUFACTURER.contains("Genymotion")
                    || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                    || "google_sdk" == Build.PRODUCT)

            json.put("isPhysicalDevice", isPhysicalDevice)

            var androidId = ""
            getContext()?.let { ctx ->
                try {
                    androidId = Settings.Secure.getString(ctx.contentResolver, Settings.Secure.ANDROID_ID) ?: ""
                } catch (_: Exception) {}
            }
            json.put("androidId", androidId)

            return json.toString()
        }
    }
}
