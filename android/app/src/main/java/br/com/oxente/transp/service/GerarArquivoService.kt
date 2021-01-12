package br.com.oxente.transp.service

import android.app.IntentService
import android.content.Intent
import br.com.oxente.transp.App
import br.com.oxente.transp.entity.Socio
import br.com.oxente.transp.entity.Viagem
import br.com.oxente.transp.repository.AppDataBase
import br.com.oxente.transp.util.Constants
import com.blankj.utilcode.util.PathUtils
import com.google.gson.stream.JsonWriter
import notificar
import java.io.FileOutputStream
import java.io.OutputStreamWriter
import java.lang.Exception


class GerarArquivoService : IntentService("GerarArquivoService") {
    override fun onHandleIntent(intent: Intent?) {
        try {
            notificar(titulo = "Atenção", msg = "Gerando Arquivo", progress = true)
            gerarArquivo()
            notificar(titulo = "Atenção", msg = "Arquivo Gerado ")
        } catch (e: Exception) {
            e.printStackTrace()
            notificar("Erro ao Gerar Arquivo", e.message!!)
        }
    }

    private fun gerarArquivo() {
        val path = PathUtils.getExternalAppFilesPath() + "/${Constants.CAMINHO_ENVIO}/retorno.json"
        val writer = JsonWriter(OutputStreamWriter(FileOutputStream(path), "UTF-8"))
        writer.beginObject()
        socios(writer)
        viagens(writer)
        writer.endObject()
        writer.flush()
        writer.close()
    }

    private fun viagens(write: JsonWriter) {
        val viagens = AppDataBase.getInstance(this).getViagens()
        write.name("viagens")
        write.beginArray()
        for (v in viagens) {
            App.gson.toJson(v, Viagem::class.java, write)
        }
        write.endArray()
    }

    private fun socios(write: JsonWriter) {
        val viagens = AppDataBase.getInstance(this).getListAlteracoes()
        write.name("socios")
        write.beginArray()
        for (v in viagens) {
            App.gson.toJson(v, Socio::class.java, write)
        }
        write.endArray()
    }


}
