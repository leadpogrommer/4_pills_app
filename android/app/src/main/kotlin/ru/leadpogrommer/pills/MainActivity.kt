package ru.leadpogrommer.pills

import android.app.KeyguardManager
import android.app.KeyguardManager.KeyguardDismissCallback
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "ru.leadpogrommer.fuck"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{ call, result ->
            val kg = (getSystemService(KEYGUARD_SERVICE) as KeyguardManager)
            when(call.method){
                "dismiss" -> {
                    kg.requestDismissKeyguard(this, object : KeyguardDismissCallback() {
                        override fun onDismissError() {
                            result.success(kg.isDeviceLocked)
                        }

                        override fun onDismissCancelled() {
                            result.success(kg.isDeviceLocked)
                        }

                        override fun onDismissSucceeded() {
                            result.success(kg.isDeviceLocked)
                        }

                    })
                }
                "isLocked" -> {
                    result.success(kg.isDeviceLocked)
                }
                else -> {
                    result.notImplemented()
                }
            }

        }
    }
}
