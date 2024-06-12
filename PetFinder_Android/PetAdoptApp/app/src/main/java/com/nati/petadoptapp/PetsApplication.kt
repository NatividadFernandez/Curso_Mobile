package com.nati.petadoptapp

import android.app.Application
import com.nati.petadoptapp.di.baseModule
import com.nati.petadoptapp.di.petsModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class PetsApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        startKoin {
            androidContext(this@PetsApplication)
            modules(baseModule, petsModule).allowOverride(true)
        }

    }
}