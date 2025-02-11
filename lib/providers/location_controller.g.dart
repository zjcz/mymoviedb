// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationHash() => r'f5ce09ade9253ab04ff4f4392a6fb677fd87b4d1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [location].
@ProviderFor(location)
const locationProvider = LocationFamily();

/// See also [location].
class LocationFamily extends Family<AsyncValue<Location?>> {
  /// See also [location].
  const LocationFamily();

  /// See also [location].
  LocationProvider call(
    int id,
  ) {
    return LocationProvider(
      id,
    );
  }

  @override
  LocationProvider getProviderOverride(
    covariant LocationProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'locationProvider';
}

/// See also [location].
class LocationProvider extends AutoDisposeFutureProvider<Location?> {
  /// See also [location].
  LocationProvider(
    int id,
  ) : this._internal(
          (ref) => location(
            ref as LocationRef,
            id,
          ),
          from: locationProvider,
          name: r'locationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$locationHash,
          dependencies: LocationFamily._dependencies,
          allTransitiveDependencies: LocationFamily._allTransitiveDependencies,
          id: id,
        );

  LocationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Location?> Function(LocationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocationProvider._internal(
        (ref) => create(ref as LocationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Location?> createElement() {
    return _LocationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocationRef on AutoDisposeFutureProviderRef<Location?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _LocationProviderElement
    extends AutoDisposeFutureProviderElement<Location?> with LocationRef {
  _LocationProviderElement(super.provider);

  @override
  int get id => (origin as LocationProvider).id;
}

String _$locationNameHash() => r'4a33a789b536ed3937115f0b7a4f7cb640483cf8';

/// See also [locationName].
@ProviderFor(locationName)
const locationNameProvider = LocationNameFamily();

/// See also [locationName].
class LocationNameFamily extends Family<AsyncValue<String>> {
  /// See also [locationName].
  const LocationNameFamily();

  /// See also [locationName].
  LocationNameProvider call(
    int id,
  ) {
    return LocationNameProvider(
      id,
    );
  }

  @override
  LocationNameProvider getProviderOverride(
    covariant LocationNameProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'locationNameProvider';
}

/// See also [locationName].
class LocationNameProvider extends AutoDisposeFutureProvider<String> {
  /// See also [locationName].
  LocationNameProvider(
    int id,
  ) : this._internal(
          (ref) => locationName(
            ref as LocationNameRef,
            id,
          ),
          from: locationNameProvider,
          name: r'locationNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$locationNameHash,
          dependencies: LocationNameFamily._dependencies,
          allTransitiveDependencies:
              LocationNameFamily._allTransitiveDependencies,
          id: id,
        );

  LocationNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<String> Function(LocationNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocationNameProvider._internal(
        (ref) => create(ref as LocationNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _LocationNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationNameProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocationNameRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _LocationNameProviderElement
    extends AutoDisposeFutureProviderElement<String> with LocationNameRef {
  _LocationNameProviderElement(super.provider);

  @override
  int get id => (origin as LocationNameProvider).id;
}

String _$locationControllerHash() =>
    r'b8a0be157c5557cb3298ed4f520866e8bf33af84';

/// See also [LocationController].
@ProviderFor(LocationController)
final locationControllerProvider = AutoDisposeStreamNotifierProvider<
    LocationController, List<Location>>.internal(
  LocationController.new,
  name: r'locationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocationController = AutoDisposeStreamNotifier<List<Location>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
