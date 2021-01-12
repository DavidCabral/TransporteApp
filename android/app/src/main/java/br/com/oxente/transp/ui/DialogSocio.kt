package br.com.oxente.transp.ui

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.annotation.UiThread
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.net.toFile
import androidx.lifecycle.ViewModelProviders
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.SocioSemana
import br.com.oxente.transp.entity.Viagem
import br.com.oxente.transp.ui.adapter.ViewPagerAdapter
import br.com.oxente.transp.ui.fragments.DialogoSocioDebitosFragment
import br.com.oxente.transp.ui.fragments.DialogoSocioMensalidade
import br.com.oxente.transp.util.Constants
import br.com.oxente.transp.viewmodel.SocioViewModel
import carregaImagem
import com.blankj.utilcode.util.FileUtils
import com.theartofdev.edmodo.cropper.CropImage
import com.theartofdev.edmodo.cropper.CropImageView
import getImagem
import invalidarCachImage
import kotlinx.android.synthetic.main.activity_dialog_socio.*
import kotlinx.android.synthetic.main.activity_dialog_socio.btFoto
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.joda.time.DateTime
import situacao
import tipoViagem
import java.io.File
import java.text.SimpleDateFormat


class DialogSocio : AppCompatActivity() {

    lateinit var mSocio: SocioSemana
    var tipoViagem = 0
    lateinit var viagem: Viagem

    private val socioViewModel: SocioViewModel by lazy {
        ViewModelProviders.of(this).get(SocioViewModel::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dialog_socio)

        GlobalScope.launch {
            mSocio = socioViewModel.getSocioSemana(intent.getStringExtra("cpf"))
            tipoViagem = intent.getIntExtra("tipo_viagem", 0)
            createViagem()
            loadSocio()
            setupViewPager()
        }

        cancelar.setOnClickListener {
            finish()
        }

        btFoto.setOnClickListener { dispatchTakePictureIntent() }

        embarcar.setOnClickListener {
            GlobalScope.launch {
                try {
                    socioViewModel.inserirViagem(viagem)
                    finish()
                } catch (e: Exception) {
                    e.printStackTrace()
                }

            }
        }
    }

    private fun dispatchTakePictureIntent() {
        CropImage.activity()
                .setGuidelines(CropImageView.Guidelines.ON)
                .start(this)

    }

    @UiThread
    private fun setupViewPager() {
        val adapter = ViewPagerAdapter(supportFragmentManager)
        adapter.addFragment(DialogoSocioMensalidade.newInstance(mSocio), "Mensalidade")
        adapter.addFragment(DialogoSocioDebitosFragment.newInstance(mSocio), "Débitos")
        viewpager.adapter = adapter
        tabLayout.setupWithViewPager(viewpager)

    }


    @SuppressLint("SimpleDateFormat")
    private fun createViagem() {
        val d = DateTime()
        val dia = d.dayOfMonth().get()
        val mes = d.monthOfYear().get()
        val ano = d.year().get()
        val data = d.toDate()
        val hora = SimpleDateFormat("HH:mm").format(data)
        viagem = Viagem(dia, mes, ano, tipoViagem, mSocio.cpf, data, 0, hora, 1)
    }

    fun loadSocio() {
        runOnUiThread {
            nome.text = mSocio.nome
            curso.text = mSocio.desCurso
            instituicao.text = mSocio.desInstituicao
            situacao.text = mSocio.ativo.situacao()
            if (mSocio.ativo) {
                situacao.visibility = View.GONE
            } else {
                embarcar.isEnabled = false
            }

            verificaDia()
            title = "VIAGEM DE ${tipoViagem.tipoViagem()}"
            this.carregaImagem(this.getImagem(mSocio.cpf), foto)
        }
    }

    @SuppressLint("SetTextI18n")
    private fun verificaDia() {
        val dataFinal = DateTime()
        val tdia = dataFinal.dayOfWeek().get()
        val d = when (tdia) {
            1 -> vdia(mSocio.segIda, mSocio.segVolta)
            2 -> vdia(mSocio.terIda, mSocio.terVolta)
            3 -> vdia(mSocio.quaIda, mSocio.quaVolta)
            4 -> vdia(mSocio.quiIda, mSocio.quiVolta)
            5 -> vdia(mSocio.sexIda, mSocio.sexVolta)
            6 -> vdia(mSocio.sabIda, mSocio.sabVolta)
            7 -> vdia(mSocio.domIda, mSocio.domVolta)
            else -> false
        }


        if (d) {
            dia.text = dataFinal.dayOfWeek().asText + " é DIA "
            dia.setTextColor(ContextCompat.getColor(this, R.color.verde))
        } else {
            dia.text = dataFinal.dayOfWeek().asText + " NÃO É DIA "
            dia.setTextColor(ContextCompat.getColor(this, R.color.inativo))
            viagem.obs = 1
        }


    }

    fun vdia(diaIda: Boolean, diaVolta: Boolean): Boolean {
        if (tipoViagem == 0) {
            return diaIda
        }
        return diaVolta
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            val result = CropImage.getActivityResult(data)
            if (resultCode == Activity.RESULT_OK) {
                val uuid = mSocio.cpf + ".jpg"
                val resultUri = result.uri.toFile()
                val file = File(this.getExternalFilesDir(Constants.CAMINHO_FOTO), uuid)
                val nova = File(this.getExternalFilesDir(Constants.CAMINHO_FOTO_NOVA), uuid)
                FileUtils.copyFile(resultUri, file)
                FileUtils.copyFile(resultUri, nova)
                FileUtils.delete(resultUri)
                this.invalidarCachImage(file)
                loadSocio()
            }
        }
    }




}
