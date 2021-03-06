import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [StorylyView] created callback
typedef StorylyViewCreatedCallback = void Function(
  StorylyViewController controller,
);

/// Storyly UI Widget
class StorylyView extends StatefulWidget {
  /// This callback function allows you to access `StorylyViewController`
  ///
  /// ```dart
  /// StorylyView(
  ///   onStorylyViewCreated: onStorylyViewCreated,
  /// )
  ///
  /// void onStorylyViewCreated(StorylyViewController storylyViewController) {
  ///   this.storylyViewController = storylyViewController;
  /// }
  /// ```
  final StorylyViewCreatedCallback onStorylyViewCreated;

  /// Android specific [StorylyParam]
  final StorylyParam androidParam;

  /// iOS specific [StorylyParam]
  final StorylyParam iosParam;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and story group list has just shown to the user.
  final Function(List) storylyLoaded;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and had a problem while fetching your stories.
  final Function(String) storylyLoadFailed;

  /// This callback function will notify you about all Storyly events and let
  /// you to send these events to specific data platforms
  final Function(Map) storylyEvent;

  /// This callback function will notify your application in case of Swipe Up
  /// or CTA Button action.
  final Function(Map) storylyActionClicked;

  /// This callback function will let you know that stories are started to be
  /// shown to the users.
  final Function() storylyStoryShown;

  /// This callback function will let you know that user dismissed the current
  /// story while watching it.
  final Function() storylyStoryDismissed;

  /// This callback function will allow you to get reactions of users from
  /// specific interactive components.
  final Function(Map) storylyUserInteracted;

  const StorylyView({
    Key key,
    this.onStorylyViewCreated,
    this.androidParam,
    this.iosParam,
    this.storylyLoaded,
    this.storylyLoadFailed,
    this.storylyEvent,
    this.storylyActionClicked,
    this.storylyStoryShown,
    this.storylyStoryDismissed,
    this.storylyUserInteracted,
  }) : super(key: key);

  @override
  State<StorylyView> createState() => _StorylyViewState();
}

class _StorylyViewState extends State<StorylyView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'FlutterStorylyView',
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        creationParams: widget.androidParam._toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'FlutterStorylyView',
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        creationParams: widget.iosParam._toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
      '$defaultTargetPlatform is not supported yet for Storyly Flutter plugin.',
    );
  }

  void _onPlatformViewCreated(int _id) {
    final methodChannel = MethodChannel(
      'com.appsamurai.storyly/flutter_storyly_view_$_id',
    );
    methodChannel.setMethodCallHandler(_handleMethod);

    if (widget.onStorylyViewCreated != null) {
      widget.onStorylyViewCreated(
        StorylyViewController(methodChannel),
      );
    }
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'storylyLoaded':
        widget.storylyLoaded(call.arguments);
        break;
      case 'storylyLoadFailed':
        widget.storylyLoadFailed(call.arguments);
        break;
      case 'storylyEvent':
        widget.storylyEvent(call.arguments);
        break;
      case 'storylyActionClicked':
        widget.storylyActionClicked(call.arguments);
        break;
      case 'storylyStoryShown':
      case 'storylyStoryPresented':
        widget.storylyStoryShown();
        break;
      case 'storylyStoryDismissed':
        widget.storylyStoryDismissed();
        break;
      case 'storylyUserInteracted':
        widget.storylyUserInteracted(call.arguments);
        break;
    }
  }
}

class StorylyViewController {
  final MethodChannel _methodChannel;

  StorylyViewController(this._methodChannel);

  /// This function allows you to refetch the data from network
  /// by default you do not need to use this function.
  Future<void> refresh() {
    return _methodChannel.invokeMethod('refresh');
  }

  /// This function allows you to open the story view.
  Future<void> storyShow() {
    return _methodChannel.invokeMethod('show');
  }

  /// This function allows you to dismiss story view.
  Future<void> storyDismiss() {
    return _methodChannel.invokeMethod('dismiss');
  }

  /// This function allows you to open a specific story using
  /// `storyGroupId` and `storyId`.
  Future<void> openStory(int storyGroupId, int storyId) {
    return _methodChannel.invokeMethod(
      'openStory',
      <String, dynamic>{
        'storyGroupId': storyGroupId,
        'storyId': storyId,
      },
    );
  }

  /// This function allows you to open using deeplink uri.
  Future<void> openStoryUri(String uri) {
    return _methodChannel.invokeMethod(
      'openStoryUri',
      <String, dynamic>{
        'uri': uri,
      },
    );
  }

  /// This function allows you to specify data of custom template groups.
  Future<void> setExternalData(List<Map> externalData) {
    return _methodChannel.invokeMethod(
      'setExternalData',
      <String, dynamic>{
        'externalData': externalData,
      },
    );
  }
}

/// This class is used to customize the [StorylyView]
class StorylyParam {
  /// This attribute required for your app's correct initialization.
  @required
  String storylyId;

  /// This attribute takes a list of string which will be used in process
  /// of segmentation to show sepecific story groups to the users.
  List<String> storylySegments;

  /// Storyly SDK allows you to send a string parameter in the initialization
  /// process. This field is used for this analytical pruposes.
  ///
  /// * This value cannot have more than 200 characters. If you exceed the
  ///   size limit, your value will be set to null.
  String storylyCustomParameters;

  /// This attribute allows you to change the background color of the
  /// [StorylyView]
  Color storylyBackgroundColor;

  /// This attribute changes the size of the story group. Currently,
  /// supported sizes are `small`, `large`, `xlarge` and `custom` sizes.
  /// Default story group size is `large` size.
  ///
  /// * This section is effective if you set your story group size as `custom`.
  ///   If you set any other size and use this attribute, your changes will
  ///   not take effect.
  ///
  /// In order to set this attribute use the following method:
  ///
  /// ```dart
  /// StorylyParam()
  ///   ...
  ///   storyGroupIconWidth = 100
  ///   storyGroupIconHeight = 100
  ///   storyGroupIconCornerRadius = 50;
  /// ```
  ///
  /// * You need to set all parameters to this customization to be effective.
  String storyGroupSize;

  /// This attribute allows you to changes the width of story group icon.
  int storyGroupIconWidth;

  /// This attribute allows you to changes the height of story group icon.
  int storyGroupIconHeight;

  /// This attribute allows you to changes the corner radius of story group
  /// icon.
  int storyGroupIconCornerRadius;

  /// This attribute allows you to changes the edge padding of story group
  /// list.
  int storyGroupListEdgePadding;

  /// This attribute allows you to changes the distance between of story group
  /// icons.
  int storyGroupListPaddingBetweenItems;

  /// This attribute allows you to changes the visibility of story group
  /// text.
  bool storyGroupTextIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header text.
  bool storyHeaderTextIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header icon.
  bool storyHeaderIconIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header close button.
  bool storyHeaderCloseButtonIsVisible;

  /// This attribute allows you to the border color of the story group
  /// icons which are watched by the user.
  List<Color> storyGroupIconBorderColorSeen;

  /// This attribute allows you to change the border color of the story
  /// group icons which are unwatched by the user.
  List<Color> storyGroupIconBorderColorNotSeen;

  /// This attribute allows you to change the background color of the story
  /// group icon which is shown to the user as skeleton view till the stories
  /// are loaded.
  Color storyGroupIconBackgroundColor;

  /// This attribute allows you to change the text color of the story group.
  Color storyGroupTextColor;

  /// If any of the story group is selected as pinned group from dashboard,
  /// a little star icon will appear along with the story group icon. This
  /// attribute allows you to change the background color of this pin icon.
  Color storyGroupPinIconColor;

  /// This attribute allows you to change the header icon border
  /// color of the story view.
  List<Color> storyItemIconBorderColor;

  /// This attribute allows you to change the header text color of the
  /// story view.
  Color storyItemTextColor;

  /// This attribute allows you to change the progress bar colors of
  /// the story view.
  List<Color> storyItemProgressBarColor;

  Map<String, dynamic> _toMap() {
    final paramsMap = <String, dynamic>{
      'storylyId': storylyId,
      'storylySegments': storylySegments,
      'storylyCustomParameters': storylyCustomParameters,
    };

    paramsMap['storylyBackgroundColor'] = storylyBackgroundColor != null
        ? _toHexString(storylyBackgroundColor)
        : null;

    paramsMap['storyGroupIconStyling'] = {
      'width': storyGroupIconWidth,
      'height': storyGroupIconHeight,
      'cornerRadius': storyGroupIconCornerRadius,
    };

    paramsMap['storyGroupListStyling'] = {
      'edgePadding': storyGroupListEdgePadding,
      'paddingBetweenItems': storyGroupListPaddingBetweenItems
    };

    paramsMap['storyGroupTextStyling'] = {
      'isVisible': storyGroupTextIsVisible,
    };

    paramsMap['storyHeaderStyling'] = {
      'isTextVisible': storyHeaderTextIsVisible,
      'isIconVisible': storyHeaderIconIsVisible,
      'isCloseButtonVisible': storyHeaderCloseButtonIsVisible
    };

    paramsMap['storyGroupSize'] = storyGroupSize ?? 'large';

    paramsMap['storyGroupIconBorderColorSeen'] =
        storyGroupIconBorderColorSeen != null
            ? storyGroupIconBorderColorSeen
                .map((color) => _toHexString(color))
                .toList()
            : null;

    paramsMap['storyGroupIconBorderColorNotSeen'] =
        storyGroupIconBorderColorNotSeen != null
            ? storyGroupIconBorderColorNotSeen
                .map((color) => _toHexString(color))
                .toList()
            : null;

    paramsMap['storyGroupIconBackgroundColor'] =
        storyGroupIconBackgroundColor != null
            ? _toHexString(storyGroupIconBackgroundColor)
            : null;

    paramsMap['storyGroupTextColor'] =
        storyGroupTextColor != null ? _toHexString(storyGroupTextColor) : null;

    paramsMap['storyGroupPinIconColor'] = storyGroupPinIconColor != null
        ? _toHexString(storyGroupPinIconColor)
        : null;

    paramsMap['storyItemIconBorderColor'] = storyItemIconBorderColor != null
        ? storyItemIconBorderColor.map((color) => _toHexString(color)).toList()
        : null;

    paramsMap['storyItemTextColor'] =
        storyItemTextColor != null ? _toHexString(storyItemTextColor) : null;

    paramsMap['storyItemProgressBarColor'] = storyItemProgressBarColor != null
        ? storyItemProgressBarColor.map((color) => _toHexString(color)).toList()
        : null;

    return paramsMap;
  }

  String _toHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
