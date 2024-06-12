package com.nati.petadoptapp.domain

import com.nati.petadoptapp.model.Organization
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.PetResponse
import com.nati.petadoptapp.model.PetsResponse
import com.nati.petadoptapp.model.user.PetFireStore
import retrofit2.Response

interface PetsRepository {

    suspend fun getPets(type: String): List<Pet>

    suspend fun getPet(petId: Int): Pet

    suspend fun getOrganizations(): List<Organization>

    suspend fun getOrganization(organizationId: String): Organization

    suspend fun addPet(pet: PetFireStore): String

}