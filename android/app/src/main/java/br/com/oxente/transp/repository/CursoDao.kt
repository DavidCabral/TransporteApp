package br.com.oxente.transp.repository

import androidx.room.Dao
import androidx.room.Query
import br.com.oxente.transp.entity.Curso

@Dao
interface CursoDao: BaseDao<Curso> {

    @Query("select * from  Curso")
    fun getList(): List<Curso>


}