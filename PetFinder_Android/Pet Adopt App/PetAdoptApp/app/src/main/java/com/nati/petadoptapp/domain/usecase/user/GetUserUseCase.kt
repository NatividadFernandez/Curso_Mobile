package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.model.user.UserFireStore

class GetUserUseCase(
    private val userRepository: UserRepository
) {
    suspend fun execute(): UserFireStore {
        return userRepository.getUser()
    }
}