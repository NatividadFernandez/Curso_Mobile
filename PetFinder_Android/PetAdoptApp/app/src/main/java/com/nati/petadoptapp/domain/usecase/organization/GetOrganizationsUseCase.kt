package com.nati.petadoptapp.domain.usecase.organization

import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.model.Organization

class GetOrganizationsUseCase(
    private val petsRepository: PetsRepository
) {
    suspend fun execute(): List<Organization> {
        return petsRepository.getOrganizations()
    }
}