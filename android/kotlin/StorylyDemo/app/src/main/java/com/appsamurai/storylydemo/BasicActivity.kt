package com.appsamurai.storylydemo

import android.app.Activity
import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat
import androidx.core.net.toUri
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryCountDownComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storylydemo.databinding.ActivityMainBinding

class BasicActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    private var pendingCountdownComponent: StoryComponent? = null
    private var pendingStorylyView: StorylyView? = null

    private val notificationPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (!isGranted) {
            onFinishAlarmPermissionCheck()
        } else {
            checkAndRequestExactAlarmPermission()
        }
    }

    private val activityResultListener = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_CANCELED) {
            onAlarmPermissionGranted()
        }
        onFinishAlarmPermissionCheck()
    }

    private fun onAlarmPermissionGranted() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val canScheduleExactAlarms = alarmManager.canScheduleExactAlarms()

            if (canScheduleExactAlarms) {
                (pendingCountdownComponent as? StoryCountDownComponent)?.onPermission?.invoke()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        binding.storylyView.storylyListener = object : StorylyListener {
            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent,
                storyGroup: StoryGroup?,
                story: Story?,
                storyComponent: StoryComponent?
            ) {
                super.storylyEvent(storylyView, event, storyGroup, story, storyComponent)
                when(event) {
                    StorylyEvent.StoryCountdownReminderAdded -> {
                        checkPermissionsForCountdown(storyComponent, binding.storylyView)
                    }
                    else -> {}
                }
            }
        }

    }

    private fun checkPermissionsForCountdown(storyComponent: StoryComponent?, storylyView: StorylyView) {
        pendingStorylyView = storylyView
        pendingCountdownComponent = storyComponent
        storylyView.pauseStory()
        if (!NotificationManagerCompat.from(this).areNotificationsEnabled()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                notificationPermissionLauncher.launch(android.Manifest.permission.POST_NOTIFICATIONS)
            } else {
                onFinishAlarmPermissionCheck()
            }
        } else {
            checkAndRequestExactAlarmPermission()
        }
    }

    private fun checkAndRequestExactAlarmPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val canScheduleExactAlarms = alarmManager.canScheduleExactAlarms()

            if (!canScheduleExactAlarms) {
                val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                intent.data = ("package:" + this.packageName).toUri()
                activityResultListener.launch(intent)
            } else {
                onFinishAlarmPermissionCheck()
            }
        }
    }

    private fun onFinishAlarmPermissionCheck() {
        pendingCountdownComponent = null
        pendingStorylyView?.resumeStory()
        pendingStorylyView = null
    }
}
