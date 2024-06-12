package com.nati.petadoptapp.data.local

import android.content.SharedPreferences
import com.nati.petadoptapp.data.utils.PreferencesKey

class SharedPreferencesManager(
    private val sharedPreferences: SharedPreferences
) {

    fun saveSharedPreferences(value: String) {
        sharedPreferences.edit().putString(PreferencesKey.NAME_KEY, value).apply()
    }

    fun getSharedPrefences(): String {
        return sharedPreferences.getString(PreferencesKey.NAME_KEY, "") ?: ""
    }

    fun cleanSharedPreferences(){
        sharedPreferences.edit().clear().apply()
    }

}