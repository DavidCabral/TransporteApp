package br.com.oxente.transp.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import br.com.oxente.transp.entity.Socio
import br.com.oxente.transp.entity.Viagem
import br.com.oxente.transp.repository.AppDataBase

class SocioViewModel(application: Application) : AndroidViewModel(application) {
    private val appDatabase: AppDataBase = AppDataBase.getInstance(application)
    suspend fun inserirSocio(socio: Socio) = appDatabase.inserirSocio(socio)
    fun socioListItem() = appDatabase.socioList()
    fun viagemList(dia: Int, mes: Int, ano: Int, tipo: Int) = appDatabase.viagemList(dia, mes, ano, tipo)
    fun listMensalidades() = appDatabase.listMensalidade()
    fun listCurso() = appDatabase.listCurso()
    fun listInstituicao() = appDatabase.listInstituicao()
    fun getSocio(cpf: String) = appDatabase.getSocio(cpf)
    fun getSocioSemana(cpf: String) = appDatabase.getSocioSemana(cpf)
    fun existeCPF(cpf: String) = appDatabase.existeCPF(cpf)
    fun getViagem(dia: Int, mes: Int, ano: Int, cpf: String, tipo: Int) = appDatabase.getViagem(dia, mes, ano, cpf, tipo)
    fun inserirViagem(viagem: Viagem) = appDatabase.inserirViagem(viagem)
    fun removerViagem(viagem: Viagem) = appDatabase.removerViagem(viagem)
    fun debitos(cpf: String) = appDatabase.getDebitos(cpf)

}