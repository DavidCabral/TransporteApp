package br.com.oxente.transp.service

import android.app.IntentService
import android.content.Intent
import androidx.room.Transaction
import br.com.oxente.transp.App
import br.com.oxente.transp.entity.*
import br.com.oxente.transp.repository.AppDataBase
import br.com.oxente.transp.util.Constants
import com.blankj.utilcode.util.PathUtils
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.google.gson.stream.JsonReader
import notificar
import java.io.File
import java.io.FileReader
import java.lang.Exception


class LerArquivoService : IntentService("LerArquivoService") {

    override fun onHandleIntent(intent: Intent?) {
        notificar(titulo = "Atenção", msg = "Lendo Arquivo", progress = true)
        try{
            readerFile()
        }catch (e:Exception){
            e.printStackTrace()
            notificar("Erro ao Ler Arquivo" , e.message!!)
        }



    }

    private fun readerFile() {
        val file = File(PathUtils.getExternalAppFilesPath() + "/${Constants.CAMINHO_RECEBIMENTO}/dados.json")
        if (!file.exists()) {
            notificar(titulo = "Atenção", msg = "Arquivo não Econtrado")
            return
        }
        val reader = JsonReader(FileReader(file))
        val gson = App.gson
        reader.beginObject()
        while (reader.hasNext()) {
            val name = reader.nextName()
            when (name) {
                "cursos" -> inserirCurso(gson, reader)
                "instituicoes" -> inserirInstituicao(gson, reader)
                "mensalidades" -> inserirMensalidade(gson, reader)
                "socios" -> inserirSocio(gson, reader)
                "faturas" -> inserirFatura(gson, reader)
                "viagens" -> inserirViagem(gson, reader)
            }
        }
        reader.endObject()
        reader.close()
        file.delete()
        notificar(titulo = "Dados Atualizados", msg = "Sicronização Realizada com Sucesso")
    }

    private fun inserirViagem(gson: Gson, reader: JsonReader) {
        val db = AppDataBase.getInstance(this).viagemDAO()
        reader.beginArray()
        while (reader.hasNext()) {
            db.insert(gson.fromJson<Viagem>(reader, Viagem::class.java))
        }
        reader.endArray()
    }

    private fun inserirFatura(gson: Gson, reader: JsonReader) {
        val db = AppDataBase.getInstance(this).faturaDAO()
        reader.beginArray()
        while (reader.hasNext()) {
            val fat = gson.fromJson<Fatura>(reader, Fatura::class.java)
            db.insert(fat)
        }
        reader.endArray()
    }

    private fun inserirSocio(gson: Gson, reader: JsonReader) {
        val db = AppDataBase.getInstance(this).socioDAO()
        reader.beginArray()
        while (reader.hasNext()) {
            val socio = gson.fromJson<Socio>(reader, Socio::class.java)
            db.insert(socio)
        }
        reader.endArray()
    }

    private fun inserirCurso(gson: Gson, reader: JsonReader) {
        val cType = object : TypeToken<List<Curso>>() {}.type
        val c = gson.fromJson<List<Curso>>(reader, cType)
        AppDataBase.getInstance(this).inserirCurso(c)
    }

    private fun inserirInstituicao(gson: Gson, reader: JsonReader) {
        val cType = object : TypeToken<List<Instituicao>>() {}.type
        val c = gson.fromJson<List<Instituicao>>(reader, cType)
        AppDataBase.getInstance(this).inserirInstituicao(c)
    }

    private fun inserirMensalidade(gson: Gson, reader: JsonReader) {
        val cType = object : TypeToken<List<Mensalidade>>() {}.type
        val c = gson.fromJson<List<Mensalidade>>(reader, cType)
        AppDataBase.getInstance(this).inserirMensalidade(c)
    }

}
