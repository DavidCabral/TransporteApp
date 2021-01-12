package br.com.oxente.transp.ui.fragments


import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.SocioSemana
import br.com.oxente.transp.ui.adapter.FaturaAdapter
import br.com.oxente.transp.viewmodel.SocioViewModel
import kotlinx.android.synthetic.main.fragment_dialogo_socio_debitos.*


private const val ARG_PARAM1 = "param1"


@Suppress("NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS")
class DialogoSocioDebitosFragment : Fragment() {

    lateinit var mSocio: SocioSemana

    private val adapter = FaturaAdapter()

    private val socioViewModel: SocioViewModel by lazy {
        ViewModelProviders.of(this).get(SocioViewModel::class.java)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_dialogo_socio_debitos, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        loadRC()
    }

    fun loadRC() {
        debitoList.adapter = adapter
        socioViewModel.debitos(mSocio.cpf).observe(this, Observer { list ->
            adapter.submitList(list)
            adapter.notifyDataSetChanged()
            listEmpty(list?.size ?: 0)
        })
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            mSocio = it.getParcelable(ARG_PARAM1)
        }
    }

    private fun listEmpty(total: Int) {
        if (total == 0) {
            val tv = TextView(activity)
            tv.text = getString(R.string.debitosEmpty)
            tv.setTextColor(ContextCompat.getColor(activity!!, R.color.colorPrimaryDark))
            tv.textSize = 18F
            tv.id = 0
            tv.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
            tv.gravity = Gravity.CENTER
            tbDebito.addView(tv)
        } else if (tbDebito.findViewById<View>(0) != null) {
            tbDebito.removeView(tbDebito.findViewById(0))
        }
    }

    companion object {
        @JvmStatic
        fun newInstance(socio: SocioSemana) =
                DialogoSocioDebitosFragment().apply {
                    arguments = Bundle().apply {
                        putParcelable(ARG_PARAM1, socio)
                    }
                }
    }

}
