import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class InheritedFeatures extends InheritedModel<String> {
  const InheritedFeatures({
    Key? key,
    required this.flags,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  final List<String> flags;

  @override
  bool updateShouldNotify(covariant InheritedFeatures oldWidget) {
    return !const ListEquality<String>().equals(flags, oldWidget.flags);
  }

  @override
  bool updateShouldNotifyDependent(
    covariant InheritedFeatures oldWidget,
    Set<String> dependencies,
  ) {
    for (var dependency in dependencies) {
      if (flags.contains(dependency) != oldWidget.flags.contains(dependency)) {
        return true;
      }
    }

    return false;
  }
}
