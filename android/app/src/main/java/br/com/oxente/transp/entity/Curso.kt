package br.com.oxente.transp.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
class Curso(
        @PrimaryKey var codCurso: Int,
        var desCurso: String
)

