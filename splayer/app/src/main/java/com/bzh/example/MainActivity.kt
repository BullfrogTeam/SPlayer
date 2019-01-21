package com.bzh.example

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.bzh.splayer.SPlayer
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    val splayer = SPlayer()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Example of a call to a native method
        sample_text.text = splayer.stringFromJNI()

        sample_text.setOnClickListener {
            sample_text.text = splayer.stringFromJNI()
        }
    }

}
