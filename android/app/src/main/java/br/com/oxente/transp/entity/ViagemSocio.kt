package br.com.oxente.transp.entity

data class ViagemSocio(
        val cpf: String = "",
        val nome: String = "",
        val desCurso: String = "",
        val desInstituicao: String = "",
        val hora: String = "",
        val obs: Int = 0,
        val dia: Int = 0,
        val mes: Int = 0,
        val ano: Int = 0
)