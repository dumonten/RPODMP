package com.example.kotlinclass

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android. view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.example.kotlinlab.CityActivity
import com.example.kotlinlab.databinding.RowCityBinding
import com.google.firebase.database.FirebaseDatabase

class AdapterCity : RecyclerView.Adapter<AdapterCity.HolderCity> {
    private val context: Context
    private val cityArrayList: ArrayList<ModelCity>
    private val features : ArrayList<String>

    private lateinit var binding: RowCityBinding

    constructor(context: Context, cityArrayList: ArrayList<ModelCity>, features: ArrayList<String>) {
        this.context = context
        this.cityArrayList = cityArrayList
        this.features = features
    }

    inner class HolderCity(itemView: View): RecyclerView.ViewHolder(itemView) {
            var detailButton: Button = binding.detailButton
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): HolderCity {
        binding = RowCityBinding.inflate(LayoutInflater.from(context), parent, false)
        return HolderCity(binding.root)
    }

    override fun getItemCount(): Int {
        return cityArrayList.size
    }

    override fun onBindViewHolder(holder: HolderCity, position: Int) {
        val model = cityArrayList[position]
        val name = model.name

        holder.detailButton.setText(name)
        holder.detailButton.setOnClickListener {
            detail(model, holder)
        }
    }

    private fun detail(model: ModelCity, holder: HolderCity) {
        val id = model.id

        val intent = Intent(context, CityActivity::class.java)
        intent.putExtra("id", id)
        intent.putExtra("isFav", (id in features).toString())
        context.startActivity(intent)
    }

}