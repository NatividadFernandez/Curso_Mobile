package com.nati.petadoptapp.data.user

import com.nati.petadoptapp.data.user.remote.UserRemoteImpl
import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.model.user.AuthenticationFirebase
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.model.user.UserFireStore

class UserDataImpl(
    private val userRemoteImpl: UserRemoteImpl
) : UserRepository {
    override suspend fun getUser(): UserFireStore {
        return userRemoteImpl.getUser()
    }

    override suspend fun getPetsFromUser(): List<PetFireStore> {
        return userRemoteImpl.getPetsFromUser()
    }

    override suspend fun createUser(user: UserFireStore): Boolean {
        return userRemoteImpl.createUser(user)
    }

    override suspend fun deleteUser() : String {
        return userRemoteImpl.deleteUser()
    }

    override suspend fun signUpUser(credentials: AuthenticationFirebase): String {
        return userRemoteImpl.signUpPerson(credentials)
    }

    override suspend fun signInUser(credentials: AuthenticationFirebase): String {
        return userRemoteImpl.signInPerson(credentials)
    }

    override suspend fun deletePetFromUser(pet: PetFireStore): String {
        return userRemoteImpl.deletePetFromUser(pet)
    }
}