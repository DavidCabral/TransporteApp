import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.ImageView
import androidx.core.app.NotificationCompat
import br.com.oxente.transp.R
import br.com.oxente.transp.util.Constants
import com.squareup.picasso.Picasso
import java.io.File


fun Context.carregaImagem(file: File, imageView: ImageView) {
    Picasso.get()
            .load(file)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .resize(200, 200)
            .into(imageView)
}

fun Context.invalidarCachImage(file: File) {
    Picasso.get().invalidate(file)

}


fun Context.getImagem(name: String?): File {
    if (name.isNullOrBlank()) {
        return File("")
    }
    return File(this.getExternalFilesDir(Constants.CAMINHO_FOTO), name.replace(".", "").replace("-", "") + ".jpg")
}

fun Boolean.situacao(): String {
    if (this) {
        return "ATIVO"
    }
    return "INATIVO"
}

fun Boolean.sn(): String {
    if (this) {
        return "SIM"
    }
    return "NÃO"
}

fun Boolean.cor(): Int {
    if (this) {
        return R.color.verde
    }
    return R.color.inativo
}

fun Int.tipoViagem(): String {
    if (this == 0) {
        return "IDA"
    }
    return "VOLTA"
}


fun Context.notificar(titulo: String = "", msg: String = "", progress: Boolean = false) {
    showNotification(this, title = titulo, body = msg)
}

fun showNotification(context: Context, title: String, body: String) {
    val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val notificationId = 1
    val channelId = "channel-01"
    val channelName = "Channel Name"

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val importance = NotificationManager.IMPORTANCE_HIGH
        val mChannel = NotificationChannel(
                channelId, channelName, importance)
        notificationManager.createNotificationChannel(mChannel)
    }

    val mBuilder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.ic_stat_name)
            .setContentTitle(title)
            .setContentText(body)

    notificationManager.notify(notificationId, mBuilder.build())
}




