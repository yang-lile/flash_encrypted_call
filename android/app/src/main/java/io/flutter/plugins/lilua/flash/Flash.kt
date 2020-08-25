package io.flutter.plugins.lilua.flash

import android.content.Context
import android.hardware.camera2.CameraManager
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


class Flash() : FlutterPlugin, MethodCallHandler {
    private lateinit var cameraManager : CameraManager
    private var channel:MethodChannel? = null
    private lateinit var context:Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        channel = MethodChannel(binding.binaryMessenger, "com.lilia.Flash_Encrypted_Call/Flash")
        channel!!.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            "openCameraLight"->openCameraLight()
            "closeCameraLight"->closeCameraLight()
            else->result.notImplemented()
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    fun openCameraLight(){
        cameraManager.setTorchMode(cameraManager.cameraIdList[0],true)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    fun closeCameraLight(){
        cameraManager.setTorchMode(cameraManager.cameraIdList[0],false)
    }
}
