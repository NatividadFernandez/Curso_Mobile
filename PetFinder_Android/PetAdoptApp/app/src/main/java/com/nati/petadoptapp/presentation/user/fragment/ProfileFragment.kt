package com.nati.petadoptapp.presentation.user.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.PopupMenu
import android.widget.Toast
import androidx.annotation.MenuRes
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.GridLayoutManager
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.nati.petadoptapp.R
import com.nati.petadoptapp.databinding.FragmentProfileBinding
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.model.user.UserFireStore
import com.nati.petadoptapp.presentation.pet.adapter.PetListAdapter
import com.nati.petadoptapp.presentation.user.viewmodel.DeletePetState
import com.nati.petadoptapp.presentation.user.viewmodel.DeleteState
import com.nati.petadoptapp.presentation.user.viewmodel.GetPetsState
import com.nati.petadoptapp.presentation.user.viewmodel.ProfileState
import com.nati.petadoptapp.presentation.user.viewmodel.UserViewModel
import org.koin.androidx.viewmodel.ext.android.activityViewModel

class ProfileFragment : Fragment() {

    private val binding: FragmentProfileBinding by lazy {
        FragmentProfileBinding.inflate(layoutInflater)
    }

    private val petListAdapter = PetListAdapter()

    private val userViewModel: UserViewModel by activityViewModel()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        initViewModel()

        initAdapter()
    }

    private fun initViewModel() {

        userViewModel.profileLiveData.observe(viewLifecycleOwner) { state ->
            handleProfileState(state)
        }

        userViewModel.deleteUserLiveData.observe(viewLifecycleOwner) { state ->
            handleDeleteUserState(state)
        }

        userViewModel.getPetsLiveData.observe(viewLifecycleOwner) { state ->
            handleGetPetsState(state)
        }

        userViewModel.deletePetLiveData.observe(viewLifecycleOwner) { state ->
            handleDeletePetState(state)
        }

    }

    private fun initAdapter() {
        binding.rvProfilePetList.adapter = petListAdapter
        binding.rvProfilePetList.layoutManager = GridLayoutManager(requireContext(), 2)

        userViewModel.fetchGetUser()
    }

    @SuppressLint("SetTextI18n")
    private fun initUI(user: UserFireStore) {
        binding.tvProfileNameSurname.text = "${user.name} ${user.surnames}"
        binding.tvProfileEmail.text = user.email

        userViewModel.fetchGetPetsList()

        petListAdapter.onClickListener = { pet ->
            if (pet is PetFireStore) {
                findNavController().navigate(
                    ProfileFragmentDirections.actionProfileFragmentToPetDetailFragment(pet.id.toInt())
                )
            }
        }

        petListAdapter.onLongClickListener = { pet ->
            if (pet is PetFireStore) {
                deletePetAlertDialog(pet)
            }
        }

        binding.btnProfileMenu.setOnClickListener { v: View ->
            showMenu(v, R.menu.menu_profile)
        }

    }

    private fun handleProfileState(state: ProfileState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbProfile.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbProfile.visibility = View.GONE
                initUI(state.result)
            }

            is ResourceState.Error -> {
                binding.pbProfile.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbProfile.visibility = View.GONE
        }
    }

    private fun handleDeleteUserState(state: DeleteState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbProfile.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbProfile.visibility = View.GONE
                Snackbar.make(requireView(), state.result, Snackbar.LENGTH_SHORT)
                    .show()
            }

            is ResourceState.Error -> {
                binding.pbProfile.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbProfile.visibility = View.GONE
        }
    }

    private fun handleGetPetsState(state: GetPetsState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbProfile.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbProfile.visibility = View.GONE
                petListAdapter.submitList(state.result)
            }

            is ResourceState.Error -> {
                binding.pbProfile.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbProfile.visibility = View.GONE
        }
    }

    private fun handleDeletePetState(state: DeletePetState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbProfile.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbProfile.visibility = View.GONE
                Snackbar.make(requireView(), state.result, Snackbar.LENGTH_SHORT)
                    .show()
                userViewModel.fetchGetPetsList()
            }

            is ResourceState.Error -> {
                binding.pbProfile.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbProfile.visibility = View.GONE
        }
    }

    private fun showMenu(v: View, @MenuRes menuRes: Int) {
        val popup = PopupMenu(requireContext(), v)
        popup.menuInflater.inflate(menuRes, popup.menu)

        popup.setOnMenuItemClickListener { menuItem: MenuItem ->

            when (menuItem.itemId) {
                R.id.btn_profile_remove_user -> {
                    deleteUserAlertDialog()
                    true
                }

                R.id.btn_profile_close_session -> {
                    // Por ahorrar codigo
                    val auth = Firebase.auth
                    auth.signOut()

                    // FragmentManager.POP_BACK_STACK_INCLUSIVE
                    findNavController().popBackStack(R.id.signInFragment, false)

                    true
                }
                else -> false
            }
        }
        popup.setOnDismissListener {

        }

        popup.show()
    }

    private fun deletePetAlertDialog(pet: PetFireStore) {
        MaterialAlertDialogBuilder(requireContext())
            .setTitle(resources.getString(R.string.title_dialog))
            .setMessage(resources.getString(R.string.message_dialog))
            .setNegativeButton(resources.getString(R.string.btn_cancel_dialog)) { _, _ ->
            }
            .setPositiveButton(resources.getString(R.string.btn_acept_dialog)) { _, _ ->
                userViewModel.fetchDeletePetFromUser(pet)
            }
            .show()
    }

    private fun deleteUserAlertDialog() {
        MaterialAlertDialogBuilder(requireContext())
            .setTitle(resources.getString(R.string.title_user_dialog))
            .setMessage(resources.getString(R.string.message_user_dialog))
            .setNegativeButton(resources.getString(R.string.btn_cancel_dialog)) { _, _ ->
            }
            .setPositiveButton(resources.getString(R.string.btn_acept_dialog)) { _, _ ->
                userViewModel.fetchDeleteUser()
                findNavController().navigate(ProfileFragmentDirections.actionProfileFragmentToSignInFragment())
            }
            .show()
    }


}