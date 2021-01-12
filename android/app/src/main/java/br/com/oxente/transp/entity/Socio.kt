package br.com.oxente.transp.entity

import android.os.Parcelable
import androidx.room.*
import kotlinx.android.parcel.Parcelize
import java.util.*

@Parcelize
@Entity(indices = [
    Index(value = ["cpf"]),
    Index(value = ["codCurso"]),
    Index(value = ["codMensalidade"]),
    Index(value = ["codInstituicao"])],
        foreignKeys = [
            ForeignKey(
                    entity = Curso::class,
                    parentColumns = arrayOf("codCurso"),
                    childColumns = arrayOf("codCurso")
            ),
            ForeignKey(
                    entity = Mensalidade::class,
                    parentColumns = arrayOf("codMensalidade"),
                    childColumns = arrayOf("codMensalidade")
            ),
            ForeignKey(
                    entity = Instituicao::class,
                    parentColumns = arrayOf("codInstituicao"),
                    childColumns = arrayOf("codInstituicao")
            )
        ]
)
class Socio(
        @PrimaryKey var cpf: String = "",
        var nome: String = "",
        var endereco: String = "",
        var fone: String = "",
        var fone2: String = "",
        var email: String = "",
        var dataCadastramento: Date = Date(),
        var ativo: Boolean = true,
        var mes: Int = 0,
        var ano: Int = 0,
        var codCurso: Int = 0,
        var codMensalidade: Int = 0,
        var codInstituicao: Int = 0,
        var dataValidade: Date? = Date(),
        var tipo: Int = 0
) : Parcelable