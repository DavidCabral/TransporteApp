package br.com.oxente.transp.repository

import androidx.lifecycle.LiveData
import androidx.paging.DataSource
import androidx.room.*
import br.com.oxente.transp.entity.Curso
import br.com.oxente.transp.entity.Mensalidade
import br.com.oxente.transp.entity.Socio

@Dao
interface MensalidadeDao :BaseDao<Mensalidade>{

    @Query("select * from  Mensalidade")
    fun getList(): List<Mensalidade>


}