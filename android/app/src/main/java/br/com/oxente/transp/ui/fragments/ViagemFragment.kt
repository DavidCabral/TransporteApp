package br.com.oxente.transp.ui.fragments


import android.content.Intent
import android.os.Bundle
import android.text.InputType
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import androidx.paging.PagedList
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.ViagemSocio
import br.com.oxente.transp.ui.QRCode
import br.com.oxente.transp.ui.adapter.SocioViagemAdapter
import br.com.oxente.transp.util.CPFUtil
import br.com.oxente.transp.util.Mask
import br.com.oxente.transp.viewmodel.SocioViewModel
import com.afollestad.materialdialogs.MaterialDialog
import com.afollestad.materialdialogs.WhichButton
import com.afollestad.materialdialogs.actions.setActionButtonEnabled
import com.afollestad.materialdialogs.input.getInputField
import com.afollestad.materialdialogs.input.input
import kotlinx.android.synthetic.main.fragment_viagem.*
import kotlinx.android.synthetic.main.fragment_viagem.view.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.joda.time.DateTime


class ViagemFragment : Fragment(), DialogoFragment.OnFragmentInteractionListener {
    var tipoViagem = 0
    var mDia = 0
    var mMes = 0
    var mAno = 0
    var pesquisarCPF = false

    private val adapter = SocioViagemAdapter { cpf -> callBack(cpf) }
    private val observer = Observer { list: PagedList<ViagemSocio>? -> carrregarLista(list) }


    private val socioViewModel: SocioViewModel by lazy {
        ViewModelProviders.of(this).get(SocioViewModel::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            tipoViagem = it.getInt("tipo_viagem", 0)
        }
    }

    private fun loadDate(d: DateTime) {
        mDia = d.dayOfMonth().get()
        mMes = d.monthOfYear().get()
        mAno = d.year().get()
        loadRecyclerView()
        hideFab()
    }

    private fun hideFab() {
        val d = DateTime()
        val dia = d.dayOfMonth().get()
        val mes = d.monthOfYear().get()
        val ano = d.year().get()
        fab?.let {
            it.visibility = if (dia == mDia && mes == mMes && ano == mAno) {
                View.VISIBLE
            } else {
                View.GONE
            }
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_viagem, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        weekCalendar.setOnDateClickListener { d -> loadDate(d) }



        view.fab.addOnMenuItemClickListener { _, _, itemId ->
            when (itemId) {
                R.id.pesquisaCPF -> porCPF()
                R.id.qrcode -> porQR()
            }
        }
        viagemList.adapter = adapter
        loadDate(DateTime())

    }

    private fun porQR() {
        pesquisarCPF = false
        startActivityForResult(Intent(activity, QRCode::class.java), 2)
    }

    fun porCPF() {
        pesquisarCPF = true

        val type = InputType.TYPE_CLASS_NUMBER

        val dialog = MaterialDialog(context!!)
                .title(text = "CPF")
                .input(inputType = type, hint = "Informe o CPF", waitForPositiveButton = false) { dialog, text ->
                    val inputField = dialog.getInputField()
                    val isValid = CPFUtil.myValidateCPF(text.toString())

                    inputField.error = if (isValid) null else "CPF Inválido"
                    dialog.setActionButtonEnabled(WhichButton.POSITIVE, isValid)
                }
                .positiveButton(text = "Pesquisar") { dialog ->
                    pesquisarSocio(dialog.getInputField().text.toString())
                }
                .negativeButton(text = "Cancelar")

        dialog.getInputField().addTextChangedListener(Mask.mask("###.###.###-##", dialog.getInputField()))

        dialog.show()

    }

    fun pesquisarSocio(cpf: String) {
        GlobalScope.launch {
            if (socioViewModel.existeCPF(CPFUtil.cleanCPF(cpf)) == 0) {
                msg("CPF $cpf NÃO LOCALIZADO")
            } else {
                val viagem = socioViewModel.getViagem(mDia, mMes, mAno, CPFUtil.cleanCPF(cpf), tipoViagem)
                if (viagem != null) {
                    msg("${viagem.nome} já embarcou às ${viagem.hora}")
                    return@launch
                }
                acessar(CPFUtil.cleanCPF(cpf))
            }
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        data?.let {
            pesquisarSocio(it.getStringExtra("cpf"))
        }
    }

    private fun loadRecyclerView() {
        socioViewModel.viagemList(mDia, mMes, mAno, tipoViagem).removeObserver(observer)
        socioViewModel.viagemList(mDia, mMes, mAno, tipoViagem).observe(this, observer)
    }

    private fun carrregarLista(list: PagedList<ViagemSocio>?) {
        adapter.submitList(list)
        adapter.notifyDataSetChanged()
    }


    fun acessar(cpf: String, remover: Boolean = false) {
        val fragmentManager = activity!!.supportFragmentManager
        val newFragment = DialogoFragment.newInstance(cpf, tipoViagem, remover, this)
        newFragment.show(fragmentManager, "dialog")
    }

    override fun onFragmentInteraction() {
        GlobalScope.launch {
            delay(1000)
            activity!!.runOnUiThread {
                if (pesquisarCPF) {
                    porCPF()
                } else {
                    porQR()
                }
            }
        }
    }


    private fun callBack(cpf: String) {
        acessar(cpf, true)
    }

}
