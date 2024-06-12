package com.nati.petadoptapp.presentation.user.fragment

import android.os.Bundle
import android.util.Patterns
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import com.google.android.material.snackbar.Snackbar
import com.nati.petadoptapp.R
import com.nati.petadoptapp.databinding.FragmentSignUpBinding
import com.nati.petadoptapp.model.user.AuthenticationFirebase
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.presentation.user.viewmodel.SignUpState
import com.nati.petadoptapp.presentation.user.viewmodel.UserViewModel
import org.koin.androidx.viewmodel.ext.android.activityViewModel

class SignUpFragment : Fragment() {

    private val binding: FragmentSignUpBinding by lazy {
        FragmentSignUpBinding.inflate(layoutInflater)
    }

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
    }

    private fun initViewModel() {

        userViewModel.authSignUpLiveData.observe(viewLifecycleOwner) { state ->
            handleSignUpState(state)
        }

        binding.btnSignUpBack.setOnClickListener {
            findNavController().popBackStack()
        }

        binding.btnSignUp.setOnClickListener {
            val email = binding.etSignUpEmail.text.toString()
            val password = binding.etSignUpPassword.text.toString()
            val name = binding.etSignUpName.text.toString()
            val surnames = binding.etSignUpSurnames.text.toString()

            singUp(email, password, name, surnames)
        }
    }

    private fun singUp(email: String, password: String, name: String, surnames: String) {

        val auth = AuthenticationFirebase(email, password)

        if (!validateForm()) {
            return
        }

        userViewModel.fetchSignUp(auth,name,surnames)
    }

    private fun validateForm(): Boolean {
        var valid = true

        val name = binding.etSignUpName.text.toString()
        if (name.isEmpty()) {
            binding.etSignUpName.error = getString(R.string.required)
            valid = false
        } else {
            binding.etSignUpName.error = null
        }

        val surnames = binding.etSignUpSurnames.text.toString()
        if (surnames.isEmpty()) {
            binding.etSignUpSurnames.error = getString(R.string.required)
            valid = false
        } else {
            binding.etSignUpSurnames.error = null
        }

        val email = binding.etSignUpEmail.text.toString()
        if (email.isEmpty()) {
            binding.etSignUpEmail.error = getString(R.string.required)
            valid = false
        } else if (!email.isEmail()) {
            binding.etSignUpEmail.error = getString(R.string.email_required)
            valid = false
        } else {
            binding.etSignUpEmail.error = null
        }

        val password = binding.etSignUpPassword.text.toString()
        if (password.isEmpty()) {
            binding.etSignUpPassword.error = getString(R.string.required)
            valid = false
        } else if (password.length < 6) {
            binding.etSignUpPassword.error = getString(R.string.password_long_required)
            valid = false
        } else {
            binding.etSignUpPassword.error = null
        }

        return valid
    }

    private fun String.isEmail(): Boolean {
        return Patterns.EMAIL_ADDRESS.matcher(this).matches()
    }

    private fun handleSignUpState(state: SignUpState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbSignUp.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbSignUp.visibility = View.GONE
                Snackbar.make(requireView(),getString(R.string.create_user), Snackbar.LENGTH_SHORT)
                    .show()
                findNavController().navigate(
                    SignUpFragmentDirections.actionSignUpFragmentToSignInFragment()
                )
            }

            is ResourceState.Error -> {
                binding.pbSignUp.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbSignUp.visibility = View.GONE
        }
    }
}