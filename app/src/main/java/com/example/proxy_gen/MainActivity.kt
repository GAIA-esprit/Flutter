package com.example.proxy_gen

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.PopupMenu
import com.example.proxy_gen.databinding.ActivityMainBinding
import com.google.firebase.auth.FirebaseAuth

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var auth: FirebaseAuth
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        auth = FirebaseAuth.getInstance()
        val currentUser = auth.currentUser
        val email = currentUser?.email
        val name = email?.let { getEmailUserName(it) }


        binding.email.setText(email)
        binding.emailName.setText("Connection $name")

        binding.proxyToggleButton.setOnClickListener{
            if (binding.proxyToggleButton.isChecked)
            {
                binding.proxyStatus.setText("proxy is enabled")
            }
            else
            {
                binding.proxyStatus.setText("proxy is disabled")
            }
        }

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.my_toolbar)
        setSupportActionBar(toolbar)

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {

            R.id.action_item1 -> {
                startActivity(Intent(this, AssistantActivity::class.java))
                return true
            }
            R.id.action_item2 -> {
                startActivity(Intent(this, P0fActivity::class.java))
                return true
            }
            R.id.action_item5 -> {
                toggleAirplaneMode(this)
                return true
            }
            R.id.action_item6 -> {
                startActivity(Intent(this, SettingsActivity::class.java))
                return true
            }
            else -> return super.onOptionsItemSelected(item)
        }
    }

    private fun showPopupMenu(view: View) {
        val popupMenu = PopupMenu(this, view)
        val inflater: MenuInflater = popupMenu.menuInflater
        inflater.inflate(R.menu.menu_main, popupMenu.menu)
        popupMenu.show()

        popupMenu.setOnMenuItemClickListener { item ->
            when (item.itemId) {
                R.id.action_item6 -> {
                    startActivity(Intent(this, SettingsActivity::class.java))
                    true
                }

                else -> false
            }
        }
    }
    private fun getEmailUserName(email: String): String {
        // Split the email using the '@' character and get the first part
        val parts = email.split("@")
        return if (parts.isNotEmpty()) {
            parts[0]
        } else {
            // Handle the case where '@' is not present in the email
            "InvalidEmailFormat"
        }
    }
    fun toggleAirplaneMode(context: Context) {
        // Check if airplane mode is enabled
        val isAirplaneModeOn = Settings.Global.getInt(
            context.contentResolver,
            Settings.Global.AIRPLANE_MODE_ON,
            0
        ) != 0

        // Toggle airplane mode
        Settings.Global.putInt(
            context.contentResolver,
            Settings.Global.AIRPLANE_MODE_ON,
            if (isAirplaneModeOn) 0 else 1
        )

        // Notify the system that airplane mode has changed
        val intent = Intent(Intent.ACTION_AIRPLANE_MODE_CHANGED)
        intent.putExtra("state", !isAirplaneModeOn)
        context.sendBroadcast(intent)
    }
}
