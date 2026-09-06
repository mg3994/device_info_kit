#include <jni.h>
#include <cstdlib>
#include <cstring>

static JavaVM* g_jvm = nullptr;
static jclass g_pluginClass = nullptr;
static jmethodID g_getInfoMethod = nullptr;

extern "C" JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    g_jvm = vm;
    JNIEnv* env = nullptr;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
        return JNI_ERR;
    }

    jclass localClass = env->FindClass("com/dartnative/deviceinfo/DartNativeDeviceInfoPlugin");
    if (!localClass) {
        if (env->ExceptionCheck()) {
            env->ExceptionClear();
        }
        return JNI_ERR;
    }
    g_pluginClass = reinterpret_cast<jclass>(env->NewGlobalRef(localClass));
    g_getInfoMethod = env->GetStaticMethodID(g_pluginClass, "getAndroidInfoJson", "()Ljava/lang/String;");

    if (env->ExceptionCheck()) {
        env->ExceptionClear();
    }

    return JNI_VERSION_1_6;
}

extern "C" __attribute__((visibility("default")))
const char* DNDeviceInfoGetAndroidInfo() {
    if (!g_jvm || !g_pluginClass || !g_getInfoMethod) return nullptr;

    JNIEnv* env = nullptr;
    bool needsDetach = false;
    int envStat = g_jvm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6);
    if (envStat == JNI_EDETACHED) {
        if (g_jvm->AttachCurrentThread(&env, nullptr) != 0) return nullptr;
        needsDetach = true;
    } else if (envStat != JNI_OK) {
        return nullptr;
    }

    auto jJsonStr = reinterpret_cast<jstring>(env->CallStaticObjectMethod(g_pluginClass, g_getInfoMethod));
    if (env->ExceptionCheck()) {
        env->ExceptionClear();
        if (needsDetach) g_jvm->DetachCurrentThread();
        return nullptr;
    }

    if (!jJsonStr) {
        if (needsDetach) g_jvm->DetachCurrentThread();
        return nullptr;
    }

    const char* nativeStr = env->GetStringUTFChars(jJsonStr, nullptr);
    char* resultStr = strdup(nativeStr ? nativeStr : "");
    env->ReleaseStringUTFChars(jJsonStr, nativeStr);
    env->DeleteLocalRef(jJsonStr);

    if (needsDetach) g_jvm->DetachCurrentThread();

    return resultStr;
}

extern "C" __attribute__((visibility("default")))
void DNDeviceInfoFreeString(const char* ptr) {
    if (ptr) {
        free(const_cast<char*>(ptr));
    }
}
