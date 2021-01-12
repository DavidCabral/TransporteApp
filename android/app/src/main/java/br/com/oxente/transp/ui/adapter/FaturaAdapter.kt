package br.com.oxente.transp.ui.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.paging.PagedListAdapter
import androidx.recyclerview.widget.DiffUtil
import br.com.oxente.transp.R
import br.com.oxente.transp.entity.Fatura
import kotlinx.android.synthetic.main.debito_item.view.*
import java.text.DecimalFormat
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.*


class FaturaAdapter() : PagedListAdapter<Fatura, FaturaAdapter.SocioViewHolder>(diffCallback) {
    override fun onBindViewHolder(holder: SocioViewHolder, position: Int) {
        holder.bindTo(getItem(position))
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SocioViewHolder = SocioViewHolder(parent)

    companion object {
        private val diffCallback = object : DiffUtil.ItemCallback<Fatura>() {
            override fun areItemsTheSame(oldItem: Fatura, newItem: Fatura): Boolean = oldItem.fatura == newItem.fatura
            override fun areContentsTheSame(oldItem: Fatura, newItem: Fatura): Boolean = oldItem == newItem
        }
    }

    class SocioViewHolder(private val parent: ViewGroup) : androidx.recyclerview.widget.RecyclerView.ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.debito_item, parent, false)) {
        var fatura: Fatura? = null
        @SuppressLint("SimpleDateFormat")
        fun bindTo(fatura: Fatura?) {
            this.fatura = fatura
            fatura?.let {
                with(itemView) {
                    txMes.text = DecimalFormat("00").format(it.mes)
                    txAno.text = it.ano.toString()
                    txValor.text =  NumberFormat.getCurrencyInstance(Locale("pt","BR")).format(it.valor)
                    txVencimento.text = SimpleDateFormat("dd/MM/yy").format(it.vencimento)
                }
            }
        }
    }
}
