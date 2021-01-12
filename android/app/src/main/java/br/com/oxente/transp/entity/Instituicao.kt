package br.com.oxente.transp.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
class Instituicao(
        @PrimaryKey var codInstituicao: Int,
        var desInstituicao: String
)