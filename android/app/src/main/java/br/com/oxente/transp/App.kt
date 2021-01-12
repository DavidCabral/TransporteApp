package br.com.oxente.transp

import android.app.Application
import com.blankj.utilcode.util.Utils
import com.google.gson.GsonBuilder

class App : Application() {

    companion object {
        private var instance: App? = null

        fun getInstance(): App {
            return instance!!
        }

        val gson = GsonBuilder()
                /*.registerTypeAdapter(Date::class.java, JsonDeserializer<Date> { json, _, _ -> Date(json.asJsonPrimitive.asLong) })
                .registerTypeAdapter(Date::class.java, JsonSerializer<Date> { src, _, _ -> if (src == null) null else JsonPrimitive(src.time) })*/
                .setDateFormat("dd-MM-yyyy HH:mm:ss")
                .create()!!

    }

    init {
        instance = this
    }

    override fun onCreate() {
        super.onCreate()
        Utils.init(this)
    }


}
