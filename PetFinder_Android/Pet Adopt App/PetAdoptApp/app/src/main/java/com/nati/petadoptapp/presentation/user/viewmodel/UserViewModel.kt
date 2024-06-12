package com.nati.petadoptapp.presentation.user.viewmodel

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.nati.petadoptapp.data.utils.FirebaseAuthErrors
import com.nati.petadoptapp.data.utils.FirebaseAuthErrors.MESSAGE_EMAIL_ALREADY_IN_USE
import com.nati.petadoptapp.domain.usecase.user.AddUserUseCase
import com.nati.petadoptapp.domain.usecase.user.DeletePetFromUser
import com.nati.petadoptapp.domain.usecase.user.DeleteUserUseCase
import com.nati.petadoptapp.domain.usecase.user.GetUserUseCase
import com.nati.petadoptapp.domain.usecase.user.GetPetsFromUserUseCase
import com.nati.petadoptapp.domain.usecase.user.SignInUseCase
import com.nati.petadoptapp.domain.usecase.user.SignUpUseCase
import com.nati.petadoptapp.model.user.AuthenticationFirebase
import com.nati.petadoptapp.model.ResourceState
import com.nati.petadoptapp.model.user.PetFireStore
import com.nati.petadoptapp.model.user.UserFireStore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

typealias SignUpState = ResourceState<Boolean>
typealias SignInState = ResourceState<String>
typealias ProfileState = ResourceState<UserFireStore>
typealias DeleteState = ResourceState<String>
typealias GetPetsState = ResourceState<List<PetFireStore>>
typealias DeletePetState = ResourceState<String>

class UserViewModel(
    private val getUserUseCase: GetUserUseCase,
    private val signUpUseCase: SignUpUseCase,
    private val addUserUseCase: AddUserUseCase,
    private val deleteUserUseCase: DeleteUserUseCase,
    private val getPetsFromUserUseCase: GetPetsFromUserUseCase,
    private val deletePetFromUser: DeletePetFromUser,
    private val signInUseCase: SignInUseCase
) : ViewModel() {

    private val _authSignUpLiveData = MutableLiveData<SignUpState>()
    val authSignUpLiveData: LiveData<SignUpState> get() = _authSignUpLiveData

    private val _authSignInLiveData = MutableLiveData<SignInState>()
    val authSignInLiveData: LiveData<SignInState> get() = _authSignInLiveData

    private val _profileLiveData = MutableLiveData<ProfileState>()
    val profileLiveData: LiveData<ProfileState> get() = _profileLiveData

    private val _deleteUserLiveData = MutableLiveData<DeleteState>()
    val deleteUserLiveData: LiveData<DeleteState> get() = _deleteUserLiveData

    private val _getPetsLiveData = MutableLiveData<GetPetsState>()
    val getPetsLiveData: LiveData<GetPetsState> get() = _getPetsLiveData

    private val _deletePetLiveData = MutableLiveData<DeletePetState>()
    val deletePetLiveData: LiveData<DeletePetState> get() = _deletePetLiveData

    fun fetchSignUp(credentials: AuthenticationFirebase, name: String, surnames: String) {
        _authSignUpLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val userUID = signUpUseCase.execute(credentials)

                if (userUID.isNotEmpty()) {

                    val user = addUserUseCase.execute(
                        UserFireStore(
                            uid = userUID,
                            name = name,
                            surnames = surnames,
                            email = credentials.email,
                            pets = mutableListOf()
                        )
                    )
                    withContext(Dispatchers.Main) {
                        _authSignUpLiveData.value = ResourceState.Success(user)
                        _authSignUpLiveData.value = ResourceState.None()
                    }
                } else {
                    withContext(Dispatchers.Main) {
                        _authSignUpLiveData.value =
                            ResourceState.Error(MESSAGE_EMAIL_ALREADY_IN_USE)
                        _authSignUpLiveData.value = ResourceState.None()
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _authSignUpLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _authSignUpLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchSignIn(credentials: AuthenticationFirebase) {
        _authSignInLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val userUID = signInUseCase.execute(credentials)

                if (userUID.isNotEmpty()) {

                    withContext(Dispatchers.Main) {
                        _authSignInLiveData.value = ResourceState.Success(userUID)
                        _authSignInLiveData.value = ResourceState.None()
                    }
                } else {
                    withContext(Dispatchers.Main) {
                        _authSignInLiveData.value =
                            ResourceState.Error(FirebaseAuthErrors.MESSAGE_INVALID_LOGIN_CREDENTIALS)
                        _authSignInLiveData.value = ResourceState.None()
                    }
                }

            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _authSignInLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _authSignInLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchGetUser() {
        _profileLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {

                val user = getUserUseCase.execute()

                withContext(Dispatchers.Main) {
                    _profileLiveData.value = ResourceState.Success(user)
                    _profileLiveData.value = ResourceState.None()
                }

            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _profileLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _profileLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchDeleteUser() {
        _deleteUserLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val msg = deleteUserUseCase.execute()
                withContext(Dispatchers.Main) {
                    _deleteUserLiveData.value = ResourceState.Success(msg)
                    _deleteUserLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _deleteUserLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _deleteUserLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchGetPetsList() {
        _getPetsLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val pets = getPetsFromUserUseCase.execute()

                withContext(Dispatchers.Main) {
                    _getPetsLiveData.value = ResourceState.Success(pets)
                    _getPetsLiveData.value = ResourceState.None()
                }

            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _getPetsLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _getPetsLiveData.value = ResourceState.None()
                }
            }
        }
    }

    fun fetchDeletePetFromUser(pet: PetFireStore) {
        _deletePetLiveData.value = ResourceState.Loading()

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val msg = deletePetFromUser.execute(pet)
                withContext(Dispatchers.Main) {
                    _deletePetLiveData.value = ResourceState.Success(msg)
                    _deletePetLiveData.value = ResourceState.None()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _deletePetLiveData.value =
                        ResourceState.Error(e.localizedMessage.orEmpty())
                    _deletePetLiveData.value = ResourceState.None()
                }
            }
        }
    }

}