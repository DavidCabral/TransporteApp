package br.com.oxente.transp.ui.fragments


import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window.FEATURE_NO_TITLE
import android.view.WindowManager
import androidx.core.net.toFile
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProviders
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.SocioSemana
import br.com.oxente.transp.entity.Viagem
import br.com.oxente.transp.ui.adapter.ViewPagerAdapter
import br.com.oxente.transp.util.Constants
import br.com.oxente.transp.viewmodel.SocioViewModel
import carregaImagem
import com.afollestad.materialdialogs.MaterialDialog
import com.blankj.utilcode.util.FileUtils
import com.theartofdev.edmodo.cropper.CropImage
import com.theartofdev.edmodo.cropper.CropImageView
import getImagem
import invalidarCachImage
import kotlinx.android.synthetic.main.fragment_teste.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.joda.time.DateTime
import java.io.File
import java.text.SimpleDateFormat

private const val CPF = "param1"
private const val VIAGEM = "param2"
private const val REMOVER = "param3"

class DialogoFragment : DialogFragment() {
    private var listener: OnFragmentInteractionListener? = null
    lateinit var mSocio: SocioSemana
    lateinit var mCpf: String
    var podeRemover= false
    var tipoViagem = 0

    lateinit var viagem: Viagem

    private val socioViewModel: SocioViewModel by lazy {
        ViewModelProviders.of(this).get(SocioViewModel::class.java)
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        if (context is OnFragmentInteractionListener) {
            listener = context
        }
    }

    override fun onDetach() {
        super.onDetach()
        listener = null
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_teste, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        GlobalScope.launch(Dispatchers.IO) {
            mSocio = socioViewModel.getSocioSemana(mCpf)
            createViagem()
            loadSocio()
            setupViewPager()
        }

        if(podeRemover){
            remover.visibility = View.VISIBLE
        }

        cancelar.setOnClickListener {
            dismiss()
        }

        remover.setOnClickListener {
            GlobalScope.launch {
                try {
                    socioViewModel.removerViagem(viagem)
                    dismiss()
                } catch (e: Exception) {
                    e.printStackTrace()
                }

            }
        }

        btFoto.setOnClickListener { dispatchTakePictureIntent() }

        embarcar.setOnClickListener {
            GlobalScope.launch {
                try {
                    socioViewModel.inserirViagem(viagem)
                    listener?.onFragmentInteraction()
                    dismiss()
                } catch (e: Exception) {
                    e.printStackTrace()
                }

            }
        }
    }

    private fun dispatchTakePictureIntent() {
        CropImage.activity()
                .setGuidelines(CropImageView.Guidelines.ON)
                .start(context!!, this)

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            val result = CropImage.getActivityResult(data)
            if (resultCode == Activity.RESULT_OK) {
                val uuid = mSocio.cpf + ".jpg"
                val resultUri = result.uri.toFile()
                val file = File(context!!.getExternalFilesDir(Constants.CAMINHO_FOTO), uuid)
                val nova = File(context!!.getExternalFilesDir(Constants.CAMINHO_FOTO_NOVA), uuid)
                FileUtils.copyFile(resultUri, file)
                FileUtils.copyFile(resultUri, nova)
                FileUtils.delete(resultUri)
                context!!.invalidarCachImage(file)
                carregaImagem()
            }
        }
    }

    private fun carregaImagem() {
        context?.let {
            it.carregaImagem(it.getImagem(mSocio.cpf), foto)
        }
    }

    private fun setupViewPager() {
        activity!!.runOnUiThread {
            val adapter = ViewPagerAdapter(childFragmentManager)
            adapter.addFragment(DialogoSocioDebitosFragment.newInstance(mSocio), "Débitos")
            adapter.addFragment(DialogoSocioMensalidade.newInstance(mSocio), "Mensalidade")
            viewpager.adapter = adapter
            tabLayout.setupWithViewPager(viewpager)
        }

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
        activity!!.runOnUiThread {
            curso.text = mSocio.desCurso
            instituicao.text = mSocio.desInstituicao
            nome.text = mSocio.nome

            if (!mSocio.ativo) {
                msg("ASSOCIADO ESTÁ INATIVO")
                embarcar.isEnabled = false
                return@runOnUiThread
            }

            verificaDia()
            context!!.carregaImagem(context!!.getImagem(mSocio.cpf), foto)
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

        if (!d){
            msg(dataFinal.dayOfWeek().asText + " NÃO É DIA ")
            viagem.obs = 1
        }
    }

    fun msg(msg: String) {
        activity!!.runOnUiThread {
            MaterialDialog(context!!).show {
                title(text = "Atenção")
                message(text = msg)
                positiveButton(text = "OK")
            }
        }
    }

    fun vdia(diaIda: Boolean, diaVolta: Boolean): Boolean {
        if (tipoViagem == 0) {
            return diaIda
        }
        return diaVolta
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = super.onCreateDialog(savedInstanceState)
        dialog.requestWindowFeature(FEATURE_NO_TITLE)
        dialog.window?.setBackgroundDrawableResource(android.R.color.transparent)
        arguments?.let {
            mCpf = it.getString(CPF)
            tipoViagem = it.getInt(VIAGEM)
            podeRemover = it.getBoolean(REMOVER)
        }
        return dialog
    }

    override fun onStart() {
        super.onStart()
        dialog?.window?.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT)
    }

    interface OnFragmentInteractionListener {
        fun onFragmentInteraction()
    }

    companion object {
        @JvmStatic
        fun newInstance(cpf: String, tipoViagem: Int, podeRemover:Boolean, listener: OnFragmentInteractionListener) =
                DialogoFragment().apply {
                    this.listener = listener
                    arguments = Bundle().apply {
                        putString(CPF, cpf)
                        putInt(VIAGEM, tipoViagem)
                        putBoolean(REMOVER, podeRemover)
                    }
                }
    }

}
