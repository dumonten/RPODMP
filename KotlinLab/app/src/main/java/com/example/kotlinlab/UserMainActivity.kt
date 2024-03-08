package com.example.kotlinlab

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.example.kotlinclass.AdapterCity
import com.example.kotlinclass.ModelCity
import com.example.kotlinlab.databinding.ActivityUserMainBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.GenericTypeIndicator
import com.google.firebase.database.ValueEventListener

class UserMainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityUserMainBinding
    private lateinit var firebaseAuth: FirebaseAuth
    private lateinit var cityArrayList: ArrayList<ModelCity>
    private lateinit var adapterCity: AdapterCity
    var favoritesArrayList = ArrayList<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUserMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        firebaseAuth = FirebaseAuth.getInstance()

        checkUser()

        val firebaseUserUid = firebaseAuth.currentUser!!.uid
        val ref = FirebaseDatabase.getInstance().getReference("Users")
        ref.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                favoritesArrayList = snapshot.child(firebaseUserUid).child("favs").
                getValue(object : GenericTypeIndicator<ArrayList<String>>() {})!!
                if (binding.showButton.text == getString(R.string.all_cities)) {
                    loadCities(true)
                } else {
                    loadCities(false)
                }
            }

            override fun onCancelled(error: DatabaseError) {
            }
        })

        binding.userInfoButton.setOnClickListener {
            detail()
        }

        binding.showButton.setOnClickListener {
            if (binding.showButton.text == getString(R.string.all_cities)) {
                binding.showButton.text = getString(R.string.my_favorites)
                loadCities(false)
            } else {
                binding.showButton.text = getString(R.string.all_cities)
                loadCities(true)
            }
        }
    }

    private fun detail() {
        startActivity(Intent(this, UserInfoActivity::class.java))
    }

    private fun checkUser() {
        val firebaseUser = firebaseAuth.currentUser
        if (firebaseUser != null) {
            val email = firebaseUser.email
            binding.emailTv.text = email
        }
    }

    private fun loadCities(isFavList: Boolean) {
        cityArrayList = ArrayList()
        val ref = FirebaseDatabase.getInstance().getReference("Cities")
        ref.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                cityArrayList.clear()
                for (ds in snapshot.children) {
                    val model = ds.getValue(ModelCity::class.java)!!

                    if (isFavList) {
                        if (model.id in favoritesArrayList) {
                            cityArrayList.add(model)
                        }
                    } else {
                        cityArrayList.add(model)
                    }
                }
                adapterCity = AdapterCity( this@UserMainActivity, cityArrayList, favoritesArrayList)
                binding.citiesList.adapter = adapterCity
            }
            override fun onCancelled(error: DatabaseError) {
            }
        })
    }
}