package com.nati.petadoptapp.presentation.organization.fragment

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.bumptech.glide.Glide
import com.nati.petadoptapp.databinding.FragmentOrganizationDetailBinding
import com.nati.petadoptapp.model.Organization
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.presentation.organization.viewmodel.OrganizationDetailState
import com.nati.petadoptapp.presentation.organization.viewmodel.OrganizationViewModel
import org.koin.androidx.viewmodel.ext.android.activityViewModel

class OrganizationDetailFragment : Fragment() {

    private val binding: FragmentOrganizationDetailBinding by lazy {
        FragmentOrganizationDetailBinding.inflate(layoutInflater)
    }

    private val args: OrganizationDetailFragmentArgs by navArgs()

    private val organizationViewModel: OrganizationViewModel by activityViewModel()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        initViewModel()

        organizationViewModel.fetchOrganizationDetail(args.organizationId)
    }

    private fun initViewModel() {
        organizationViewModel.organizationDetailLiveData.observe(viewLifecycleOwner) { state ->
            handleOrganizationDetailState(state)
        }
    }

    private fun handleOrganizationDetailState(state: OrganizationDetailState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbOrganizationDetail.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbOrganizationDetail.visibility = View.GONE
                initUI(state.result)
            }

            is ResourceState.Error -> {
                binding.pbOrganizationDetail.visibility = View.GONE
                Toast.makeText(requireContext(), state.error, Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbOrganizationDetail.visibility = View.GONE
        }
    }

    private fun initUI(organization: Organization) {

        binding.btnOrganizationDetailBack.setOnClickListener {
            findNavController().popBackStack()
        }

        if (organization.photos.isNotEmpty()) {
            Glide.with(binding.ifvOrganizationDetailImage).load(organization.photos[0].full)
                .into(binding.ifvOrganizationDetailImage)
        }

        binding.tvOrganizationDetailName.text = organization.name
        binding.tvOrganizationDetailLocation.text = organization.address.city
        binding.tvOrganizationDetailMonday.text = organization.hours?.monday ?: "- -"
        binding.tvOrganizationDetailTuesday.text = organization.hours?.tuesday ?: "- -"
        binding.tvOrganizationDetailWednesday.text = organization.hours?.wednesday ?: "- -"
        binding.tvOrganizationDetailThursday.text = organization.hours?.thursday ?: "- -"
        binding.tvOrganizationDetailFriday.text = organization.hours?.friday ?: "- -"
        binding.tvOrganizationDetailSaturday.text = organization.hours?.saturday ?: "- -"
        binding.tvOrganizationDetailSunday.text = organization.hours?.sunday ?: "- -"
        binding.tvOrganizationDetailEmail.text = organization.email ?: "Sin información"
        binding.tvOrganizationDetailDescription.text = organization.missionStatement ?: "Sin información"

        binding.btnOrganizationDetailPhone.setOnClickListener {
            val intent = Intent(Intent.ACTION_DIAL)
            intent.data = Uri.parse("tel:${organization.phone}")
            startActivity(intent)
        }
    }


}