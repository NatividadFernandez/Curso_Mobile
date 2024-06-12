package com.nati.petadoptapp.data.remote

import com.nati.petadoptapp.model.OrganizationResponse
import com.nati.petadoptapp.model.OrganizationsResponse
import com.nati.petadoptapp.model.PetResponse
import com.nati.petadoptapp.model.PetsResponse
import com.nati.petadoptapp.model.TokenResponse
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

interface OAuthService {

    @FormUrlEncoded
    @POST("oauth2/token")
    suspend fun getToken(
        @Field("grant_type") grantType: String,
        @Field("client_id") clientId: String,
        @Field("client_secret") clientSecret: String
    ): TokenResponse

    @GET("animals")
    suspend fun getPets(
        @Header("Authorization") authorization: String,
        @Query("type") type: String = ""
    ): PetsResponse

    @GET("organizations")
    suspend fun getOrganizations(
        @Header("Authorization") authorization: String
    ): OrganizationsResponse

    @GET("animals/{petId}")
    suspend fun getPet(
        @Header("Authorization") authorization: String,
        @Path("petId") petId: Int
    ): PetResponse

    @GET("organizations/{organizationId}")
    suspend fun getOrganization(
        @Header("Authorization") authorization: String,
        @Path("organizationId") organizationId: String
    ): OrganizationResponse

}