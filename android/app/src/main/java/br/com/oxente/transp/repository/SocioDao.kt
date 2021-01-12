package br.com.oxente.transp.repository

import androidx.paging.DataSource
import androidx.room.Dao
import androidx.room.Query
import br.com.oxente.transp.entity.Socio
import br.com.oxente.transp.entity.SocioItem
import br.com.oxente.transp.entity.SocioSemana

@Dao
interface SocioDao : BaseDao<Socio> {
    @Query("select s.cpf, s.nome,  c.desCurso, i.desInstituicao, s.ativo from  socio s inner join curso c on c.codCurso = s.codCurso inner join instituicao i on i.codInstituicao = s.codInstituicao order by s.nome")
    fun getListSociosItens(): DataSource.Factory<Int, SocioItem>

    @Query("select * from  socio where cpf = :cpf")
    fun getSocio(cpf: String): Socio

    @Query("select count(*) from  socio where cpf = :cpf")
    fun existeCPF(cpf: String): Int

    @Query(
            "select s.cpf, s.nome, c.desCurso, i.desInstituicao, m.desMensalidade, \n" +
                    "m.domIda, m.domVolta, m.segIda, m.segVolta, m.terIda, m.terVolta, m.quaIda, \n" +
                    "m.quaVolta, m.quiIda, m.quiVolta, m.sexIda, m.sexVolta, m.sabIda, m.sabVolta, s.ativo from socio s\n" +
                    "inner join curso c on c.codCurso = s.codCurso \n" +
                    "inner join instituicao i on i.codInstituicao = s.codInstituicao \n" +
                    "inner join mensalidade m on m.codMensalidade = s.codMensalidade \n" +
                    "where s.cpf = :cpf")
    fun getSocioSemana(cpf: String): SocioSemana

    @Query( "select * from socio where tipo = 1 ")
    fun getListAlteracoes(): List<Socio>


}