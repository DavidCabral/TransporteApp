package br.com.oxente.transp.repository

import android.content.Context
import androidx.paging.LivePagedListBuilder
import androidx.paging.PagedList
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import androidx.sqlite.db.SupportSQLiteDatabase
import br.com.oxente.transp.repository.converter.DateConverter
import br.com.oxente.transp.entity.*
import br.com.oxente.transp.util.ioThread
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.*

@Database(
        entities = [
            (Socio::class),
            (Instituicao::class),
            (Curso::class),
            (Mensalidade::class),
            (Viagem::class),
            (Fatura::class)
        ], version = 1, exportSchema = false)
@TypeConverters(DateConverter::class)
abstract class AppDataBase : RoomDatabase() {

    abstract fun socioDAO(): SocioDao
    abstract fun cursoDAO(): CursoDao
    abstract fun mensalidadeDAO(): MensalidadeDao
    abstract fun instituicaoDAO(): InstituicaoDao
    abstract fun viagemDAO(): ViagemDao
    abstract fun faturaDAO(): FaturaDao


    suspend fun inserirSocio(socio: Socio) {
        withContext(Dispatchers.Default) {
            socioDAO().insert(socio)
        }
    }

    fun inserirFatura(fatura: Fatura) {
        faturaDAO().insert(fatura)
    }

    fun inserirCurso(curso: List<Curso>) {
        cursoDAO().insert(curso)
    }

    fun inserirMensalidade(mensalidade: List<Mensalidade>) {
        mensalidadeDAO().insert(mensalidade)
    }

    fun inserirInstituicao(instituicao: List<Instituicao>) {
        instituicaoDAO().insert(instituicao)
    }

    companion object {
        private const val PAGE_SIZE = 10
        private const val ENABLE_PLACEHOLDERS = true
        @Volatile
        private var INSTANCE: AppDataBase? = null

        fun getInstance(context: Context): AppDataBase = INSTANCE ?: synchronized(this) {
            INSTANCE ?: buildDatabase(context).also { INSTANCE = it }
        }

        private fun buildDatabase(context: Context) = Room.databaseBuilder(context, AppDataBase::class.java, "db.db")
                .addCallback(object : Callback() {
                    override fun onCreate(db: SupportSQLiteDatabase) {
                        super.onCreate(db)
                        ioThread {
                            getInstance(context).cursoDAO().insert(Curso(0, "NÃO INFORMADO"))
                            getInstance(context).instituicaoDAO().insert(Instituicao(0, "NÃO INFORMADO"))
                            getInstance(context).mensalidadeDAO().insert(Mensalidade(0, "NÃO INFORMADA"))
                        }
                    }
                })
                .build()
    }


    fun socioList() = LivePagedListBuilder(socioDAO().getListSociosItens(), PagedList.Config.Builder()
            .setPageSize(PAGE_SIZE)
            .setEnablePlaceholders(ENABLE_PLACEHOLDERS)
            .build()).build()

    fun viagemList(dia: Int, mes: Int, ano: Int, tipo: Int) = LivePagedListBuilder(viagemDAO().getListSociosViagem(dia, mes, ano, tipo), PagedList.Config.Builder()
            .setPageSize(PAGE_SIZE)
            .setEnablePlaceholders(ENABLE_PLACEHOLDERS)
            .build()).build()

    fun getDebitos(cpf: String) = LivePagedListBuilder(faturaDAO().getDebitos(cpf), PagedList.Config.Builder()
            .setPageSize(PAGE_SIZE)
            .setEnablePlaceholders(ENABLE_PLACEHOLDERS)
            .build()).build()

    fun getViagem(dia: Int, mes: Int, ano: Int, cpf: String, tipo: Int) = viagemDAO().getViagem(dia, mes, ano, cpf, tipo)
    fun listMensalidade() = mensalidadeDAO().getList()
    fun listCurso() = cursoDAO().getList()
    fun listInstituicao() = instituicaoDAO().getList()
    fun getSocio(cpf: String) = socioDAO().getSocio(cpf)
    fun getSocioSemana(cpf: String) = socioDAO().getSocioSemana(cpf)
    fun existeCPF(cpf: String) = socioDAO().existeCPF(cpf)
    fun inserirViagem(viagem: Viagem) = viagemDAO().insert(viagem)
    fun removerViagem(viagem: Viagem) = viagemDAO().delete(viagem)
    fun getViagens() = viagemDAO().getViagens()
    fun getListAlteracoes() = socioDAO().getListAlteracoes()

    //tamanho da foto altura 85  - largura 71

}