package com.example.kotlinlab

import android.app.ProgressDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.example.kotlinlab.databinding.ActivityUserInfoBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

class UserInfoActivity : AppCompatActivity() {
    private lateinit var binding: ActivityUserInfoBinding
    private lateinit var progressDialog: ProgressDialog
    private lateinit var firebaseAuth: FirebaseAuth

    private var uid = ""
    private var name: String? = null
    private var male: String? = null
    private var favColor: String? = null
    private var favCity: String? = null
    private var favCountry: String? = null
    private  var favFood: String? = null
    private var surname: String? = null
    private var dateOfBirth: String? = null
    private var phoneNumber: String? = null
    private var address: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUserInfoBinding.inflate(layoutInflater)
        setContentView(binding.root)

        firebaseAuth = FirebaseAuth.getInstance()
        uid = firebaseAuth.uid!!
        progressDialog = ProgressDialog(this)

        detail()

        binding.backButton.setOnClickListener {
            onBackPressed()
        }

        binding.saveButton.setOnClickListener {
            save()
        }

        binding.logoutButton.setOnClickListener {
            firebaseAuth.signOut()
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }
    }

    private fun detail() {
        val ref = FirebaseDatabase.getInstance().getReference( "Users")
        ref.child(uid)
            .addListenerForSingleValueEvent(object: ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    name = snapshot.child("name").value as? String
                    male = snapshot.child("male").value as? String
                    favColor = snapshot.child("favColor").value as? String
                    favCity = snapshot.child("favCity").value as? String
                    favCountry = snapshot.child("favCountry").value as? String
                    favFood = snapshot.child("favFood").value as? String
                    surname = snapshot.child("surname").value as? String
                    dateOfBirth = snapshot.child("dateOfBirth").value as? String
                    phoneNumber = snapshot.child("phoneNumber").value as? String
                    address = snapshot.child("address").value as? String

                    name?.let { binding.nameEditText.setText(it) }
                    male?.let { binding.maleEditText.setText(it) }
                    favColor?.let { binding.favColorTextEdit.setText(it) }
                    favCity?.let { binding.favCityEditText.setText(it) }
                    favCountry?.let { binding.favCountryEditText.setText(it) }
                    favFood?.let { binding.favFoodEditText.setText(it) }
                    surname?.let { binding.surnameEditText.setText(it) }
                    dateOfBirth?.let { binding.dateOfBirthEditText.setText(it) }
                    phoneNumber?.let { binding.phoneNumberEditText.setText(it) }
                    address?.let { binding.addressEditText.setText(it) }
                }

                override fun onCancelled(error: DatabaseError) {
                }
            })

    }

    private fun save() {
        name = binding.nameEditText.text.toString().trim()
        male = binding.maleEditText.text.toString().trim()
        favColor = binding.favColorTextEdit.text.toString().trim()
        favCity = binding.favCityEditText.text.toString().trim()
        favCountry = binding.favCountryEditText.text.toString().trim()
        favFood = binding.favFoodEditText.text.toString().trim()
        surname = binding.surnameEditText.text.toString().trim()
        dateOfBirth = binding.dateOfBirthEditText.text.toString().trim()
        phoneNumber = binding.phoneNumberEditText.text.toString().trim()
        address = binding.addressEditText.text.toString().trim()

        progressDialog.setMessage("Updating user info")
        progressDialog.show()

        val updates = hashMapOf<String, Any?>(
            "name" to name,
            "male" to male,
            "favColor" to favColor,
            "favCity" to favCity,
            "favCountry" to favCountry,
            "favFood" to favFood,
            "surname" to surname,
            "dateOfBirth" to dateOfBirth,
            "phoneNumber" to phoneNumber,
            "address" to address
        )

        val ref = FirebaseDatabase.getInstance().getReference("Users")
        ref.child(uid)
            .updateChildren(updates)
            .addOnSuccessListener {
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Info is updated",
                    Toast.LENGTH_SHORT
                ).show()
            }
            .addOnFailureListener { e ->
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Error: ${e.message}",
                    Toast.LENGTH_SHORT
                ).show()
            }
    }

}