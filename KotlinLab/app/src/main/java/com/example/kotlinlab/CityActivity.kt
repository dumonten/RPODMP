package com.example.kotlinlab

import android.annotation.SuppressLint
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.example.kotlinclass.AdapterGallery
import com.example.kotlinlab.databinding.ActivityCityBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.GenericTypeIndicator
import com.google.firebase.database.ValueEventListener

class CityActivity : AppCompatActivity() {
    private lateinit var binding: ActivityCityBinding
    private lateinit var adapterGalery: AdapterGallery
    private lateinit var firebaseAuth: FirebaseAuth
    var favoritesArrayList = ArrayList<String>()
    private var id = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCityBinding.inflate(layoutInflater)
        setContentView(binding.root)

        id = intent.getStringExtra("id")!!

        detail()

        binding.backButton.setOnClickListener {
            onBackPressed()
        }

        firebaseAuth = FirebaseAuth.getInstance()

        binding.addToFavoritesBtn.setOnClickListener {
            addToFavorites()
        }

    }

    private fun addToFavorites() {
        val uid = firebaseAuth.uid
        val ref = FirebaseDatabase.getInstance().getReference( "Users")
        ref.child(uid!!)
            .addListenerForSingleValueEvent(object: ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    favoritesArrayList = snapshot.child("favs").value as ArrayList<String>
                    if (id in favoritesArrayList) {
                        favoritesArrayList.remove(id)
                        binding.addToFavoritesBtn.text = getString(R.string.save_to_favorites)
                    } else {
                        favoritesArrayList.add(id)
                        binding.addToFavoritesBtn.text = getString(R.string.remove_from_favorites)
                    }
                    ref.child(uid).child("favs").setValue(favoritesArrayList)
                }
                override fun onCancelled(error: DatabaseError) {
                }
            })
    }

     private fun detail() {
         val ref = FirebaseDatabase.getInstance().getReference( "Cities")
         val isFav = intent.getStringExtra("isFav")
         ref.child(id)
             .addListenerForSingleValueEvent(object: ValueEventListener {
                 override fun onDataChange(snapshot: DataSnapshot) {
                     val name =  snapshot.child( "name").value
                     val description = snapshot.child( "description").value
                     val yearOfFoundation = snapshot.child( "yearOfFoundation").value
                     val country = snapshot.child( "country").value
                     val imageUrls: List<String> = snapshot.child( "imageUrls").value as List<String>

                     binding.cityNameTv.text = name.toString()
                     binding.countryTv.text = country.toString()
                     binding.yearOfFoundationTv.text = yearOfFoundation.toString()
                     binding.descriptionTv.text = description.toString()

                     val viewPager = binding.imagesViewer
                     adapterGalery = AdapterGallery(imageUrls)
                     viewPager.adapter = adapterGalery

                     if (isFav == "true") {
                         binding.addToFavoritesBtn.text = getString(R.string.remove_from_favorites)
                     } else {
                         binding.addToFavoritesBtn.text = getString(R.string.save_to_favorites)
                     }
                 }

                 override fun onCancelled(error: DatabaseError) {
                 }
             })

     }
}