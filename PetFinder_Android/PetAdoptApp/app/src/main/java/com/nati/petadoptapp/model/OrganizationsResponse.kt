package com.nati.petadoptapp.model

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

data class OrganizationsResponse(
    @SerializedName("organizations") val organizations: List<Organization>
)

data class OrganizationResponse(
    @SerializedName("organization") val organization: Organization
)

@Keep
data class Organization(
    val id: String,
    val name: String,
    val email: String?,
    val phone: String,
    val address: Address,
    val hours: Hours?,
    val url: String,
    @SerializedName("mission_statement")
    val missionStatement: String?,
    val photos: List<Photo>
)

@Keep
data class Hours(
    val monday: String,
    val tuesday: String,
    val wednesday: String,
    val thursday: String,
    val friday: String,
    val saturday: String ,
    val sunday: String
)
