package com.nati.petadoptapp.data.utils

object FirebaseConstant {
    const val USERS_COLLECTION = "users"
    const val PETS_LIST = "pets"
}

object PetMessages {
    const val SUCCESS_ADD = "Nueva mascota agregada"
    const val ALREADY_EXISTS = "La mascota ya existe en la lista de adopción"
    const val USER_NOT_FOUND = "No existe el usuario con el UID proporcionado"
    const val UPDATE_ERROR = "Error al actualizar la lista de mascotas"
    const val ADD_ERROR = "Error al agregar la nueva mascota"
    const val SUCCESS_DELETE = "Mascota eliminada"
    const val PET_NOT_FOUND = "No se encontró la mascota con el ID proporcionado"
    const val EMPTY_LIST = "La lista de mascotas está vacía"
    const val DELETE_ERROR = "Error al eliminar la mascota"
}

object UserMessages {
    const val SUCCESS_DELETE_USER = "Usuario eliminado exitosamente"
    const val USER_NOT_FOUND = "No existe el usuario en Firestore"
    const val DELETE_ERROR = "Error al eliminar el usuario"
}

object DialogConstant {
    const val RABBIT = "rabbit"
    const val DOG = "dog"
    const val CAT = "cat"
    const val BIRD = "bird"
}

object FirebaseAuthErrors {
    const val MESSAGE_EMAIL_ALREADY_IN_USE = "Puede ser que la dirección de correo electrónico ya está en uso."
    const val MESSAGE_INVALID_LOGIN_CREDENTIALS = "Credenciales de inicio de sesión no válidas."

}