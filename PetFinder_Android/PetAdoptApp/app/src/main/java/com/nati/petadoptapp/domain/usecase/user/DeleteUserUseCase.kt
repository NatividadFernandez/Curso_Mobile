package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.UserFireStore

class DeleteUserUseCase(
    private val userRepository: UserRepository
) {
    suspend fun execute(): String {
        return userRepository.deleteUser()
    }
}