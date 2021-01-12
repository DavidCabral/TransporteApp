package br.com.oxente.transp.entity

import androidx.room.Entity
import androidx.room.Index
import java.util.*

@Entity(
        indices = [Index(value = ["cpf"])],
        primaryKeys = ["dia", "mes", "ano", "tipo", "cpf"],
        foreignKeys = [
            androidx.room.ForeignKey(
                    entity = br.com.oxente.transp.entity.Socio::class,
                    parentColumns = kotlin.arrayOf("cpf"),
                    childColumns = kotlin.arrayOf("cpf")
            )
        ]
)
data class Viagem(
        val dia: Int,
        val mes: Int,
        val ano: Int,
        val tipo: Int,
        val cpf: String,
        val data:Date,
        var obs: Int,
        val hora: String,
        val flg: Int = 0
)