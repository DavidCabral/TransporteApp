package br.com.oxente.transp.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import br.com.oxente.transp.util.Constants
import com.blankj.utilcode.util.FileUtils
import com.blankj.utilcode.util.ServiceUtils

// adb shell am broadcast -a oxenteReceiver --es tipo "0"
//enviar arquivo via adb
// adb push C:\Users\David\Desktop\dados.json /sdcard/android/data/br.com.oxente.associacao/files/recebimento
class MyReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.getStringExtra("tipo")) {
            "0" -> ServiceUtils.startService(GerarArquivoService::class.java)
            "1" -> ServiceUtils.startService(LerArquivoService::class.java)
            "2" -> FileUtils.deleteAllInDir(context.getExternalFilesDir(Constants.CAMINHO_FOTO_NOVA))
        }
    }
}
