# ProGuard rules for Doctor Throat app

# Keep Android framework classes
-keep public class android.** { public *; }
-keep public class androidx.** { public *; }
-keep public class com.google.android.** { public *; }

# Keep Kotlin metadata
-keepattributes *Annotation*
-keepattributes InnerClasses,EnclosingMethod,Signature,SourceFile,LineNumberTable

# Keep app entry point
-keep public class com.doctorthroat.app.MainActivity {
    public <init>(...);
}

# Keep Camera/CameraX classes
-keep public class androidx.camera.** { public *; }

# Keep Compose runtime
-keep public class androidx.compose.** { *; }

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimization
-optimizationpasses 5
-verbose
