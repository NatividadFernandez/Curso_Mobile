package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.UserFireStore

class AddUserUseCase(
    private val userRepository: UserRepository
) {
    suspend fun execute(user: UserFireStore): Boolean{
        return userRepository.createUser(user)
    }
}