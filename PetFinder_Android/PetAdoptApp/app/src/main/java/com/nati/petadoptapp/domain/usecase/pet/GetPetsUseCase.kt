package com.nati.petadoptapp.domain.usecase.pet

import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.model.Pet

class GetPetsUseCase(
    private val petsRepository: PetsRepository
) {
    suspend fun execute(type: String): List<Pet> {
        return petsRepository.getPets(type)
    }
}