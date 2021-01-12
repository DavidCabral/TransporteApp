package br.com.oxente.transp.ui.adapter

import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.paging.PagedListAdapter
import androidx.recyclerview.widget.DiffUtil
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.ViagemSocio
import carregaImagem
import getImagem
import kotlinx.android.synthetic.main.socio_viagem_item.view.*


class SocioViagemAdapter(val callBack: (cpf: String) -> Unit) : PagedListAdapter<ViagemSocio, SocioViagemAdapter.SocioViewHolder>(diffCallback) {
    override fun onBindViewHolder(holder: SocioViewHolder, position: Int) {
        holder.bindTo(getItem(position))
        holder.itemView.setOnClickListener { callBack(holder.socio!!.cpf) }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SocioViewHolder = SocioViewHolder(parent)

    companion object {
        private val diffCallback = object : DiffUtil.ItemCallback<ViagemSocio>() {
            override fun areItemsTheSame(o: ViagemSocio, n: ViagemSocio): Boolean = o.cpf == n.cpf && o.dia == n.dia && o.mes == n.mes && o.ano == n.ano
            override fun areContentsTheSame(oldItem: ViagemSocio, newItem: ViagemSocio): Boolean = oldItem == newItem
        }
    }

    class SocioViewHolder(private val parent: ViewGroup) : androidx.recyclerview.widget.RecyclerView.ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.socio_viagem_item, parent, false)) {
        var socio: ViagemSocio? = null
        fun bindTo(socio: ViagemSocio?) {
            this.socio = socio
            socio?.let {
                with(itemView) {
                    if(it.obs > 0){
                        card_view.setBackgroundColor(ContextCompat.getColor(context, R.color.obs))
                    }
                    txNome.text = it.nome
                    txCurso.text = socio.desCurso
                    txInstituicao.text = socio.desInstituicao
                    txEmbarque.text = socio.hora
                }
                parent.context?.let {
                    it.carregaImagem(it.getImagem(socio.cpf), itemView.avatar)
                }

            }

        }
    }
}
