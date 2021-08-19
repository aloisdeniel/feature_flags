import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'debug_view.dart';
import 'inherited_features.dart';

class Features extends StatefulWidget {
  const Features({
    Key? key,
    required this.child,
    this.flags = const <String>[],
    this.sharedPreferencesKey = 'feature_flags',
  }) : super(key: key);

  final List<String> flags;
  final Widget child;
  final String sharedPreferencesKey;

  /// Allows to enable or disable the feature with the given [id].
  ///
  /// Its new [isEnabled] status is saved into local preferences and so it
  /// is persisted between app sessions.
  static void setFeature(
    BuildContext context,
    String id,
    bool isEnabled,
  ) async {
    final state = context.findAncestorStateOfType<_FeaturesState>();
    await state!.setFeature(id, isEnabled);
  }

  /// Indicates whether the feature with the given [id] is currently enabled.
  ///
  /// The feature can be enabled :
  ///  * from the [Features] 's constructor by passing [id] as [flags] parameter.
  ///  * by calling [setFeature] with [id]
  ///  * by showing the debug view with [showDebugView] with a declared [Feature].
  static bool isFeatureEnabled(BuildContext context, String id) {
    final state = InheritedModel.inheritFrom<InheritedFeatures>(
      context,
      aspect: id,
    );
    return state!.flags.contains(id);
  }

  /// Shows a debug view that allows to activate or deactive the given [availableFeatures].
  ///
  /// The [title] can be customized.
  static Future<void> showDebugView(
    BuildContext context, {
    required List<Feature> availableFeatures,
    String title = 'Feature flags',
  }) =>
      DebugFeatures.show(
        context,
        availableFeatures: availableFeatures,
        title: title,
      );

  static void reset(BuildContext context) {
    final state = context.findAncestorStateOfType<_FeaturesState>();
    state!.reset();
  }

  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  List<String> localFlags = const <String>[];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _loadPreferences();
    });
    super.initState();
  }

  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    final localFlags = preferences.get(widget.sharedPreferencesKey);
    if (localFlags != null) {
      setState(() {
        this.localFlags =
            '$localFlags'.split(',').where((x) => x.isNotEmpty).toList();
      });
    }
  }

  Future<void> setFeature(String id, bool isEnabled) async {
    final newLocalFlags = [
      ...localFlags.where((flag) => flag != id),
      if (isEnabled) id,
    ];
    setState(() {
      this.localFlags = newLocalFlags;
    });
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      widget.sharedPreferencesKey,
      newLocalFlags.join(','),
    );
  }

  Future<void> reset() async {
    setState(() {
      this.localFlags = [];
    });
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(widget.sharedPreferencesKey);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedFeatures(
      flags: [
        ...widget.flags,
        ...localFlags,
      ],
      child: widget.child,
    );
  }
}
