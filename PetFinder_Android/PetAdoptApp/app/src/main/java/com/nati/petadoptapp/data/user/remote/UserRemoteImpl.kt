package com.nati.petadoptapp.data.user.remote

import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.SetOptions
import com.nati.petadoptapp.data.local.SharedPreferencesManager
import com.nati.petadoptapp.data.utils.FirebaseConstant.PETS_LIST
import com.nati.petadoptapp.data.utils.FirebaseConstant.USERS_COLLECTION
import com.nati.petadoptapp.data.utils.PetMessages
import com.nati.petadoptapp.data.utils.UserMessages
import com.nati.petadoptapp.model.user.AuthenticationFirebase
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.model.user.UserFireStore
import kotlinx.coroutines.tasks.await

class UserRemoteImpl(
    private val auth: FirebaseAuth,
    private val db: FirebaseFirestore,
    private val sharedPreferencesManager: SharedPreferencesManager
) {

    suspend fun signInPerson(credentials: AuthenticationFirebase): String {
        return try {
            var userUID = ""
            auth.signInWithEmailAndPassword(credentials.email, credentials.password)
                .addOnSuccessListener {
                    userUID = it.user?.uid.toString()
                    sharedPreferencesManager.saveSharedPreferences(userUID)
                }
                .await()

            userUID
        }  catch (e: Exception) {
            ""
        }
    }

    suspend fun signUpPerson(credentials: AuthenticationFirebase): String {
        return try {
            var userUID = ""
            auth.createUserWithEmailAndPassword(credentials.email, credentials.password)
                .addOnSuccessListener { userUID = it.user?.uid ?: "" }
                .await()
            userUID
        } catch (e: Exception) {
            ""
        }
    }

    suspend fun createUser(user: UserFireStore): Boolean {
        return try {
            var isSuccessful = false
            db.collection(USERS_COLLECTION)
                .document(user.uid)
                .set(user, SetOptions.merge())
                .addOnCompleteListener { isSuccessful = it.isSuccessful }
                .await()
            isSuccessful
        } catch (e: Exception) {
            false
        }

    }

    suspend fun getUser(): UserFireStore {
        return try {
            val uid = sharedPreferencesManager.getSharedPrefences()

            val documentReference = db.collection(USERS_COLLECTION).document(uid)
            val documentSnapshot: DocumentSnapshot = documentReference.get().await()

            if (documentSnapshot.exists()) {
                val user = documentSnapshot.toObject(UserFireStore::class.java)!!
                user
            } else {
                UserFireStore()
            }
        } catch (e: Exception) {
            UserFireStore()
        }
    }

    suspend fun deleteUser(): String {
        return try {
            val uid = sharedPreferencesManager.getSharedPrefences()

            auth.currentUser?.delete()?.await()

            val db = FirebaseFirestore.getInstance()
            val userDocRef = db.collection(USERS_COLLECTION).document(uid)

            val documentSnapshot = userDocRef.get().await()
            if (documentSnapshot.exists()) {
                userDocRef.delete().await()
                sharedPreferencesManager.cleanSharedPreferences()
                UserMessages.SUCCESS_DELETE_USER
            } else {
                UserMessages.USER_NOT_FOUND
            }
        } catch (e: Exception) {
            UserMessages.DELETE_ERROR + ": ${e.message}"
        }
    }

    suspend fun getPetsFromUser(): List<PetFireStore> {
        try {
            val uid = sharedPreferencesManager.getSharedPrefences()
            val userDocRef = db.collection(USERS_COLLECTION).document(uid)

            val documentSnapshot = userDocRef.get().await()

            if (documentSnapshot.exists()) {
                val petList = documentSnapshot.toObject(UserFireStore::class.java)?.pets

                return petList ?: emptyList()
            } else {
                return emptyList()
            }
        } catch (e: Exception) {
            return emptyList()
        }
    }

    suspend fun deletePetFromUser(pet: PetFireStore): String {
        return try {
            val userId = sharedPreferencesManager.getSharedPrefences()
            val userDocRef = db.collection(USERS_COLLECTION).document(userId)
            val documentSnapshot = userDocRef.get().await()

            if (documentSnapshot.exists()) {
                val petList = documentSnapshot.toObject(UserFireStore::class.java)?.pets

                if (petList != null) {
                    val petToDelete = petList.find { it.id == pet.id }

                    if (petToDelete != null) {
                        userDocRef.update(PETS_LIST, FieldValue.arrayRemove(petToDelete))
                            .await()
                        PetMessages.SUCCESS_DELETE
                    } else {
                        PetMessages.PET_NOT_FOUND
                    }
                } else {
                    PetMessages.EMPTY_LIST
                }
            } else {
                PetMessages.USER_NOT_FOUND
            }
        } catch (e: Exception) {
            PetMessages.DELETE_ERROR + ": ${e.message}"
        }
    }
}