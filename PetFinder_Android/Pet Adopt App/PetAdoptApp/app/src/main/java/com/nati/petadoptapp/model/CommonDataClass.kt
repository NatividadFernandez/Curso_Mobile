package com.nati.petadoptapp.model

import androidx.annotation.Keep

@Keep
data class Address(
    val address1: String,
    val address2: String,
    val city: String?,
    val state: String,
    val postcode: String,
    val country: String
)

@Keep
data class Photo(
    val small: String,
    val medium: String,
    val large: String,
    val full: String
)
