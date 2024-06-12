package com.nati.petadoptapp.di

import android.content.Context
import android.content.SharedPreferences
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.nati.petadoptapp.data.local.SharedPreferencesManager
import com.nati.petadoptapp.data.user.UserDataImpl
import com.nati.petadoptapp.data.user.remote.UserRemoteImpl
import com.nati.petadoptapp.data.pet.PetsDataImpl
import com.nati.petadoptapp.data.pet.remote.PetsRemoteImpl
import com.nati.petadoptapp.data.remote.ApiClient
import com.nati.petadoptapp.data.remote.OAuthService
import com.nati.petadoptapp.data.utils.PreferencesKey
import com.nati.petadoptapp.domain.UserRepository
import com.nati.petadoptapp.domain.PetsRepository
import com.nati.petadoptapp.domain.usecase.user.AddUserUseCase
import com.nati.petadoptapp.domain.usecase.pet.AddPetUseCase
import com.nati.petadoptapp.domain.usecase.user.DeleteUserUseCase
import com.nati.petadoptapp.domain.usecase.user.GetUserUseCase
import com.nati.petadoptapp.domain.usecase.user.GetPetsFromUserUseCase
import com.nati.petadoptapp.domain.usecase.user.SignInUseCase
import com.nati.petadoptapp.domain.usecase.user.SignUpUseCase
import com.nati.petadoptapp.domain.usecase.organization.GetOrganizationUseCase
import com.nati.petadoptapp.domain.usecase.organization.GetOrganizationsUseCase
import com.nati.petadoptapp.domain.usecase.pet.GetPetUseCase
import com.nati.petadoptapp.domain.usecase.pet.GetPetsUseCase
import com.nati.petadoptapp.domain.usecase.user.DeletePetFromUser
import com.nati.petadoptapp.presentation.organization.viewmodel.OrganizationViewModel
import com.nati.petadoptapp.presentation.user.viewmodel.UserViewModel
import com.nati.petadoptapp.presentation.pet.viewmodel.PetViewModel
import org.koin.android.ext.koin.androidContext
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module

val baseModule = module {
    single<OAuthService> { ApiClient.retrofit.create(OAuthService::class.java) }

    single<FirebaseFirestore> {
        FirebaseFirestore.getInstance()
    }

    single<FirebaseAuth> {
        FirebaseAuth.getInstance()
    }

    single<SharedPreferences> {
        androidContext().getSharedPreferences(PreferencesKey.PREF_KEY, Context.MODE_PRIVATE)
    }
}

val petsModule = module {
    factory { SharedPreferencesManager(get()) }
    factory { PetsRemoteImpl(get(), get(), get()) }
    factory { UserRemoteImpl(get(), get(), get()) }

    factory<PetsRepository> { PetsDataImpl(get()) }
    factory<UserRepository> { UserDataImpl(get()) }

    factory { GetPetsUseCase(get()) }
    factory { GetOrganizationsUseCase(get()) }
    factory { GetOrganizationUseCase(get()) }
    factory { GetPetUseCase(get()) }

    factory { GetUserUseCase(get()) }
    factory { GetPetsFromUserUseCase(get()) }
    factory { AddUserUseCase(get()) }
    factory { DeleteUserUseCase(get()) }
    factory { SignUpUseCase(get()) }
    factory { SignInUseCase(get()) }

    factory { AddPetUseCase(get()) }
    factory { DeletePetFromUser(get()) }

    viewModel { PetViewModel(get(), get(), get()) }

    viewModel { OrganizationViewModel(get(), get()) }

    viewModel { UserViewModel(get(), get(), get(), get(), get(), get(), get()) }
}