package br.com.oxente.transp.ui.fragments


import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import br.com.oxente.transp.R
import com.afollestad.materialdialogs.MaterialDialog
import com.afollestad.materialdialogs.customview.customView
import com.afollestad.materialdialogs.customview.getCustomView
import kotlinx.android.synthetic.main.fragment_principal.*
import kotlinx.android.synthetic.main.tipo_viagem.view.*


class PrincipalFragment : Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_principal, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        //btLogar.setOnClickListener { v -> v.findNavController().navigate(R.id.action_loginFragment_to_principalFragment) }
        cdViagem.setOnClickListener { tipoViagem() }
        cdPagamento.setOnClickListener { v -> v.findNavController().navigate(R.id.action_principalFragment_to_pagamentoFragment) }
        cdAssociado.setOnClickListener { v -> v.findNavController().navigate(R.id.action_principalFragment_to_associadoFragment) }
        cdAta.setOnClickListener { v -> v.findNavController().navigate(R.id.action_principalFragment_to_ataFragment) }
    }

    private fun viagens(tipo: Int) {
        activity!!.runOnUiThread {
            val args = Bundle().apply {
                putInt("tipo_viagem", tipo)
                putString("title", if (tipo == 0) {
                    "Ida"
                } else {
                    "Volta"
                })
            }
            view!!.findNavController().navigate(R.id.action_principalFragment_to_viagemFragment, args)
        }

    }


    private fun tipoViagem() {

        val dialog = MaterialDialog(context!!)
                .title(text = "Tipo de Viagem")
                .customView(R.layout.tipo_viagem, scrollable = true)


        val customView = dialog.getCustomView()

        customView.cdIda.setOnClickListener {
            dialog.dismiss()
            viagens(0)
        }
        customView.cdVolta.setOnClickListener {
            dialog.dismiss()
            viagens(1)
        }

        dialog.show()
    }



}
