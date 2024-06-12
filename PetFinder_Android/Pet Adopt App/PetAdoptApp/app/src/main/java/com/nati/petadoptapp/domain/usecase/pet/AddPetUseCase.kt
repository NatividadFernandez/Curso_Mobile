package com.nati.petadoptapp.domain.usecase.pet

import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.PetFireStore

class AddPetUseCase(
    private val petsRepository: PetsRepository
) {
    suspend fun execute(pet: PetFireStore): String {
        return petsRepository.addPet(pet)
    }
}