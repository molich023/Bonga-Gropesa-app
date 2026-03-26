// android/app/src/main/java/com/example/bonga/MainActivity.kt
package com.example.bonga

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.net.wifi.p2p.WifiP2pManager
import android.content.Context

class MainActivity: FlutterActivity() {
    private lateinit var wifiP2pManager: WifiP2pManager
    private lateinit var channel: WifiP2pManager.Channel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        wifiP2pManager = getSystemService(Context.WIFI_P2P_SERVICE) as WifiP2pManager
        channel = wifiP2pManager.initialize(this, mainLooper, null)
    }
}
