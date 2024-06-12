package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.AuthenticationFirebase

class SignInUseCase (
    private val userRepository: UserRepository
) {
    suspend fun execute(credentials: AuthenticationFirebase): String {
        return userRepository.signInUser(credentials)
    }
}