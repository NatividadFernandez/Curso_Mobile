package com.nati.petadoptapp.model

import androidx.annotation.Keep
import androidx.room.PrimaryKey
import com.google.gson.annotations.SerializedName

data class PetsResponse(
    @SerializedName("animals") val pets: List<Pet>
)

data class PetResponse(
    @SerializedName("animal") val pet: Pet
)

@Keep
data class Pet(
    @PrimaryKey val id: Long,
    @SerializedName("organization_id") val organizationID: String,
    val url: String,
    val type: String,
    val species: String,
    val breeds: Breeds?,
    val age: String,
    val gender: String,
    val size: String,
    val name: String,
    val description: String?,
    val photos: List<Photo>,
    val status: String,
    val contact: Contact?
) : Petbase

@Keep
data class Breeds(
    val primary: String?
)

@Keep
data class Contact(
    val email: String?,
    val phone: String?,
    val address: Address
)

interface Petbase {

}


