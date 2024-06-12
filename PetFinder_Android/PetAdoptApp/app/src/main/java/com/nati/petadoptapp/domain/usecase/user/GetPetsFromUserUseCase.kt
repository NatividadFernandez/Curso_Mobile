package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.PetFireStore

class GetPetsFromUserUseCase (
    private val userRepository: UserRepository
) {
    suspend fun execute(): List<PetFireStore> {
        return userRepository.getPetsFromUser()
    }
}