package com.example.proxy_gen

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.view.View
import android.view.WindowInsets
import android.view.WindowInsetsController
import androidx.appcompat.app.AppCompatActivity
import com.example.proxy_gen.R
import com.example.proxy_gen.SignInActivity

class SplashActivity : AppCompatActivity() {

    private val SPLASH_DELAY: Long = 2000 // 2 seconds

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        // Hide both the ActionBar and the status bar
        supportActionBar?.hide()

        // Check for system UI visibility and set fullscreen mode
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.insetsController?.let {
                it.systemBarsBehavior =
                    WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
                it.hide(WindowInsets.Type.statusBars())
                it.hide(WindowInsets.Type.navigationBars())
            }
        } else {
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility =
                View.SYSTEM_UI_FLAG_FULLSCREEN or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
        }

        // Use a handler to delay the start of the main activity
        Handler().postDelayed({
            val mainIntent = Intent(this, SignInActivity::class.java)
            startActivity(mainIntent)
            finish()
        }, SPLASH_DELAY)
    }
}
