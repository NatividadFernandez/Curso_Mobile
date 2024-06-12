package com.nati.petadoptapp.presentation.organization.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.nati.petadoptapp.domain.usecase.organization.GetOrganizationUseCase
import com.nati.petadoptapp.domain.usecase.organization.GetOrganizationsUseCase
import com.nati.petadoptapp.model.Organization
import com.nati.petadoptapp.model.ResourceState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

typealias OrganizationListState = ResourceState<List<Organization>>
typealias OrganizationDetailState = ResourceState<Organization>

class OrganizationViewModel(
    private val getOrganizationsUseCase: GetOrganizationsUseCase,
    private val getOrganizationUseCase: GetOrganizationUseCase
) : ViewModel() {

    private val _organizationListLiveData = MutableLiveData<OrganizationListState>()
    val organizationListLiveData: LiveData<OrganizationListState> get() = _organizationListLiveData

    private val _organizationDetailLiveData = MutableLiveData<OrganizationDetailState>()
    val organizationDetailLiveData: LiveData<OrganizationDetailState> get() = _organizationDetailLiveData

    fun fetchOrganizationList() {
        _organizationListLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val organizations = getOrganizationsUseCase.execute()

                withContext(Dispatchers.Main) {
                    _organizationListLiveData.value = ResourceState.Success(organizations)
                    _organizationListLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _organizationListLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _organizationListLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchOrganizationDetail(organizationId: String) {
        _organizationDetailLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val organizations = getOrganizationUseCase.execute(organizationId)

                withContext(Dispatchers.Main) {
                    _organizationDetailLiveData.value = ResourceState.Success(organizations)
                    _organizationDetailLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _organizationDetailLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _organizationDetailLiveData.value = ResourceState.None()
                }
            }
        }
    }

}