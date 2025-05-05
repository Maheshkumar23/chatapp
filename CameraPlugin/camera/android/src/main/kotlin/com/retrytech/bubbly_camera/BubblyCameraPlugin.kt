package com.retrytech.bubbly_camera

import MyPlayStoreBilling
import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.android.billingclient.api.BillingClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


/** FlutterDailogPlugin */
class BubblyCameraPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var productId: String? = null

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bubbly_camera")
        channel.setMethodCallHandler(this)
    }

    var context: Activity? = null


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity
        binding.addActivityResultListener { requestCode, resultCode, data ->
            Log.e(
                    "TAG",
                    "onReattachedToActivityForConfigChanges: " + requestCode + "resultCode" + resultCode + "Data" + data
            )

            true
        }
        if (ContextCompat.checkSelfPermission(
                        context!!,
                        Manifest.permission.CAMERA
                ) != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
                        context!!,
                        Manifest.permission.READ_EXTERNAL_STORAGE
                ) != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
                        context!!,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                ) != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
                        context!!,
                        Manifest.permission.RECORD_AUDIO
                ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                    context!!,
                    arrayOf(
                            Manifest.permission.CAMERA,
                            Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.RECORD_AUDIO
                    ),
                    1000
            )
        }


    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }

    var myPlayStoreBillingClient: MyPlayStoreBilling? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.e("TAG", "onMethodCall: " + call.method)
        if (call.method.equals("in_app_purchase_id")) {

            myPlayStoreBillingClient =
                    MyPlayStoreBilling(context, object : MyPlayStoreBilling.OnPurchaseComplete {
                        override fun onConnected(isConnect: Boolean) {
                            productId = call.arguments as String?
                            myPlayStoreBillingClient?.startPurchase(
                                    productId,
                                    BillingClient.ProductType.INAPP,
                                    true
                            )
                        }

                        override fun onPurchaseResult(isPurchaseSuccess: Boolean) {
                            channel.invokeMethod(
                                    "is_success_purchase",
                                    isPurchaseSuccess,
                                    object : MethodChannel.Result {
                                        override fun success(result: Any?) {
                                            Log.e("TAG", "success: $result")

                                        }

                                        override fun error(
                                                errorCode: String,
                                                errorMessage: String?,
                                                errorDetails: Any?
                                        ) {
                                            Log.e("TAG", "error: ")
                                        }

                                        override fun notImplemented() {
                                            Log.e("TAG", "notImplemented: ")
                                        }

                                    })
                            myPlayStoreBillingClient?.onDestroy()
                            Log.d("TAG", "onPurchaseResult: $isPurchaseSuccess")

                        }
                    })
        }
    }


}

