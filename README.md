
# feature_flags

This package allows you to simply dynamically activate different functionalities of your app.

# Usage

## Setup

Wrap your app's widget in a `Features` widget.

```dart
Features(
    child: MaterialApp(
        /// ...
    ),
);
```

## Testing if a feature is enabled

To test is a feature is currently enabled, use the `Features.isFeatureEnabled` function with a unique functionality identifier.

```dart
if (Features.isFeatureEnabled(context, 'DECREMENT')) {
    /// The 'DECREMENT' feature is enabled
}
```

## Enable or disable a feature

### From the `Features` widget

By updating the `flags` from the `Features` widget.

```dart
Features(
    flags: [ 'DECREMENT' ],
    child: MaterialApp(
        /// ...
    ),
);
```

### Enabling it locally from code

You can activate a feature by calling the `Features.setFeature` function. The feature flag is saved into shared preferences and is persisted between sessions.

```dart
Features.setFeature(
    context,
    'DECREMENT',
    true,
);
```

### Using the debug view

The debug view allows your users to activate or deactivate any dynamic feature.

> This may be useful during development, but it should be used carefully.

```dart
DebugFeatures.show(
    context,
    availableFeatures: [
        Feature('DECREMENT', name: 'Decrement'),
        Feature('RESET', name: 'Reset'),
    ],
);
```
