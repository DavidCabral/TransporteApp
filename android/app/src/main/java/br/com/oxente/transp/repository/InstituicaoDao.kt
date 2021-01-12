package br.com.oxente.transp.repository

import androidx.room.*
import br.com.oxente.transp.entity.Curso
import br.com.oxente.transp.entity.Instituicao

@Dao
interface InstituicaoDao : BaseDao<Instituicao> {

    @Query("select * from  Instituicao")
    fun getList(): List<Instituicao>


}