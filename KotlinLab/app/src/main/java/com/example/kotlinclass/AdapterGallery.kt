package com.example.kotlinclass;

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.example.kotlinlab.databinding.ItemImageBinding

class AdapterGallery(private val imageUrls: List<String>): RecyclerView.Adapter<AdapterGallery.ImageViewHolder>() {

    // Declare a private variable of type ItemImageBinding
    private lateinit var binding: ItemImageBinding

    inner class ImageViewHolder(private val binding: ItemImageBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(imageUrl: String) {
            // Use the binding instance to load the image
            Glide.with(itemView.context).load(imageUrl).into(binding.imageView)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ImageViewHolder {
        // Initialize the binding variable here
        binding = ItemImageBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ImageViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ImageViewHolder, position: Int) {
        // Use the binding instance to bind the data
        holder.bind(imageUrls[position])
    }

    override fun getItemCount() = imageUrls.size
}
