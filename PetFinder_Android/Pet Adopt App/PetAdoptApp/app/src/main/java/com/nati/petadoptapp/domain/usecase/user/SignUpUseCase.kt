package com.nati.petadoptapp.domain.usecase.user

import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.AuthenticationFirebase

class SignUpUseCase(
    private val userRepository: UserRepository
) {
    suspend fun execute(credentials: AuthenticationFirebase): String {
        return userRepository.signUpUser(credentials)
    }


}