package com.appsamurai.storylydemo

import android.os.Bundle
import android.view.LayoutInflater
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.config.StorylyConfig
import com.appsamurai.storyly.config.styling.group.StorylyStoryGroupStyling
import com.appsamurai.storylydemo.databinding.ActivityCustomStylingBinding
import com.appsamurai.storylydemo.styling_templates.*

class CustomStylingActivity : AppCompatActivity() {
    private lateinit var binding: ActivityCustomStylingBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCustomStylingBinding.inflate(LayoutInflater.from(this))
        setContentView(binding.root)


        binding.stylingWideLandscape.storylyInit = StorylyInit(
            STORYLY_INSTANCE_TOKEN,
            config = StorylyConfig.Builder()
                .setStoryGroupStyling(
                    StorylyStoryGroupStyling.Builder()
                        .setCustomGroupViewFactory(WideLandscapeViewFactory(this))
                        .build()
                )
                .build()
        )
    }
}
