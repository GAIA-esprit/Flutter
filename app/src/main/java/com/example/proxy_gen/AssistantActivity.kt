package com.example.proxy_gen

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class AssistantActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_assistant)

        // Load the first fragment
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragmentContainer, AsssistantFirst())
                .commit()
        }
    }
}