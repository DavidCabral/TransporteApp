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
import androidx.navigation.findNavController
import br.com.oxente.transp.R
import br.com.oxente.transp.ui.adapter.SocioAdapter
import br.com.oxente.transp.viewmodel.SocioViewModel
import kotlinx.android.synthetic.main.fragment_associado.*
import kotlinx.android.synthetic.main.fragment_associado.view.*

class AssociadoFragment : Fragment() {

    private val adapter = SocioAdapter { cpf -> callBack(cpf) }

    private val socioViewModel: SocioViewModel by lazy {
        ViewModelProviders.of(this).get(SocioViewModel::class.java)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_associado, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        loadRecyclerView()
        fab.setOnClickListener {
            callBack("")
        }
    }

    private fun loadRecyclerView() {
        view!!.socioList.adapter = adapter
        socioViewModel.socioListItem().observe(this, Observer { list ->
            adapter.submitList(list)
            adapter.notifyDataSetChanged()
            listEmpty(list?.size ?: 0)
        })
    }

    private fun listEmpty(total: Int) {
            if (total == 0) {
                val tv = TextView(activity)
                tv.text = getString(R.string.socioEmpty)
                tv.setTextColor(ContextCompat.getColor(activity!!, R.color.colorPrimaryDark))
                tv.textSize = 18F
                tv.id = 0
                tv.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
                tv.gravity = Gravity.CENTER
                view.let {
                    frSocios.addView(tv)
                }
            } else if (view!!.frSocios.findViewById<View>(0) != null) {
                view.let {
                    frSocios.removeView(frSocios.findViewById(0))
                }
        }
    }

    private fun callBack(cpf: String) {
        val args = Bundle().apply {
            putString("cpf", cpf)
        }
        view!!.findNavController().navigate(R.id.action_associadoFragment_to_socioDetailFragment, args)
    }


}
