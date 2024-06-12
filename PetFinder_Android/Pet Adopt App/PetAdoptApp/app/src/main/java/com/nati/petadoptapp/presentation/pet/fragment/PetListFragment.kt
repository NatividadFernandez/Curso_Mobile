package com.nati.petadoptapp.presentation.pet.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.GridLayoutManager
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.nati.petadoptapp.R
import com.nati.petadoptapp.data.utils.DialogConstant.BIRD
import com.nati.petadoptapp.data.utils.DialogConstant.CAT
import com.nati.petadoptapp.data.utils.DialogConstant.DOG
import com.nati.petadoptapp.data.utils.DialogConstant.RABBIT
import com.nati.petadoptapp.databinding.DialogTypePetBinding
import com.nati.petadoptapp.databinding.FragmentPetListBinding
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.presentation.pet.adapter.PetListAdapter
import com.nati.petadoptapp.presentation.pet.viewmodel.PetListState
import com.nati.petadoptapp.presentation.pet.viewmodel.PetViewModel
import org.koin.androidx.viewmodel.ext.android.activityViewModel

class PetListFragment : Fragment() {

    private val binding: FragmentPetListBinding by lazy {
        FragmentPetListBinding.inflate(layoutInflater)
    }

    private lateinit var bindingDialog: DialogTypePetBinding
    private val selectedOptions: MutableMap<String, Boolean> = mutableMapOf()

    private val petListAdapter = PetListAdapter()

    private val petViewModel: PetViewModel by activityViewModel()

    private var selectedPetType: String = ""

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        initViewModel()

        initUI()
    }

    private fun initViewModel() {

        petViewModel.petLiveData.observe(viewLifecycleOwner) { state ->
            handlePetListState(state)
        }
        petViewModel.fetchPetList(selectedPetType)
    }

    private fun initUI() {
        binding.rvPetList.adapter = petListAdapter
        binding.rvPetList.layoutManager = GridLayoutManager(requireContext(), 2)

        petListAdapter.onClickListener = { pet ->
            if (pet is Pet) {
                findNavController().navigate(
                    PetListFragmentDirections.actionPetListFragmentToPetDetailFragment(pet.id.toInt())
                )
            }
        }

        binding.etPetSearchPetList.addTextChangedListener { editable ->
            petListAdapter.filter(editable.toString())
        }

        binding.btnFilterPetDetail.setOnClickListener {
            showFilterDialog()
        }
    }

    private fun handlePetListState(state: PetListState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbPetList.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbPetList.visibility = View.GONE
                petListAdapter.submitList(state.result)
            }

            is ResourceState.Error -> {
                binding.pbPetList.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbPetList.visibility = View.GONE
        }
    }

    private fun showFilterDialog() {
        bindingDialog = DialogTypePetBinding.inflate(layoutInflater)

        // Restaurar selecciones anteriores
        val options = arrayOf("Dog", "Rabbit", "Cat", "Bird")
        for (option in options) {
            val radioButton = when (option) {
                "Dog" -> bindingDialog.rbDog
                "Rabbit" -> bindingDialog.rbRabbit
                "Cat" -> bindingDialog.rbCat
                "Bird" -> bindingDialog.rbBird
                else -> null
            }

            radioButton?.isChecked = selectedOptions[option] ?: false
        }

        MaterialAlertDialogBuilder(requireContext())
            .setTitle(resources.getString(R.string.title_dialog_select_pet_type))
            .setView(bindingDialog.root)
            .setMessage(resources.getString(R.string.message_dialog_select_pet_type))
            .setNeutralButton(resources.getString(R.string.btn_reset_dialog)) { _, _ ->
                petViewModel.fetchPetList("")
            }
            .setPositiveButton(resources.getString(R.string.btn_acept_dialog)) { _, _ ->
                selectedPetType = getSelectedPetType(options)
                when (selectedPetType) {
                    "Dog" -> petViewModel.fetchPetList(DOG)
                    "Rabbit" -> petViewModel.fetchPetList(RABBIT)
                    "Cat" -> petViewModel.fetchPetList(CAT)
                    "Bird" -> petViewModel.fetchPetList(BIRD)
                }
            }.show()
    }

    private fun getSelectedPetType(options: Array<String>): String {
        for (option in options) {
            val radioButton = when (option) {
                "Dog" -> bindingDialog.rbDog
                "Rabbit" -> bindingDialog.rbRabbit
                "Cat" -> bindingDialog.rbCat
                "Bird" -> bindingDialog.rbBird
                else -> null
            }

            selectedOptions[option] = radioButton?.isChecked ?: false

            if (radioButton?.isChecked == true) {
                return option
            }
        }
        return ""
    }

}




