package com.nati.petadoptapp.presentation.pet.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.nati.petadoptapp.R
import com.nati.petadoptapp.databinding.RowPetListItemBinding
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.Petbase
import com.nati.petadoptapp.model.user.PetFireStore

class PetListAdapter : RecyclerView.Adapter<PetListAdapter.PetListViewHolder>() {

    private var petList: List<Petbase> = emptyList()
    private var originalPetList: MutableList<Petbase> = mutableListOf()

    var onClickListener: (Petbase) -> Unit = {}
    var onLongClickListener: (Petbase) -> Unit = {}

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PetListViewHolder {
        val binding =
            RowPetListItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return PetListViewHolder(binding)
    }

    override fun getItemCount() = petList.size

    @SuppressLint("NotifyDataSetChanged")
    override fun onBindViewHolder(holder: PetListViewHolder, position: Int) {
        val item = petList[position]

        holder.tvPetName.text = when (item) {
            is Pet -> item.name
            is PetFireStore -> item.name
            else -> ""
        }

        holder.tvPetAge.text = when (item) {
            is Pet -> item.age
            is PetFireStore -> item.age
            else -> ""
        }

        holder.tvPetGender.text = when (item) {
            is Pet -> item.gender
            is PetFireStore -> item.gender
            else -> ""
        }

        if (item is Pet) {
            holder.rootView.setOnClickListener {
                onClickListener.invoke(item)
            }

            holder.tvPetLocation.text = item.contact?.address?.city

            if (item.photos.isNotEmpty()) {
                Glide.with(holder.ivPetImage).load(item.photos[0].medium)
                    .into(holder.ivPetImage)
            }

            holder.icPetGender.setImageResource(getGender(item.gender))

        } else if (item is PetFireStore) {
            holder.rootView.setOnClickListener {
                onClickListener.invoke(item)
            }

            holder.rootView.setOnLongClickListener {
                onLongClickListener.invoke(item)
                true
            }

            holder.tvPetLocation.text = item.address

            if (item.photos.isNotEmpty()) {
                Glide.with(holder.ivPetImage).load(item.photos)
                    .into(holder.ivPetImage)
            }

            holder.icPetGender.setImageResource(getGender(item.gender))
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun filter(query: String) {
        petList = originalPetList.filter { pet ->
            when (pet) {
                is Pet -> pet.name.contains(query, ignoreCase = true) || pet.age.contains(
                    query,
                    ignoreCase = true
                )
                else -> false
            }
        }
        notifyDataSetChanged()
    }

    @SuppressLint("NotifyDataSetChanged")
    fun submitList(list: List<Petbase>) {
        originalPetList.clear()
        originalPetList.addAll(list)
        petList = originalPetList.toList()
        notifyDataSetChanged()
    }

    private fun getGender(gender: String): Int {
        return when (gender.lowercase()) {
            "female" -> R.drawable.baseline_female_24
            "male" -> R.drawable.baseline_male_24
            else -> R.drawable.baseline_female_24
        }
    }

    inner class PetListViewHolder(binding: RowPetListItemBinding) :
        RecyclerView.ViewHolder(binding.root) {
        val rootView = binding.root
        val tvPetName = binding.tvPetItemName
        val tvPetLocation = binding.tvPetItemLocation
        val tvPetGender = binding.tvPetItemGender
        val tvPetAge = binding.tvPetItemAge
        val ivPetImage = binding.ifvPetItemImage
        val icPetGender = binding.ifvGenderIcon
    }

}

