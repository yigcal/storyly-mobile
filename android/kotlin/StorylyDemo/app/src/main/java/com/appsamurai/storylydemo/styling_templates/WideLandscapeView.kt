package com.appsamurai.storylydemo.styling_templates

import android.annotation.SuppressLint
import android.content.Context
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
        Glide.with(context.applicationContext).load(storyGroup?.iconUrl).into(listViewBinding.coverIcon)

        listViewBinding.groupTitle.text = storyGroup?.title
    }
}

class WideLandscapeViewFactory(private val context: Context): StoryGroupViewFactory() {
    override fun createView(): StoryGroupView {
        return WideLandscapeView(context)
    }
}
