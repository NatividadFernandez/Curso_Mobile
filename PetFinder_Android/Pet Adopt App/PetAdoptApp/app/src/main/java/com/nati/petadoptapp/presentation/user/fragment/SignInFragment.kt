package com.nati.petadoptapp.presentation.user.fragment

import android.os.Bundle
import android.util.Patterns
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.addCallback
import androidx.navigation.fragment.findNavController
import com.nati.petadoptapp.R
import com.nati.petadoptapp.databinding.FragmentSignInBinding
import com.nati.petadoptapp.model.user.AuthenticationFirebase
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.presentation.user.viewmodel.SignInState
import com.nati.petadoptapp.presentation.user.viewmodel.UserViewModel
import org.koin.androidx.viewmodel.ext.android.activityViewModel

class SignInFragment : Fragment() {


    private val binding: FragmentSignInBinding by lazy {
        FragmentSignInBinding.inflate(layoutInflater)
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

        requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner) {
            // Bloqueo para que no pueda volver atras
        }

        initViewModel()

        initUI()
    }

    private fun initViewModel() {

        userViewModel.authSignInLiveData.observe(viewLifecycleOwner) { state ->
            handleSignInState(state)
        }
    }

    private fun initUI() {
        binding.btnSignIn.setOnClickListener {
            val email = binding.etSignInEmail.text.toString()
            val password = binding.etSignInPassword.text.toString()
            signIn(email, password)
        }

        binding.btnSignUp.setOnClickListener {
            findNavController().navigate(
                SignInFragmentDirections.actionSignInFragmentToSignUpFragment()
            )
        }
    }

    private fun signIn(email: String, password: String) {
        val auth = AuthenticationFirebase(email, password)

        if (!validateForm()) {
            return
        }

        userViewModel.fetchSignIn(auth)
    }

    private fun validateForm(): Boolean {
        var valid = true

        val email = binding.etSignInEmail.text.toString()
        if (email.isEmpty()) {
            binding.etSignInEmail.error = getString(R.string.required)
            valid = false
        } else if (!email.isEmail()) {
            binding.etSignInEmail.error = getString(R.string.email_required)
            valid = false
        } else {
            binding.etSignInEmail.error = null
        }

        val password = binding.etSignInPassword.text.toString()
        if (password.isEmpty()) {
            binding.etSignInPassword.error = getString(R.string.required)
            valid = false
        }else if (password.length < 6) {
            binding.etSignInPassword.error = getString(R.string.password_long_required_refresh)
            valid = false
        } else {
            binding.etSignInPassword.error = null
        }

        return valid
    }

    private fun String.isEmail(): Boolean {
        return Patterns.EMAIL_ADDRESS.matcher(this).matches()
    }

    private fun handleSignInState(state: SignInState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbSignIn.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbSignIn.visibility = View.GONE
                findNavController().navigate(
                    SignInFragmentDirections.actionSignInFragmentToPetListFragment()
                )
            }

            is ResourceState.Error -> {
                binding.pbSignIn.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbSignIn.visibility = View.GONE
        }
    }


}