import 'package:feature_flags/feature_flags.dart';
import 'package:flutter/material.dart';

class Feature {
  const Feature(
    this.id, {
    this.name,
  });
  final String id;
  final String? name;
}

class DebugFeatures extends StatelessWidget {
  const DebugFeatures({
    Key? key,
    required this.availableFeatures,
    this.title = 'Feature flags',
  }) : super(key: key);

  final String title;
  final List<Feature> availableFeatures;

  static Future<void> show(
    BuildContext context, {
    required List<Feature> availableFeatures,
    String title = 'Feature flags',
  }) {
    final errorDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ), //this right here
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: DebugFeatures(
          title: title,
          availableFeatures: availableFeatures,
        ),
      ),
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) => errorDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Features.reset(context);
              },
              child: Text('Reset'),
            )
          ],
        ),
        body: ListView(
          children: [
            ...availableFeatures.map(
              (feature) => DebugFeatureTile(
                feature: feature,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DebugFeatureTile extends StatelessWidget {
  const DebugFeatureTile({
    Key? key,
    required this.feature,
  }) : super(key: key);

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    final isEnabled = Features.isFeatureEnabled(context, feature.id);
    return ListTile(
      title: Text(feature.name ?? feature.id),
      subtitle: feature.name != null ? Text(feature.id) : null,
      onTap: () {
        Features.setFeature(
          context,
          feature.id,
          !isEnabled,
        );
      },
      trailing: Checkbox(
        value: isEnabled,
        onChanged: (newValue) {
          if (newValue != null)
            Features.setFeature(
              context,
              feature.id,
              newValue,
            );
        },
      ),
    );
  }
}
