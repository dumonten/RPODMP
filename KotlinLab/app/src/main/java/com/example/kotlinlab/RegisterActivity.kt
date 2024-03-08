package com.example.kotlinlab

import android.app.ProgressDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Patterns
import android.widget.Toast
import com.example.kotlinlab.databinding.ActivityRegisterBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase

class RegisterActivity : AppCompatActivity() {
    private lateinit var binding: ActivityRegisterBinding
    private lateinit var firebaseAuth: FirebaseAuth
    private lateinit var progressDialog: ProgressDialog

    private var name = ""
    private var email = ""
    private var password = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRegisterBinding.inflate(layoutInflater)
        setContentView(binding.root)

        firebaseAuth = FirebaseAuth.getInstance()
        progressDialog = ProgressDialog(this)
        progressDialog.setTitle("Please wait")
        progressDialog.setCanceledOnTouchOutside(false)

        binding.registerButton.setOnClickListener {
            validateData();
        }
    }

    private fun validateData() {
        name = binding.nameEditText.text.toString().trim()
        email = binding.emailEditText.text.toString().trim()
        password = binding.passwordEditText.text.toString().trim()
        val confirmPassword = binding.passwordEditText.text.toString().trim()

        if (name.isEmpty()) {
            Toast.makeText(this, "Enter your name", Toast.LENGTH_SHORT).show()
        } else if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            Toast.makeText(this, "Invalid email", Toast.LENGTH_SHORT).show()
        } else if (password.isEmpty()) {
            Toast.makeText(this, "Enter password", Toast.LENGTH_SHORT).show()
        } else if (confirmPassword.isEmpty()) {
            Toast.makeText(this, "Confirm password", Toast.LENGTH_SHORT).show()
        } else if (password != confirmPassword) {
            Toast.makeText(this, "Password doesn't match", Toast.LENGTH_SHORT).show()
        } else {
            createUserAccount();
        }
    }

    private fun createUserAccount() {
        progressDialog.setMessage("Creating Account is in process");
        progressDialog.show()
        firebaseAuth.createUserWithEmailAndPassword(email, password)
            .addOnSuccessListener {
                updateUserInfo()
            }
            .addOnFailureListener { e ->
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Failed creating account due to ${e.message}",
                    Toast.LENGTH_SHORT
                ).show()
            }
    }

    private fun updateUserInfo() {
        progressDialog.setMessage("Saving user info…")
        val timestamp = System.currentTimeMillis()
        val uid = firebaseAuth.uid
        val hashMap: HashMap<String, Any?> = HashMap()
        hashMap["uid"] = uid
        hashMap["email"] = email
        hashMap["userType"] = "user"
        hashMap["timestamp"] = timestamp
        hashMap["name"] = name
        hashMap["male"] = ""
        hashMap["favColor"] = ""
        hashMap["favCity"] = ""
        hashMap["favCountry"] = ""
        hashMap["favFood"] = ""
        hashMap["surname"] = ""
        hashMap["dateOfBirth"] = ""
        hashMap["phoneNumber"] = ""
        hashMap["address"] = ""
        hashMap["favs"] = ArrayList<String>().apply { add("NULL") }

        val ref = FirebaseDatabase.getInstance().getReference("Users")
        ref. child(uid!!)
            .setValue(hashMap)
                .addOnSuccessListener {
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Account created",
                    Toast.LENGTH_SHORT
                ).show()
                startActivity(Intent(this@RegisterActivity, UserMainActivity::class.java))
                finish()
            }
            .addOnFailureListener() {e ->
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Error: ${e.message}",
                    Toast.LENGTH_SHORT
                ).show()
            }
    }
}