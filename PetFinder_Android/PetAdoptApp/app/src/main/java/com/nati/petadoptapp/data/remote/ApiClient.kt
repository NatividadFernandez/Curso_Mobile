package com.nati.petadoptapp.data.remote

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object ApiClient {

    val retrofit: Retrofit =
        Retrofit.Builder().baseUrl("https://api.petfinder.com/v2/")
            .addConverterFactory(GsonConverterFactory.create()).build()
}