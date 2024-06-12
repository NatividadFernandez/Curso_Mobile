package com.nati.petadoptapp.data.pet.remote


import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import com.nati.petadoptapp.data.local.SharedPreferencesManager
import com.nati.petadoptapp.data.utils.ApiConstant
import com.nati.petadoptapp.data.remote.OAuthService
import com.nati.petadoptapp.data.utils.FirebaseConstant.PETS_LIST
import com.nati.petadoptapp.data.utils.FirebaseConstant.USERS_COLLECTION
import com.nati.petadoptapp.data.utils.PetMessages
import com.nati.petadoptapp.model.Organization
import com.nati.petadoptapp.model.Pet
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.model.user.UserFireStore
import kotlinx.coroutines.tasks.await

class PetsRemoteImpl(
    private val oAuthService: OAuthService,
    private val db: FirebaseFirestore,
    private val sharedPreferencesManager: SharedPreferencesManager
) {
    // API
    private suspend fun getNewToken(): String {
        val response = oAuthService.getToken(
            grantType = "client_credentials",
            clientId = ApiConstant.CLIENT_ID,
            clientSecret = ApiConstant.SECRET_ID
        )
        return "Bearer ${response.accessToken}"
    }

    suspend fun getPets(type: String): List<Pet> {
        return oAuthService.getPets(getNewToken(), type).pets
    }

    suspend fun getPet(petId: Int): Pet {
        return oAuthService.getPet(getNewToken(), petId).pet
    }

    suspend fun getOrganizations(): List<Organization> {
        return oAuthService.getOrganizations(getNewToken()).organizations
    }

    suspend fun getOrganization(organizationId: String): Organization {
        return oAuthService.getOrganization(getNewToken(), organizationId).organization
    }

    // FIRESTORE
    suspend fun addPet(pet: PetFireStore): String {
        return try {
            val userId = sharedPreferencesManager.getSharedPrefences()

            val userDocRef = db.collection(USERS_COLLECTION).document(userId)
            val documentSnapshot = userDocRef.get().await()

            if (documentSnapshot.exists()) {
                val petList = documentSnapshot.toObject(UserFireStore::class.java)?.pets

                if (petList != null && !petList.contains(pet)) {
                    try {
                        userDocRef.update(PETS_LIST, FieldValue.arrayUnion(pet)).await()
                        PetMessages.SUCCESS_ADD
                    } catch (updateException: Exception) {
                        PetMessages.UPDATE_ERROR + ": ${updateException.message}"
                    }
                } else {
                    PetMessages.ALREADY_EXISTS
                }
            } else {
                PetMessages.USER_NOT_FOUND
            }
        } catch (e: Exception) {
            PetMessages.ADD_ERROR + ": ${e.message}"
        }
    }

}