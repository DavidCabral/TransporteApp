package br.com.oxente.transp.ui.fragments


import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat

import br.com.oxente.transp.R
import br.com.oxente.transp.entity.SocioSemana
import cor
import kotlinx.android.synthetic.main.fragment_dialogo_socio_mensalidade.*
import sn


private const val ARG_PARAM1 = "param1"

class DialogoSocioMensalidade : Fragment() {

    lateinit var mSocio: SocioSemana

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_dialogo_socio_mensalidade, container, false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            mSocio = it.getParcelable(ARG_PARAM1)!!
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        verificaSemana()
    }

    private fun verificaSemana() {

        mensalidade.text = mSocio.desMensalidade

        idom.text = mSocio.domIda.sn()
        idom.setTextColor(ContextCompat.getColor(context!!, mSocio.domIda.cor()))

        iseg.text = mSocio.segIda.sn()
        iseg.setTextColor(ContextCompat.getColor(context!!, mSocio.segIda.cor()))

        iter.text = mSocio.terIda.sn()
        iter.setTextColor(ContextCompat.getColor(context!!, mSocio.terIda.cor()))

        iqua.text = mSocio.quaIda.sn()
        iqua.setTextColor(ContextCompat.getColor(context!!, mSocio.quaIda.cor()))

        iqui.text = mSocio.quiIda.sn()
        iqui.setTextColor(ContextCompat.getColor(context!!, mSocio.quiIda.cor()))

        isex.text = mSocio.sexIda.sn()
        isex.setTextColor(ContextCompat.getColor(context!!, mSocio.sexIda.cor()))

        isab.text = mSocio.sabIda.sn()
        isab.setTextColor(ContextCompat.getColor(context!!, mSocio.sabIda.cor()))

        vdom.text = mSocio.domVolta.sn()
        vdom.setTextColor(ContextCompat.getColor(context!!, mSocio.domVolta.cor()))

        vseg.text = mSocio.segVolta.sn()
        vseg.setTextColor(ContextCompat.getColor(context!!, mSocio.segVolta.cor()))

        vter.text = mSocio.terVolta.sn()
        vter.setTextColor(ContextCompat.getColor(context!!, mSocio.terVolta.cor()))

        vqua.text = mSocio.quaVolta.sn()
        vqua.setTextColor(ContextCompat.getColor(context!!, mSocio.quaVolta.cor()))

        vqui.text = mSocio.quiVolta.sn()
        vqui.setTextColor(ContextCompat.getColor(context!!, mSocio.quiVolta.cor()))

        vsex.text = mSocio.sexVolta.sn()
        vsex.setTextColor(ContextCompat.getColor(context!!, mSocio.sexVolta.cor()))

        vsab.text = mSocio.sabVolta.sn()
        vsab.setTextColor(ContextCompat.getColor(context!!, mSocio.sabVolta.cor()))

    }

    companion object {
        @JvmStatic
        fun newInstance(socio: SocioSemana) =
                DialogoSocioMensalidade().apply {
                    arguments = Bundle().apply {
                        putParcelable(ARG_PARAM1, socio)
                    }
                }
    }

}
