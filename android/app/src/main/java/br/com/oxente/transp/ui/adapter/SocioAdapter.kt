package br.com.oxente.transp.ui.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.paging.PagedListAdapter
import androidx.recyclerview.widget.DiffUtil
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.SocioItem
import carregaImagem
import getImagem
import kotlinx.android.synthetic.main.socio_item.view.*


class SocioAdapter(val callBack: (cpf: String) -> Unit) : PagedListAdapter<SocioItem, SocioAdapter.SocioViewHolder>(diffCallback) {
    override fun onBindViewHolder(holder: SocioViewHolder, position: Int) {
        holder.bindTo(getItem(position))
        holder.itemView.setOnClickListener { callBack(holder.socio!!.cpf) }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SocioViewHolder = SocioViewHolder(parent)

    companion object {
        private val diffCallback = object : DiffUtil.ItemCallback<SocioItem>() {
            override fun areItemsTheSame(oldItem: SocioItem, newItem: SocioItem): Boolean = oldItem.cpf == newItem.cpf
            override fun areContentsTheSame(oldItem: SocioItem, newItem: SocioItem): Boolean = oldItem == newItem
        }
    }

    class SocioViewHolder(private val parent: ViewGroup) : androidx.recyclerview.widget.RecyclerView.ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.socio_item, parent, false)) {
        var socio: SocioItem? = null
        fun bindTo(socio: SocioItem?) {
            this.socio = socio
            socio?.let {
                with(itemView) {
                    txNome.text = it.nome
                    txCurso.text = socio.desCurso
                    txInstituicao.text = socio.desInstituicao

                }
                parent.context?.let {
                    it.carregaImagem(it.getImagem(socio.cpf), itemView.avatar)
                }

            }

        }
    }
}
