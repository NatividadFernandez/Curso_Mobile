package com.nati.petadoptapp.domain.usecase.pet

import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.model.Pet

class GetPetUseCase (
    private val petsRepository: PetsRepository
) {
    suspend fun execute(petId: Int): Pet {
        return petsRepository.getPet(petId)
    }

}