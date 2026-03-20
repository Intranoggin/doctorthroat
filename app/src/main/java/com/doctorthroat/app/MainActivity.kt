package com.doctorthroat.app

import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.camera.core.Camera
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner

class MainActivity : ComponentActivity() {
    private var cameraRef: Camera? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            DoctorThroatTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ThroatCheckScreen(this) { camera ->
                        cameraRef = camera
                    }
                }
            }
        }
    }
}

@Composable
fun ThroatCheckScreen(
    context: Context,
    onCameraReady: (Camera?) -> Unit
) {
    var isFlashlightOn by remember { mutableStateOf(false) }
    var camera by remember { mutableStateOf<Camera?>(null) }

    LaunchedEffect(Unit) {
        onCameraReady(camera)
    }

    ThroatCheckContent(
        isFlashlightOn = isFlashlightOn,
        onFlashlightToggle = { enabled ->
            isFlashlightOn = enabled
            if (camera != null) {
                setTorchMode(camera!!, enabled)
            } else {
                Log.w("Flashlight", "Camera not ready yet")
            }
        },
        context = context,
        onCameraReady = { cameraObj ->
            camera = cameraObj
            onCameraReady(cameraObj)
        }
    )
}

@Composable
fun ThroatCheckContent(
    isFlashlightOn: Boolean,
    onFlashlightToggle: (Boolean) -> Unit,
    context: Context,
    onCameraReady: (Camera?) -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            // Header
            Text(
                text = "Doctor Throat",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,
                modifier = Modifier.padding(top = 16.dp)
            )

            // Camera preview area
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .background(Color.DarkGray)
            ) {
                AndroidView(
                    factory = { ctx ->
                        PreviewView(ctx).apply {
                            startCamera(this, ctx, onCameraReady)
                        }
                    },
                    modifier = Modifier.fillMaxSize()
                )
            }

            // Flashlight button
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 32.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Button(
                    onClick = { onFlashlightToggle(!isFlashlightOn) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(70.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (isFlashlightOn) Color.Yellow else Color.DarkGray,
                        contentColor = if (isFlashlightOn) Color.Black else Color.White
                    )
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "🔦",
                            fontSize = 28.sp
                        )
                        Text(
                            text = if (isFlashlightOn) "Turn Off" else "Turn On Flashlight",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }

                Text(
                    text = if (isFlashlightOn) "Flashlight is active" else "Tap to activate light",
                    color = Color.White,
                    fontSize = 12.sp,
                    modifier = Modifier.padding(top = 16.dp)
                )
            }
        }
    }
}

private fun startCamera(
    previewView: PreviewView,
    context: Context,
    onCameraReady: (Camera?) -> Unit
) {
    val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
    cameraProviderFuture.addListener({
        try {
            val cameraProvider = cameraProviderFuture.get()

            // Create preview use case
            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(previewView.surfaceProvider)
            }

            // Select back camera
            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            // Bind to lifecycle and get camera reference
            cameraProvider.unbindAll()
            val camera = cameraProvider.bindToLifecycle(
                context as LifecycleOwner,
                cameraSelector,
                preview
            )

            onCameraReady(camera)
        } catch (e: Exception) {
            Log.e("CameraX", "Camera binding failed: ${e.message}", e)
            onCameraReady(null)
        }
    }, ContextCompat.getMainExecutor(context))
}

private fun setTorchMode(camera: Camera, enable: Boolean) {
    try {
        if (camera.cameraInfo.hasFlashUnit()) {
            camera.cameraControl.enableTorch(enable)
        }
    } catch (e: Exception) {
        Log.e("Flashlight", "Failed to set torch mode", e)
    }
}

@Composable
fun DoctorThroatTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = darkColorScheme(
            primary = Color(0xFFBB86FC),
            secondary = Color(0xFF03DAC6),
            background = Color.Black,
            surface = Color.DarkGray
        )
    ) {
        content()
    }
}
