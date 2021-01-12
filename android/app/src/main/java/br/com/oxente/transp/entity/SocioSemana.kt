package br.com.oxente.transp.entity

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class SocioSemana(
        val cpf: String = "",
        val nome: String = "",
        val desCurso: String = "",
        val desInstituicao: String = "",
        val desMensalidade: String,
        val ativo: Boolean = false,
        val domIda: Boolean = false,
        val domVolta: Boolean = false,
        val segIda: Boolean = false,
        val segVolta: Boolean = false,
        val terIda: Boolean = false,
        val terVolta: Boolean = false,
        val quaIda: Boolean = false,
        val quaVolta: Boolean = false,
        val quiIda: Boolean = false,
        val quiVolta: Boolean = false,
        val sexIda: Boolean = false,
        val sexVolta: Boolean = false,
        val sabIda: Boolean = false,
        val sabVolta: Boolean = false) : Parcelable