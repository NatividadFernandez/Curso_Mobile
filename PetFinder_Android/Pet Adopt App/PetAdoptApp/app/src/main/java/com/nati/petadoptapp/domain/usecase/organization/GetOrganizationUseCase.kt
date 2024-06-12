package com.nati.petadoptapp.domain.usecase.organization

import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.model.Organization

class GetOrganizationUseCase(
    private val petsRepository: PetsRepository
) {
    suspend fun execute(organizationId: String): Organization {
        return petsRepository.getOrganization(organizationId)
    }
}