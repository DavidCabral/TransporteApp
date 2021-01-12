package br.com.oxente.transp.ui

import android.content.IntentFilter
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.Navigation
import androidx.navigation.findNavController
import androidx.navigation.ui.NavigationUI
import br.com.oxente.transp.R
import br.com.oxente.transp.service.MyReceiver
import br.com.oxente.transp.util.Constants
import com.afollestad.materialdialogs.MaterialDialog
import com.blankj.utilcode.constant.PermissionConstants
import com.blankj.utilcode.util.FileUtils
import com.blankj.utilcode.util.PermissionUtils


class MainActivity : AppCompatActivity() {

    val receiver = MyReceiver()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        permissao()
        NavigationUI.setupActionBarWithNavController(this, Navigation.findNavController(this, R.id.navHost))

        val currentapiVersion = android.os.Build.VERSION.SDK_INT
        if (currentapiVersion > 25) {
            val filter = IntentFilter()
            filter.addAction("oxenteReceiver")
            registerReceiver(receiver, filter)
        }
        //PicassoFaceDetector.initialize(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        //PicassoFaceDetector.releaseDetector()
        val currentapiVersion = android.os.Build.VERSION.SDK_INT
        if (currentapiVersion > 26) {
            unregisterReceiver(receiver)
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        return findNavController(R.id.navHost).navigateUp()
    }

    fun permissao() {
        PermissionUtils
                .permission(PermissionConstants.CAMERA, PermissionConstants.STORAGE)
                .callback(object : PermissionUtils.FullCallback {
                    override fun onGranted(permissionsGranted: MutableList<String>?) {
                        FileUtils.createOrExistsDir(getExternalFilesDir(Constants.CAMINHO_FOTO))
                        FileUtils.createOrExistsDir(getExternalFilesDir(Constants.CAMINHO_FOTO_NOVA))
                        FileUtils.createOrExistsDir(getExternalFilesDir(Constants.CAMINHO_ENVIO))
                        FileUtils.createOrExistsDir(getExternalFilesDir(Constants.CAMINHO_RECEBIMENTO))
                        FileUtils.createOrExistsDir(getExternalFilesDir(Constants.CAMINHO_BACKUP))
                    }

                    override fun onDenied(permissionsDeniedForever: MutableList<String>?, permissionsDenied: MutableList<String>?) {
                        MaterialDialog(this@MainActivity).show {
                            title(text = "Atenção")
                            message(text = "Para funcionar corretamente é necessário habilitar todas as permissões")
                            positiveButton(text = "ok")
                        }
                    }
                })
                .request()
    }
}
