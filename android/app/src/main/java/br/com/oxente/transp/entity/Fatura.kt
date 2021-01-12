package br.com.oxente.transp.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*

@Entity
class Fatura(
        @PrimaryKey val fatura: Int,
        val cpf: String,
        val valor: Double,
        val mes: Int,
        val ano: Int,
        val vencimento: Date,
        val pagamento: Date? = null
)