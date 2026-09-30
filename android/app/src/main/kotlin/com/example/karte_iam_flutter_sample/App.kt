package com.example.karte_iam_flutter_sample

import android.os.Build
import io.flutter.app.FlutterApplication
import io.karte.android.KarteApp
import io.karte.android.core.config.Config
import io.karte.android.core.logger.LogLevel
import io.karte.android.inappmessaging.InAppMessagingConfig

class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        KarteApp.setLogLevel(LogLevel.DEBUG)
        val iamConfig = InAppMessagingConfig.Builder()
            .isEdgeToEdgeEnabled(Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
            .build()
        val config = Config.Builder()
            .libraryConfigs(iamConfig)
            .build()
        // APP KEY is read from android/local.properties (karte.appKey=...).
        KarteApp.setup(this, BuildConfig.KARTE_APP_KEY, config)
    }
}
