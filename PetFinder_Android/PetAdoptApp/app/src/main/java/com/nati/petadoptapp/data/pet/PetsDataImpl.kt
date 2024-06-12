package com.nati.petadoptapp.data.pet

import com.nati.petadoptapp.data.pet.remote.PetsRemoteImpl
import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.model.Organization
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.user.PetFireStore

class PetsDataImpl(
    private val petRemoteImpl: PetsRemoteImpl
) : PetsRepository {

    override suspend fun getPets(type: String): List<Pet> {
        return petRemoteImpl.getPets(type)
    }

    /*override suspend fun getPets(): List<Pet> {
        return petRemoteImpl.getPets()
    }*/

    override suspend fun getPet(petId: Int): Pet {
        return petRemoteImpl.getPet(petId)
    }

    override suspend fun getOrganizations(): List<Organization> {
        return petRemoteImpl.getOrganizations()
    }

    override suspend fun getOrganization(organizationId: String): Organization {
        return petRemoteImpl.getOrganization(organizationId)
    }

    override suspend fun addPet(pet: PetFireStore): String {
        return petRemoteImpl.addPet(pet)
    }
}