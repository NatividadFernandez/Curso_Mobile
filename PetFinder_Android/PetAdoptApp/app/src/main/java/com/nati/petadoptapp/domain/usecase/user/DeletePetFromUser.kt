package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.PetFireStore

class DeletePetFromUser(
    private val userRepository: UserRepository
) {
    suspend fun execute(pet: PetFireStore): String {
        return userRepository.deletePetFromUser(pet)
    }
}

