package com.nati.petadoptapp.presentation.pet.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.nati.petadoptapp.domain.usecase.pet.GetPetUseCase
import com.nati.petadoptapp.domain.usecase.pet.GetPetsUseCase
import com.nati.petadoptapp.domain.usecase.pet.AddPetUseCase
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.model.user.PetFireStore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

typealias PetListState = ResourceState<List<Pet>>
typealias PetDetailState = ResourceState<Pet>
typealias AddPetState = ResourceState<String>

class PetViewModel(
    private val getPetsUseCase: GetPetsUseCase,
    private val getPetUseCase: GetPetUseCase,
    private val addPetUseCase: AddPetUseCase
) : ViewModel() {

    private val _petListLiveData = MutableLiveData<PetListState>()
    val petLiveData: LiveData<PetListState> get() = _petListLiveData

    private val _petDetailLiveData = MutableLiveData<PetDetailState>()
    val petDetailLiveData: LiveData<PetDetailState> get() = _petDetailLiveData

    private val _addPetLiveData = MutableLiveData<AddPetState>()
    val addPetLiveData: LiveData<AddPetState> get() = _addPetLiveData

    fun fetchPetList(type: String) {
        _petListLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val pets = getPetsUseCase.execute(type)
                withContext(Dispatchers.Main) {
                    _petListLiveData.value = ResourceState.Success(pets)
                    _petListLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _petListLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _petListLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchPetDetail(petId: Int) {
        _petDetailLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val pet = getPetUseCase.execute(petId)
                withContext(Dispatchers.Main) {
                    _petDetailLiveData.value = ResourceState.Success(pet)
                    _petDetailLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _petDetailLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _petDetailLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchAddPet(pet: PetFireStore) {
        _addPetLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val result = addPetUseCase.execute(pet)

                withContext(Dispatchers.Main) {
                    _addPetLiveData.value = ResourceState.Success(result)
                    _addPetLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _addPetLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _addPetLiveData.value = ResourceState.None()
                }
            }
        }
    }



}