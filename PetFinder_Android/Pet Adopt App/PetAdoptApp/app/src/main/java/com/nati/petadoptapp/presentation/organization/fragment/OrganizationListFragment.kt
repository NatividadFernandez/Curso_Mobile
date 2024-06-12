package com.nati.petadoptapp.presentation.organization.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.nati.petadoptapp.databinding.FragmentOrganizationListBinding
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.presentation.organization.adapter.OrganizationListAdapter
import com.nati.petadoptapp.presentation.organization.viewmodel.OrganizationListState
import com.nati.petadoptapp.presentation.organization.viewmodel.OrganizationViewModel
import org.koin.androidx.viewmodel.ext.android.activityViewModel

class OrganizationListFragment : Fragment() {

    private val binding: FragmentOrganizationListBinding by lazy {
        FragmentOrganizationListBinding.inflate(layoutInflater)
    }

    private val organizationListAdapter = OrganizationListAdapter()

    private val organizationViewModel: OrganizationViewModel by activityViewModel()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        initViewModel()
        initUI()
    }

    private fun initViewModel() {

        organizationViewModel.organizationListLiveData.observe(viewLifecycleOwner) { state ->
            handleOrganizationState(state)
        }
        organizationViewModel.fetchOrganizationList()

    }

    private fun handleOrganizationState(state: OrganizationListState) {
        when (state) {
            is ResourceState.Loading -> {
                binding.pbOrganizationList.visibility = View.VISIBLE
            }

            is ResourceState.Success -> {
                binding.pbOrganizationList.visibility = View.GONE
                organizationListAdapter.submitList(state.result)

            }

            is ResourceState.Error -> {
                binding.pbOrganizationList.visibility = View.GONE
                Toast.makeText(requireContext(), "Error ${state.error}", Toast.LENGTH_SHORT).show()
            }

            else -> binding.pbOrganizationList.visibility = View.GONE
        }
    }

    private fun initUI() {
        binding.rvOrganizationList.adapter = organizationListAdapter
        binding.rvOrganizationList.layoutManager = LinearLayoutManager(requireContext())

        organizationListAdapter.onClickListener = { org ->
            findNavController().navigate(
                OrganizationListFragmentDirections.actionOrganizationListFragmentToOrganizationDetailFragment(org.id)
            )
        }

    }
}