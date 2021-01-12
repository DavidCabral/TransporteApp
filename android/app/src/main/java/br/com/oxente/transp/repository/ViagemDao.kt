package br.com.oxente.transp.repository

import androidx.paging.DataSource
import androidx.room.Dao
import androidx.room.Query
import br.com.oxente.transp.entity.Viagem
import br.com.oxente.transp.entity.ViagemSocio

@Dao
interface ViagemDao : BaseDao<Viagem> {

    @Query("select s.cpf, s.nome,  c.desCurso, i.desInstituicao, v.hora, v.obs, v.dia, v.mes, v.ano from  socio s inner join curso c on c.codCurso = s.codCurso inner join instituicao i on i.codInstituicao = s.codInstituicao inner join viagem v on v.cpf = s.cpf where v.cpf = :cpf and v.ano = :ano and v.tipo=:tipo and  v.mes = :mes and v.dia=:dia")
    fun getViagem(dia: Int, mes: Int, ano: Int, cpf: String, tipo: Int): ViagemSocio?

    @Query("select s.cpf, s.nome,  c.desCurso, i.desInstituicao, v.hora, v.obs, v.dia, v.mes, v.ano from  socio s inner join curso c on c.codCurso = s.codCurso inner join instituicao i on i.codInstituicao = s.codInstituicao inner join viagem v on v.cpf = s.cpf where v.dia = :dia and v.mes = :mes and v.ano=:ano and v.tipo = :tipo order by v.data desc")
    fun getListSociosViagem(dia: Int, mes: Int, ano: Int, tipo: Int): DataSource.Factory<Int, ViagemSocio>

    @Query("select * from viagem where flg = 1 ")
    fun getViagens(): List<Viagem>

}