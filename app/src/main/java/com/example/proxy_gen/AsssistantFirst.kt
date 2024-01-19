package com.example.proxy_gen

import AssistantSecond
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button

// FirstFragment.kt
class AsssistantFirst : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_asssistant_first, container, false)

        // Find the button in the layout
        val button: Button = view.findViewById(R.id.buttonNavigate)

        // Set a click listener for the button
        button.setOnClickListener {
            // Navigate to the second fragment when the button is clicked
            val fragmentTransaction = requireActivity().supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(R.id.fragmentContainer, AssistantSecond())
            fragmentTransaction.addToBackStack(null) // Add to back stack to handle back button
            fragmentTransaction.commit()
        }

        return view
    }
}
