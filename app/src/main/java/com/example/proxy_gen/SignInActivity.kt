package com.example.proxy_gen

import android.content.Intent
import android.os.Bundle
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.View
import android.view.animation.TranslateAnimation
import android.widget.Button
import android.widget.EditText
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.example.proxy_gen.databinding.ActivitySignInBinding
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.auth.FirebaseAuth

class SignInActivity: AppCompatActivity() {


    private lateinit var binding: ActivitySignInBinding
    private lateinit var firebaseAuth: FirebaseAuth
    private lateinit var swapToPin: Button
    private lateinit var swapToEmail: Button
    private lateinit var layout_pin: TextInputLayout
    private lateinit var layout_email: TextInputLayout
    private lateinit var layout_password: TextInputLayout
    private lateinit var indicatorLine: View
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySignInBinding.inflate(layoutInflater)
        setContentView(binding.root)

        firebaseAuth = FirebaseAuth.getInstance()
        binding.login.setOnClickListener {
            val mail = binding.editTextEmail.text.toString()
            val pass = binding.editTextPassword.text.toString()
            if (mail.isEmpty())
            {
                Toast.makeText(this, "Email can't be empty!", Toast.LENGTH_SHORT).show()
            }
            else if (pass.isEmpty())
            {
                Toast.makeText(this, "Password can't be empty!", Toast.LENGTH_SHORT).show()
            }
            else if (!isEmailValid(mail))
            {
                Toast.makeText(this, "Enter a valid email!", Toast.LENGTH_SHORT).show()
            }
            else
            {
                firebaseAuth.signInWithEmailAndPassword(mail, pass).addOnCompleteListener {
                    if (it.isSuccessful) {
                        val intent = Intent(this, MainActivity::class.java)
                        startActivity(intent)
                    } else {
                        Toast.makeText(this, it.exception.toString(), Toast.LENGTH_SHORT).show()
                    }
                }
            }
        }
        layout_pin = findViewById(R.id.layout_pin)
        layout_email = findViewById(R.id.layout_email)
        layout_password = findViewById(R.id.layout_password)

        swapToPin = findViewById(R.id.mailButton)
        swapToEmail = findViewById(R.id.pinButton)
        indicatorLine = findViewById(R.id.indicatorLine)
        val purple = R.color.purple
        val color_purple = ContextCompat.getColor(this, purple)
        val white = R.color.white
        val color_white = ContextCompat.getColor(this, white)

        swapToEmail.setOnClickListener {
            swapToEmail.setBackgroundColor(color_purple)
            swapToPin.setBackgroundColor(color_white)
            layout_email.visibility = Button.GONE
            layout_password.visibility = Button.GONE
            layout_pin.visibility = Button.VISIBLE
            val fromX = indicatorLine.x
            val toX = swapToEmail.x + swapToEmail.width - indicatorLine.width
            val animation = TranslateAnimation(0f, toX - fromX, 0f, 0f)
            animation.duration = 300 // Adjust the duration as needed
            animation.fillAfter = true
            indicatorLine.startAnimation(animation)
        }
        swapToPin.setOnClickListener {
            swapToPin.setBackgroundColor(color_purple)
            swapToEmail.setBackgroundColor(color_white)
            layout_email.visibility = Button.VISIBLE
            layout_password.visibility = Button.VISIBLE
            layout_pin.visibility = Button.GONE
            val fromX = indicatorLine.x
            val toX = swapToPin.x + swapToPin.width - indicatorLine.width
            val animation = TranslateAnimation(0f, toX - fromX, 0f, 0f)
            animation.duration = 300 // Adjust the duration as needed
            animation.fillAfter = true
            indicatorLine.startAnimation(animation)
        }
        //terms with clickable link
        val textViewForm2 = findViewById<TextView>(R.id.terms)
        val message = "By logging in, you agree with Terms of Service as well as our Privacy Policy."
        val spannableString = SpannableString(message)
        val clickableSpanTerms = object : ClickableSpan() {
            override fun onClick(widget: View) {
                Toast.makeText(this@SignInActivity, "Terms of Service Clicked!", Toast.LENGTH_SHORT).show()
            }

            override fun updateDrawState(ds: TextPaint) {
                super.updateDrawState(ds)
                ds.isUnderlineText = true  // Add underline to indicate it's clickable
                ds.color = ContextCompat.getColor(this@SignInActivity, R.color.blue_link)
            }
        }
        spannableString.setSpan(clickableSpanTerms, message.indexOf("Terms of Service"), message.indexOf("as well as"), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        val clickableSpanPrivacy = object : ClickableSpan() {
            override fun onClick(widget: View) {
                Toast.makeText(this@SignInActivity, "Privacy Policy Clicked!", Toast.LENGTH_SHORT).show()
            }

            override fun updateDrawState(ds: TextPaint) {
                super.updateDrawState(ds)
                ds.isUnderlineText = true
                ds.color = ContextCompat.getColor(this@SignInActivity, R.color.blue_link)
            }
        }
        spannableString.setSpan(clickableSpanPrivacy, message.indexOf("Privacy Policy"), message.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        textViewForm2.text = spannableString
        textViewForm2.movementMethod = LinkMovementMethod.getInstance()

    }
}
fun isEmailValid(email: String): Boolean {
    val emailRegex = Regex("^\\S+@\\S+\\.\\S+\$")
    return emailRegex.matches(email)
}
