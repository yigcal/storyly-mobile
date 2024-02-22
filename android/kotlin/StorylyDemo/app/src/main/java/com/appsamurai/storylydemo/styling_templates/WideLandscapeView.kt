package com.appsamurai.storylydemo.styling_templates

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.config.styling.group.StoryGroupView
import com.appsamurai.storyly.config.styling.group.StoryGroupViewFactory
import com.appsamurai.storylydemo.databinding.StylingWideLandscapeBinding
import com.bumptech.glide.Glide

@SuppressLint("ViewConstructor")
class WideLandscapeView(context: Context) : StoryGroupView(context) {

    private val listViewBinding: StylingWideLandscapeBinding = StylingWideLandscapeBinding.inflate(LayoutInflater.from(context))

    init {
        addView(listViewBinding.root)
        layoutParams = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
    }

    override fun populateView(storyGroup: StoryGroup?) {
        Glide.with(context.applicationContext).load(storyGroup?.iconUrl).into(listViewBinding.backgroundImage)
        Glide.with(context.applicationContext).load(storyGroup?.iconUrl).into(listViewBinding.groupIconImage)

        listViewBinding.groupTitle.text = storyGroup?.title
        when (storyGroup?.seen) {
            true -> listViewBinding.groupIconBg.borderColor = listOf(Color.parseColor("#FFDBDBDB"), Color.parseColor("#FFDBDBDB"))
            false -> listViewBinding.groupIconBg.borderColor = listOf(Color.parseColor("#FFFED169"), Color.parseColor("#FFFA7C20"), Color.parseColor("#FFC9287B"), Color.parseColor("#FF962EC2"), Color.parseColor("#FFFED169"))
        }
    }
}

class WideLandscapeViewFactory(private val context: Context): StoryGroupViewFactory() {
    override fun createView(): StoryGroupView {
        return WideLandscapeView(context)
    }
}
