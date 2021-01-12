package br.com.oxente.transp.entity

import androidx.room.Entity
import androidx.room.PrimaryKey


@Entity
class Mensalidade(
        @PrimaryKey var codMensalidade: Int,
        var desMensalidade: String,
        var domIda: Boolean = false,
        var domVolta: Boolean = false,
        var segIda: Boolean = false,
        var segVolta: Boolean = false,
        var terIda: Boolean = false,
        var terVolta: Boolean = false,
        var quaIda: Boolean = false,
        var quaVolta: Boolean = false,
        var quiIda: Boolean = false,
        var quiVolta: Boolean = false,
        var sexIda: Boolean = false,
        var sexVolta: Boolean = false,
        var sabIda: Boolean = false,
        var sabVolta: Boolean = false
)

