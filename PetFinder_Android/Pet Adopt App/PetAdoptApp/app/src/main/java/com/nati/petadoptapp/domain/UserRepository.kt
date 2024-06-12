package com.nati.petadoptapp.domain

import com.nati.petadoptapp.model.user.AuthenticationFirebase
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.model.user.UserFireStore

interface UserRepository {

    suspend fun getUser(): UserFireStore

    suspend fun getPetsFromUser(): List<PetFireStore>

    suspend fun createUser(user: UserFireStore): Boolean

    suspend fun deleteUser() : String

    suspend fun signUpUser(credentials: AuthenticationFirebase): String

    suspend fun signInUser(credentials: AuthenticationFirebase): String

    suspend fun deletePetFromUser(pet: PetFireStore) : String
}
