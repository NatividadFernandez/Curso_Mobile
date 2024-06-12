package com.nati.petadoptapp.presentation.organization.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.nati.petadoptapp.databinding.RowOrganizationListItemBinding
import com.nati.petadoptapp.model.Organization

class OrganizationListAdapter :
    RecyclerView.Adapter<OrganizationListAdapter.OrganizationListViewHolder>() {

    private var organizationList: List<Organization> = emptyList()

    var onClickListener: (Organization) -> Unit = {}

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): OrganizationListViewHolder {
        val binding = RowOrganizationListItemBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return OrganizationListViewHolder(binding)
    }

    override fun getItemCount() = organizationList.size

    @SuppressLint("SetTextI18n")
    override fun onBindViewHolder(holder: OrganizationListViewHolder, position: Int) {
        val item = organizationList[position]

        holder.rootView.setOnClickListener {
            onClickListener.invoke(item)
        }

        holder.tvOrganizationName.text = item.name
        holder.tvOrganizationAddress.text = item.address.city
        holder.tvOrganizationPhone.text = item.phone
        holder.tvOrganizationEmail.text = item.email

        if (item.photos.isNotEmpty()) {
            Glide.with(holder.ivOrganizationImage).load(item.photos[0].medium)
                .into(holder.ivOrganizationImage)
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun submitList(list: List<Organization>) {
        organizationList = list
        notifyDataSetChanged()
    }

    inner class OrganizationListViewHolder(binding: RowOrganizationListItemBinding) :
        RecyclerView.ViewHolder(binding.root) {
        val rootView = binding.root
        val tvOrganizationName = binding.tvOrganizationItemName
        val tvOrganizationAddress = binding.tvOrganizationItemAddress
        val tvOrganizationPhone = binding.tvOrganizationItemPhone
        val tvOrganizationEmail = binding.tvOrganizationItemEmail
        val ivOrganizationImage = binding.ifvOrganizationItemImage
    }
}