package com.example.proxy_gen

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.example.proxy_gen.databinding.ActivitySignUpBinding
import com.google.firebase.auth.FirebaseAuth

class SignUpActivity : AppCompatActivity() {
    private lateinit var binding: ActivitySignUpBinding
    private lateinit var  firebaseAuth: FirebaseAuth
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivitySignUpBinding.inflate(layoutInflater)
        setContentView(binding.root)
        Log.d("ActivitySignIn", "signup")

        firebaseAuth = FirebaseAuth.getInstance()
        binding.sign.setOnClickListener{
            val email = binding.mail.text.toString()
            val pass = binding.password.text.toString()
            val confirm = binding.confirm.text.toString()

            if (email.isNotEmpty() && pass.isNotEmpty() && confirm.isNotEmpty()){
                if (pass == confirm){
                    firebaseAuth.createUserWithEmailAndPassword(email , pass).addOnCompleteListener{
                        if (it.isSuccessful){
                            val intent = Intent(this, SignInActivity::class.java)
                            startActivity(intent)
                        }else{
                            Toast.makeText(this, it.exception.toString() , Toast.LENGTH_SHORT).show()
                        }
                    }
                }
                else{
                    Toast.makeText(this,"password not matching", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }
}