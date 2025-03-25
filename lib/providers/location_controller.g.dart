// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getLocationHash() => r'af1a8e1fa973411c29c8884f3908a52f3047a644';

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

/// See also [getLocation].
@ProviderFor(getLocation)
const getLocationProvider = GetLocationFamily();

/// See also [getLocation].
class GetLocationFamily extends Family<AsyncValue<Location?>> {
  /// See also [getLocation].
  const GetLocationFamily();

  /// See also [getLocation].
  GetLocationProvider call(
    int id,
  ) {
    return GetLocationProvider(
      id,
    );
  }

  @override
  GetLocationProvider getProviderOverride(
    covariant GetLocationProvider provider,
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
  String? get name => r'getLocationProvider';
}

/// See also [getLocation].
class GetLocationProvider extends AutoDisposeFutureProvider<Location?> {
  /// See also [getLocation].
  GetLocationProvider(
    int id,
  ) : this._internal(
          (ref) => getLocation(
            ref as GetLocationRef,
            id,
          ),
          from: getLocationProvider,
          name: r'getLocationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getLocationHash,
          dependencies: GetLocationFamily._dependencies,
          allTransitiveDependencies:
              GetLocationFamily._allTransitiveDependencies,
          id: id,
        );

  GetLocationProvider._internal(
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
    FutureOr<Location?> Function(GetLocationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetLocationProvider._internal(
        (ref) => create(ref as GetLocationRef),
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
    return _GetLocationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLocationProvider && other.id == id;
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
mixin GetLocationRef on AutoDisposeFutureProviderRef<Location?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _GetLocationProviderElement
    extends AutoDisposeFutureProviderElement<Location?> with GetLocationRef {
  _GetLocationProviderElement(super.provider);

  @override
  int get id => (origin as GetLocationProvider).id;
}

String _$getLocationNameHash() => r'c0fc758f608738928f83fee32d8d8d6658b01044';

/// See also [getLocationName].
@ProviderFor(getLocationName)
const getLocationNameProvider = GetLocationNameFamily();

/// See also [getLocationName].
class GetLocationNameFamily extends Family<AsyncValue<String>> {
  /// See also [getLocationName].
  const GetLocationNameFamily();

  /// See also [getLocationName].
  GetLocationNameProvider call(
    int id,
  ) {
    return GetLocationNameProvider(
      id,
    );
  }

  @override
  GetLocationNameProvider getProviderOverride(
    covariant GetLocationNameProvider provider,
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
  String? get name => r'getLocationNameProvider';
}

/// See also [getLocationName].
class GetLocationNameProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getLocationName].
  GetLocationNameProvider(
    int id,
  ) : this._internal(
          (ref) => getLocationName(
            ref as GetLocationNameRef,
            id,
          ),
          from: getLocationNameProvider,
          name: r'getLocationNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getLocationNameHash,
          dependencies: GetLocationNameFamily._dependencies,
          allTransitiveDependencies:
              GetLocationNameFamily._allTransitiveDependencies,
          id: id,
        );

  GetLocationNameProvider._internal(
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
    FutureOr<String> Function(GetLocationNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetLocationNameProvider._internal(
        (ref) => create(ref as GetLocationNameRef),
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
    return _GetLocationNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLocationNameProvider && other.id == id;
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
mixin GetLocationNameRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _GetLocationNameProviderElement
    extends AutoDisposeFutureProviderElement<String> with GetLocationNameRef {
  _GetLocationNameProviderElement(super.provider);

  @override
  int get id => (origin as GetLocationNameProvider).id;
}

String _$locationControllerHash() =>
    r'74fb2132c83b86e73d96c7fed4f79dbbed07278f';

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
