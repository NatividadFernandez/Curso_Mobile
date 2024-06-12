package com.nati.petadoptapp.presentation.pet.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.bumptech.glide.Glide
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import com.nati.petadoptapp.databinding.FragmentPetDetailBinding
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.presentation.pet.viewmodel.AddPetState
import com.nati.petadoptapp.presentation.pet.viewmodel.PetDetailState
import com.nati.petadoptapp.presentation.pet.viewmodel.PetViewModel

class PetDetailFragment : Fragment() {

    private val binding: FragmentPetDetailBinding by lazy {
        FragmentPetDetailBinding.inflate(layoutInflater)
    }

    private val args: PetDetailFragmentArgs by navArgs()

    private val petViewModel: PetViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        initViewModel()
    }

    private fun initViewModel() {
        petViewModel.petDetailLiveData.observe(viewLifecycleOwner) { state ->
            handlePetDetailState(state)
        }

        petViewModel.addPetLiveData.observe(viewLifecycleOwner) { state ->
            handleAddPetState(state)
        }

        petViewModel.fetchPetDetail(args.petId)
    }

    private fun handlePetDetailState(state: PetDetailState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbPetDetail.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbPetDetail.visibility = View.GONE
                initUI(state.result)
            }

            is ResourceState.Error -> {
                binding.pbPetDetail.visibility = View.GONE
                Toast.makeText(requireContext(), state.error, Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbPetDetail.visibility = View.GONE
        }
    }

    private fun handleAddPetState(state: AddPetState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbPetDetail.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbPetDetail.visibility = View.GONE
                Snackbar.make(requireView(), state.result, Snackbar.LENGTH_SHORT)
                    .show()
            }

            is ResourceState.Error -> {
                binding.pbPetDetail.visibility = View.GONE
                Toast.makeText(requireContext(), state.error, Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbPetDetail.visibility = View.GONE
        }
    }

    @SuppressLint("SetTextI18n")
    private fun initUI(pet: Pet) {

        if (pet.photos.isNotEmpty()) {
            Glide.with(binding.ifvPetDetailImage).load(pet.photos[0].full)
                .into(binding.ifvPetDetailImage)
        }
        binding.tvPetDetailName.text = pet.name
        binding.tvPetDetailAge.text = pet.age
        binding.tvPetDetailGender.text = pet.gender
        binding.tvPetDetailSize.text = pet.size
        binding.tvPetDetailBreed.text = pet.breeds?.primary ?: "Sin identificar"
        binding.tvPetDetailDescription.text = pet.description ?: "No hay información"
        binding.tvPetDetailEmail.text = pet.contact?.email ?: "Sin información"
        binding.tvPetDetailLocation.text = pet.contact?.address?.city ?: "Sin información"

        binding.btnPetDetailBack.setOnClickListener {
            findNavController().popBackStack()
        }

        binding.btnPetDetailOrganization.setOnClickListener {
            findNavController().navigate(
                PetDetailFragmentDirections.actionPetDetailFragmentToOrganizationDetailFragment(pet.organizationID)
            )
        }

        binding.btnPetDetailPhone.setOnClickListener {
            val intent = Intent(Intent.ACTION_DIAL)
            intent.data = Uri.parse("tel:${pet.contact?.phone ?: ""}")
            startActivity(intent)
        }

        binding.btnPetDetailAdopt.setOnClickListener {
            val newPet = PetFireStore(
                id = pet.id,
                organizationID = pet.organizationID,
                type = pet.type,
                species = pet.species,
                breeds = pet.breeds?.primary,
                age = pet.age,
                gender = pet.gender,
                size = pet.size,
                name = pet.name,
                description = pet.description,
                photos = if (pet.photos.isNotEmpty()) pet.photos[0].full else "",
                email = pet.contact?.email,
                phone = pet.contact?.phone,
                address = pet.contact?.address?.city
            )
            petViewModel.fetchAddPet(newPet)
        }
    }

}