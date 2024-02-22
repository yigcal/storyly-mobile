package com.appsamurai.storylydemo.styling_templates

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Resources
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.util.AttributeSet
import android.util.DisplayMetrics
import android.view.MotionEvent
import android.view.View
import android.view.ViewOutlineProvider
import androidx.annotation.DrawableRes
import androidx.annotation.RequiresApi
import androidx.appcompat.widget.AppCompatImageView
import com.appsamurai.storylydemo.R
import kotlin.math.*
import kotlin.properties.Delegates

/**
 * Thanks to https://github.com/vitorhugods/AvatarView
 */
private const val BORDER_RECTANGLE_INSET_SCALE = 0.75f

@SuppressLint("ViewConstructor")
internal class RoundImageView  @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0, val isRect: Boolean = false
) : AppCompatImageView(context, attrs, defStyleAttr) {

    private val displayMetrics: DisplayMetrics by lazy { Resources.getSystem().displayMetrics }

    private val avatarDrawableRect = RectF()
    private val middleRect = RectF()
    private val borderRect = RectF()
    private val arcBorderRect = RectF()

    private val shaderMatrix = Matrix()
    private val bitmapPaint = Paint()
    private val middlePaint = Paint()
    private val borderPaint = Paint()
    private val animatedBorderPaint = Paint()

    private val circleBackgroundPaint = Paint()

    private var middleThickness = 0f
    private val avatarInset
        get() = distanceToBorder + borderThickness.toFloat()

    private var avatarDrawable: Bitmap? = null
    private var bitmapShader: BitmapShader? = null
    private var bitmapWidth = 0
    private var bitmapHeight = 0

    private var drawableRadius = 0f
    private var middleRadius = 0f
    private var borderRadius = 0f

    private var middleColor = Color.TRANSPARENT

    internal var borderColor by Delegates.observable(listOf(Color.TRANSPARENT, Color.TRANSPARENT)) { _, _, _ ->
        distanceToBorder = resources.getDimensionPixelSize(R.dimen.st_story_group_icon_distance_to_border)
        borderThickness = resources.getDimensionPixelSize(R.dimen.st_story_group_icon_border_thickness)
        setup()
    }

    private var distanceToBorder = 0
    private var borderThickness = 0

    /**
     * The background color of the avatar.
     * Only visible if the image has any transparency.
     */
    internal var avatarBackgroundColor by Delegates.observable(Color.WHITE) { _, _, _ ->
        setup()
    }

    init {
        scaleType = ScaleType.CENTER_CROP
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            outlineProvider = OutlineProvider()
        }
        setup()
    }

    override fun setImageDrawable(drawable: Drawable?) {
        super.setImageDrawable(drawable)
        initializeBitmap()
    }

    override fun setImageResource(@DrawableRes resId: Int) {
        super.setImageResource(resId)
        initializeBitmap()
    }

    override fun setImageURI(uri: Uri?) {
        super.setImageURI(uri)
        initializeBitmap()
    }

    private fun setup() {
        if (width == 0 && height == 0) return
        val avatarDrawable = avatarDrawable ?: run { setImageResource(android.R.color.transparent); return }

        bitmapHeight = avatarDrawable.height
        bitmapWidth = avatarDrawable.width

        bitmapShader = BitmapShader(avatarDrawable, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP)
        bitmapPaint.isAntiAlias = true
        bitmapPaint.shader = bitmapShader

        val currentBorderThickness = borderThickness.toFloat()

        borderRect.set(calculateBounds())
        borderRadius = min((borderRect.height() - currentBorderThickness) / 2.0f, (borderRect.width() - currentBorderThickness) / 2.0f)

        val currentBorderGradient = SweepGradient(
            width / 2.0f, height / 2.0f,
            borderColor.toIntArray(),
            null
        )
        borderPaint.apply {
            shader = currentBorderGradient
            strokeWidth = currentBorderThickness
            isAntiAlias = true
            strokeCap = if (isRect) Paint.Cap.SQUARE else Paint.Cap.ROUND
            style = Paint.Style.STROKE
        }

        animatedBorderPaint.apply {
            shader = currentBorderGradient
            strokeWidth = currentBorderThickness
            isAntiAlias = true
            strokeCap = if (isRect) Paint.Cap.SQUARE else Paint.Cap.ROUND
            style = Paint.Style.STROKE
        }

        avatarDrawableRect.set(borderRect)
        if (isRect) avatarDrawableRect.inset(avatarInset * BORDER_RECTANGLE_INSET_SCALE, avatarInset * BORDER_RECTANGLE_INSET_SCALE) else avatarDrawableRect.inset(avatarInset, avatarInset)

        middleThickness = (borderRect.width() - currentBorderThickness * 2 - avatarDrawableRect.width()) / 2

        middleRect.set(borderRect)
        middleRect.inset(currentBorderThickness + middleThickness / 2, currentBorderThickness + middleThickness / 2)

        middleRadius = min(floor(middleRect.height() / 2.0f), floor(middleRect.width() / 2.0f))
        drawableRadius = min(avatarDrawableRect.height() / 2.0f, avatarDrawableRect.width() / 2.0f)

        middlePaint.apply {
            style = Paint.Style.STROKE
            isAntiAlias = true
            color = middleColor
            strokeWidth = middleThickness
        }

        circleBackgroundPaint.apply {
            style = Paint.Style.FILL
            isAntiAlias = true
            color = avatarBackgroundColor
        }

        arcBorderRect.apply {
            set(borderRect)
            inset(currentBorderThickness / 2f, currentBorderThickness / 2f)
        }

        updateShaderMatrix()
        invalidate()
    }

    private fun updateShaderMatrix() {
        val scale: Float
        var dx = 0f
        var dy = 0f

        shaderMatrix.set(null)

        if (bitmapWidth * avatarDrawableRect.height() > avatarDrawableRect.width() * bitmapHeight) {
            scale = avatarDrawableRect.height() / bitmapHeight.toFloat()
            dx = (avatarDrawableRect.width() - bitmapWidth * scale) / 2f
        } else {
            scale = avatarDrawableRect.width() / bitmapWidth.toFloat()
            dy = (avatarDrawableRect.height() - bitmapHeight * scale) / 2f
        }

        shaderMatrix.setScale(scale, scale)
        shaderMatrix.postTranslate((dx + 0.5f).toInt() + avatarDrawableRect.left, (dy + 0.5f).toInt() + avatarDrawableRect.top)

        bitmapShader!!.setLocalMatrix(shaderMatrix)
    }

    private fun getBitmapFromDrawable(drawable: Drawable?): Bitmap? {
        return when (drawable) {
            null -> null
            is BitmapDrawable -> drawable.bitmap
            else -> try {
                val bitmap = if (drawable is ColorDrawable) {
                    Bitmap.createBitmap(2, 2, Bitmap.Config.ARGB_8888)
                } else {
                    Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
                }

                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)
                bitmap
            } catch (_: IllegalArgumentException) {
                null
            }
        }
    }

    private fun initializeBitmap() {
        avatarDrawable = getBitmapFromDrawable(drawable)
        setup()
    }

    private fun calculateBounds(): RectF {
        var availableWidth = width - paddingLeft - paddingRight
        var availableHeight = height - paddingTop - paddingBottom

        return if (isRect) {
            availableWidth -= borderThickness
            availableHeight -= borderThickness
            val left = paddingLeft.toFloat() + borderThickness / 2
            val top = paddingTop.toFloat() + borderThickness / 2

            RectF(left, top, left + availableWidth, top + availableHeight)
        } else {
            val sideLength = min(availableWidth, availableHeight)

            val left = paddingLeft + (availableWidth - sideLength) / 2f
            val top = paddingTop + (availableHeight - sideLength) / 2f

            RectF(left, top, left + sideLength, top + sideLength)
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        return (event.x - borderRect.centerX().toDouble()).pow(2.0) + (event.y - borderRect.centerY().toDouble()).pow(2.0) <= borderRadius.toDouble().pow(2.0) &&
            super.onTouchEvent(event)
    }

    override fun onDraw(canvas: Canvas) {
        if (avatarDrawable == null) return
        val iconCornerRadius = 40.dp2px

        if (isRect) {
            val avatarCornerRadius = max(iconCornerRadius - avatarInset, 0.0f)
            val middleCornerRadius = max(iconCornerRadius - (borderThickness + middleThickness / 2), 0.0f)

            if (avatarBackgroundColor != Color.TRANSPARENT) {
                canvas.drawRoundRect(avatarDrawableRect, avatarCornerRadius, avatarCornerRadius, circleBackgroundPaint)
            }
            canvas.drawRoundRect(avatarDrawableRect, avatarCornerRadius, avatarCornerRadius, bitmapPaint)
            if (middleThickness > 0) {
                canvas.drawRoundRect(middleRect, middleCornerRadius, middleCornerRadius, middlePaint)
            }
        } else {
            if (avatarBackgroundColor != Color.TRANSPARENT) {
                canvas.drawCircle(avatarDrawableRect.centerX(), avatarDrawableRect.centerY(), drawableRadius, circleBackgroundPaint)
            }
            canvas.drawCircle(avatarDrawableRect.centerX(), avatarDrawableRect.centerY(), drawableRadius, bitmapPaint)
            if (middleThickness > 0) {
                canvas.drawCircle(middleRect.centerX(), middleRect.centerY(), middleRadius, middlePaint)
            }
        }
        drawBorder(canvas, iconCornerRadius)
    }

    private fun drawBorder(canvas: Canvas, iconCornerRadius: Int) {
        if (isRect) {
            val cornerRadius = max(iconCornerRadius - borderThickness / 2, 0)
            canvas.drawRoundRect(borderRect, cornerRadius.toFloat(), cornerRadius.toFloat(), borderPaint)
        } else {
            canvas.drawCircle(borderRect.centerX(), borderRect.centerY(), borderRadius, borderPaint)
        }
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        setup()
    }

    override fun setPadding(left: Int, top: Int, right: Int, bottom: Int) {
        super.setPadding(left, top, right, bottom)
        setup()
    }

    override fun setPaddingRelative(start: Int, top: Int, end: Int, bottom: Int) {
        super.setPaddingRelative(start, top, end, bottom)
        setup()
    }

    /**
     * This section makes the elevation settings on Lollipop+ possible,
     * drawing a circlar shadow around the border
     */
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private inner class OutlineProvider : ViewOutlineProvider() {

        override fun getOutline(view: View, outline: Outline) = Rect().let {
            borderRect.roundOut(it)
            outline.setRoundRect(it, it.width() / 2.0f)
        }
    }

    internal val Number.dp2px: Int
        get() = (this.toFloat() * displayMetrics.density).roundToInt()

}

