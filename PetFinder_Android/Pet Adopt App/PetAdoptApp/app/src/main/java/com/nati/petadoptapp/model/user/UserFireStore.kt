package com.nati.petadoptapp.model.user

import com.nati.petadoptapp.model.Petbase

data class UserFireStore(
    val uid: String = "",
    val email: String = "",
    val name: String = "",
    val surnames: String = "",
    val pets: List<PetFireStore> = listOf()
)

data class PetFireStore(
    val id: Long = 0,
    val organizationID: String = "",
    val type: String = "",
    val species: String = "",
    val breeds: String? = "",
    val age: String = "",
    val gender: String = "",
    val size: String = "",
    val name: String = "",
    val description: String? = "",
    val photos: String = "",
    val email: String? = "",
    val phone: String? = "",
    val address: String? = ""
) : Petbase
