package `in`.antinna.deviceinfo

import android.app.ActivityManager
import android.app.Application
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.provider.Settings
import android.util.DisplayMetrics
import android.view.WindowManager
import androidx.annotation.Keep
import io.flutter.embedding.engine.plugins.FlutterPlugin
import org.json.JSONArray
import org.json.JSONObject
import java.util.Locale
import java.util.TimeZone

/**
 * Native Device Information plugin for DartNative under namespace in.antinna.deviceinfo
 * strictly following official DartNative plugin guidelines and Google Play Store policies.
 */
@Keep
class DartNativeDeviceInfoPlugin : FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setApplicationContext(binding.applicationContext)
        try {
            System.loadLibrary("device_info_kit")
        } catch (e: UnsatisfiedLinkError) {
            android.util.Log.e(
                "DartNativeDeviceInfo",
                "Failed to load libdevice_info_kit.so: ${e.message}"
            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // No-op
    }

    companion object {
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
            val ctx = getContext()

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
                put("previewSdkInt", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) Build.VERSION.PREVIEW_SDK_INT else 0)
                put("securityPatch", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) (Build.VERSION.SECURITY_PATCH ?: "") else "")
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
            json.put("tags", Build.TAGS ?: "")
            json.put("type", Build.TYPE ?: "")

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

            // Play Store compliant ANDROID_ID retrieval
            var androidId = ""
            ctx?.let { c ->
                try {
                    androidId = Settings.Secure.getString(c.contentResolver, Settings.Secure.ANDROID_ID) ?: ""
                } catch (_: Exception) {}
            }
            json.put("androidId", androidId)

            // Memory Info
            var totalMemory = 0L
            var lowMemory = false
            ctx?.let { c ->
                try {
                    val actManager = c.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
                    val memInfo = ActivityManager.MemoryInfo()
                    actManager?.getMemoryInfo(memInfo)
                    totalMemory = memInfo.totalMem
                    lowMemory = memInfo.lowMemory
                } catch (_: Exception) {}
            }
            json.put("totalMemory", totalMemory)
            json.put("isLowMemoryDevice", lowMemory)

            // Storage Info
            var totalStorage = 0L
            var freeStorage = 0L
            try {
                val path = Environment.getDataDirectory()
                val stat = StatFs(path.path)
                totalStorage = stat.totalBytes
                freeStorage = stat.availableBytes
            } catch (_: Exception) {}
            json.put("totalStorage", totalStorage)
            json.put("freeStorage", freeStorage)

            // Display Metrics
            var widthPx = 0
            var heightPx = 0
            var densityDpi = 0
            var xDpi = 0.0f
            var yDpi = 0.0f

            ctx?.let { c ->
                try {
                    val wm = c.getSystemService(Context.WINDOW_SERVICE) as? WindowManager
                    val metrics = DisplayMetrics()
                    @Suppress("DEPRECATION")
                    wm?.defaultDisplay?.getMetrics(metrics)
                    widthPx = metrics.widthPixels
                    heightPx = metrics.heightPixels
                    densityDpi = metrics.densityDpi
                    xDpi = metrics.xdpi
                    yDpi = metrics.ydpi
                } catch (_: Exception) {}
            }

            val displayJson = JSONObject().apply {
                put("widthPixels", widthPx)
                put("heightPixels", heightPx)
                put("densityDpi", densityDpi)
                put("xdpi", xDpi.toDouble())
                put("ydpi", yDpi.toDouble())
            }
            json.put("displayMetrics", displayJson)

            // Locale and Timezone
            val locale = Locale.getDefault()
            val timeZone = TimeZone.getDefault()
            json.put("locale", locale.toString())
            json.put("timeZoneId", timeZone.id)

            // System Features
            val systemFeaturesJson = JSONArray()
            ctx?.let { c ->
                try {
                    val pm = c.packageManager
                    val features = pm.systemAvailableFeatures
                    for (feature in features) {
                        if (feature.name != null) {
                            systemFeaturesJson.put(feature.name)
                        }
                    }
                } catch (_: Exception) {}
            }
            json.put("systemFeatures", systemFeaturesJson)

            return json.toString()
        }
    }
}
