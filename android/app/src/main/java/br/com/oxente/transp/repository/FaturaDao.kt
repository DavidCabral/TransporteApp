package br.com.oxente.transp.repository

import androidx.paging.DataSource
import androidx.room.Dao
import androidx.room.Query
import br.com.oxente.transp.entity.Fatura

@Dao
interface FaturaDao : BaseDao<Fatura> {

    @Query("select * from  fatura where cpf = :cpf")
    fun getList(cpf: String): List<Fatura>

    @Query("select * from  fatura where cpf = :cpf and pagamento is null")
    fun getDebitos(cpf: String): DataSource.Factory<Int, Fatura>


}