package br.com.oxente.transp.ui.fragments


import android.annotation.SuppressLint
import android.app.Activity.RESULT_OK
import android.content.Intent
import android.os.Bundle
import android.text.InputType
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RadioGroup
import androidx.core.net.toFile
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import androidx.navigation.findNavController
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.Curso
import br.com.oxente.transp.entity.Instituicao
import br.com.oxente.transp.entity.Mensalidade
import br.com.oxente.transp.entity.Socio
import br.com.oxente.transp.util.*
import br.com.oxente.transp.viewmodel.SocioViewModel
import com.wdullaer.materialdatetimepicker.date.DatePickerDialog
import carregaImagem
import com.afollestad.materialdialogs.MaterialDialog
import com.blankj.utilcode.util.FileUtils
import com.theartofdev.edmodo.cropper.CropImage
import com.theartofdev.edmodo.cropper.CropImageView
import getImagem
import invalidarCachImage
import kotlinx.android.synthetic.main.fragment_socio_detail.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File
import java.lang.ref.WeakReference
import java.text.DecimalFormat
import java.text.SimpleDateFormat
import java.util.*


class SocioDetailFragment : Fragment() {
    private lateinit var mSocio: Socio
    private var cpf = ""

    private val socioViewModel: SocioViewModel by lazy {
        ViewModelProviders.of(this).get(SocioViewModel::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            cpf = it.getString("cpf", "")
        }

        if (cpf.isBlank()) {
            mSocio = Socio()
        } else {
            GlobalScope.launch {
                mSocio = socioViewModel.getSocio(cpf)
            }
        }

    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_socio_detail, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        loaderSocio()
        loadSpiners()
        listeners()
        carregaImagem()
    }

    private fun listeners() {
        edCpf.addTextChangedListener(Mask.mask("###.###.###-##", edCpf))
        edFone1.addTextChangedListener(PhoneNumberFormatter(WeakReference(edFone1), PhoneNumberFormatType.PT_BR))
        edFone2.addTextChangedListener(PhoneNumberFormatter(WeakReference(edFone2), PhoneNumberFormatType.PT_BR))
        fabSave.setOnClickListener { save() }
        btFoto.setOnClickListener { dispatchTakePictureIntent() }
        edValidade.setOnClickListener { dialogoDate() }
        sit.setOnCheckedChangeListener { group, checkedId ->
            mSocio.ativo = checkedId == R.id.ativo
        }
    }

    private fun save() {
        if (!CPFUtil.myValidateCPF(edCpf.text.toString())) {
            MaterialDialog(context!!).show {
                title(text = "Atenção")
                message(text = "CPF Inválido")
                positiveButton(text = "OK")
            }
            return
        }
        readerSocio()
        GlobalScope.launch {
            if (cpf.isBlank()) {
                if (socioViewModel.existeCPF(mSocio.cpf) > 0) {
                    cpfJaCadastrado()
                    return@launch
                }
            }
            mSocio.tipo = 1
            socioViewModel.inserirSocio(mSocio)
            voltar()
        }

    }

    private fun cpfJaCadastrado() {
        activity!!.runOnUiThread {
            MaterialDialog(context!!).show {
                title(text = "Atenção")
                message(text = "CPF já Cadastrado ")
                positiveButton(text = "OK")
            }
        }
    }

    private fun loadSpiners() {
        GlobalScope.launch {
            loadMensalidades(socioViewModel.listMensalidades())
            loadInstituicoes(socioViewModel.listInstituicao())
            loadCuros(socioViewModel.listCurso())
        }
    }

    private fun loadMensalidades(listMensalidades: List<Mensalidade>) {
        activity!!.runOnUiThread {
            val mensalidades: List<String> = listMensalidades.map { it.desMensalidade }
            spMensalidade.setItems(mensalidades.toTypedArray())
            spMensalidade.setText(mensalidades[mSocio.codMensalidade])
            spMensalidade.setOnItemClickListener { p -> mSocio.codMensalidade = p }
        }


    }

    private fun loadCuros(v: List<Curso>) {
        activity!!.runOnUiThread {
            val cursos: List<String> = v.map { it.desCurso }
            spCurso.setItems(cursos.toTypedArray())
            spCurso.setText(cursos[mSocio.codCurso])
            spCurso.setOnItemClickListener { p -> mSocio.codCurso = p }
        }
    }

    private fun loadInstituicoes(v: List<Instituicao>) {
        activity!!.runOnUiThread {
            val inst: List<String> = v.map { it.desInstituicao }
            spInstituicao.setItems(inst.toTypedArray())
            spInstituicao.setText(inst[mSocio.codInstituicao])
            spInstituicao.setOnItemClickListener { p -> mSocio.codInstituicao = p }
        }
    }

    private fun dispatchTakePictureIntent() {
        CropImage.activity()
                .setGuidelines(CropImageView.Guidelines.ON)
                .start(context!!, this)
    }

    private fun voltar() {
        activity!!.runOnUiThread {
            view!!.findNavController().popBackStack()
        }
    }

    private fun readerSocio() {
        mSocio.let {
            it.cpf = CPFUtil.cleanCPF(edCpf.text.toString())
            it.nome = edNome.text.toString()
            it.fone = edFone1.text.toString()
            it.fone2 = edFone2.text.toString()
            it.email = edEmail.text.toString()
            it.dataCadastramento = Date()
            it.endereco = edEndereco.text.toString()
        }
    }

    private fun dialogoDate() {
        val list = DatePickerDialog.OnDateSetListener { view, year, monthOfYear, dayOfMonth ->
            val c = Calendar.getInstance()
            c.set(Calendar.YEAR, year)
            c.set(Calendar.MONTH, monthOfYear)
            c.set(Calendar.DAY_OF_MONTH, dayOfMonth)
            mSocio.dataValidade = c.time
            edValidade.setText(SimpleDateFormat("dd/MM/yy").format(mSocio.dataValidade))
        }

        val c = Calendar.getInstance()
        c.time = mSocio.dataValidade
        val dp = DatePickerDialog.newInstance(list, c)
        dp.show(this.fragmentManager!!, "Datepickerdialog")
    }

    @SuppressLint("SimpleDateFormat")
    private fun loaderSocio() {
        edNome.setText(mSocio.nome)
        edFone1.setText(mSocio.fone)
        edFone2.setText(mSocio.fone2)
        edCpf.setText(mSocio.cpf)

        mSocio.dataValidade?.let {
            edValidade.setText(SimpleDateFormat("dd/MM/yy").format(it))
        }

        if (!cpf.isBlank()) {
            edCpf.isEnabled = false
        }
        edEndereco.setText(mSocio.endereco)
        edEmail.setText(mSocio.email)

        if (mSocio.ativo) {
            ativo.isChecked = true
        } else {
            inativo.isChecked = true
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            val result = CropImage.getActivityResult(data)
            if (resultCode == RESULT_OK) {
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
            it.carregaImagem(it.getImagem(mSocio.cpf), img)
        }
    }


}
