import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../../../core/location/reverse_geocoding_service.dart';
import '../../../../shared/widgets/gradient_background.dart';

class LocationSelectionResult {
  const LocationSelectionResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  static const LatLng _jakartaPoint = LatLng(-6.200000, 106.816666);

  final MapController _mapController = MapController();
  LatLng? _selectedPoint;
  String? _selectedAddress;
  bool _isResolvingAddress = false;
  bool _isFetchingCurrentLocation = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedPoint = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resolveAddress(_selectedPoint!);
      });
    }
  }

  Future<void> _resolveAddress(LatLng point) async {
    setState(() {
      _isResolvingAddress = true;
    });

    final ReverseGeocodingService geocoding = context
        .read<ReverseGeocodingService>();
    final String address = await geocoding.getAddress(
      latitude: point.latitude,
      longitude: point.longitude,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedAddress = address;
      _isResolvingAddress = false;
    });
  }

  Future<void> _onMapTap(LatLng point) async {
    _applySelectedPoint(point);

    await _resolveAddress(point);
  }

  void _applySelectedPoint(LatLng point) {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedPoint = point;
      _selectedAddress = null;
    });

    try {
      _mapController.move(point, 15);
    } catch (_) {
      // Ignore move errors when map is not fully ready yet.
    }
  }

  bool _isNearlySamePoint(LatLng a, LatLng b) {
    final double latDiff = (a.latitude - b.latitude).abs();
    final double lonDiff = (a.longitude - b.longitude).abs();
    return latDiff < 0.0003 && lonDiff < 0.0003;
  }

  Future<void> _refreshCurrentLocationInBackground() async {
    try {
      final Position latest = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 12),
      );

      if (!mounted) {
        return;
      }

      final LatLng latestPoint = LatLng(latest.latitude, latest.longitude);
      final LatLng? existing = _selectedPoint;
      if (existing != null && _isNearlySamePoint(existing, latestPoint)) {
        return;
      }

      _applySelectedPoint(latestPoint);
      await _resolveAddress(latestPoint);
    } catch (_) {
      // Silent fallback to existing selected point.
    }
  }

  Future<void> _useCurrentLocation() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (_isFetchingCurrentLocation) {
      return;
    }

    setState(() {
      _isFetchingCurrentLocation = true;
    });

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage(l10n.locationServiceDisabledMessage);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage(l10n.locationPermissionDeniedMessage);
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(l10n.locationPermissionDeniedForeverMessage);
        return;
      }

      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        final LatLng quickPoint = LatLng(
          lastKnown.latitude,
          lastKnown.longitude,
        );
        _applySelectedPoint(quickPoint);
        if (mounted) {
          setState(() {
            _isFetchingCurrentLocation = false;
          });
        }

        unawaited(_resolveAddress(quickPoint));
        unawaited(_refreshCurrentLocationInBackground());
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 12),
      );

      if (!mounted) {
        return;
      }

      final LatLng point = LatLng(position.latitude, position.longitude);
      _applySelectedPoint(point);
      await _resolveAddress(point);
    } on TimeoutException {
      if (mounted) {
        _showMessage(l10n.failedToGetCurrentLocationMessage);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(l10n.failedToGetCurrentLocationMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingCurrentLocation = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveSelection() {
    final LatLng? point = _selectedPoint;
    if (point == null) {
      return;
    }

    Navigator.of(context).pop(
      LocationSelectionResult(
        latitude: point.latitude,
        longitude: point.longitude,
        address:
            _selectedAddress ??
            '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final LatLng center = _selectedPoint ?? _jakartaPoint;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.locationPickerTitle),
        actions: <Widget>[
          TextButton(
            onPressed: _selectedPoint == null ? null : _saveSelection,
            child: Text(l10n.saveLocationButton),
          ),
        ],
      ),
      body: GradientBackground(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 13,
                    minZoom: 3,
                    maxZoom: 18,
                    onTap: (TapPosition tapPosition, LatLng latLng) {
                      _onMapTap(latLng);
                    },
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.story_app',
                    ),
                    if (_selectedPoint != null)
                      MarkerLayer(
                        markers: <Marker>[
                          Marker(
                            point: _selectedPoint!,
                            width: 56,
                            height: 56,
                            child: const Icon(
                              Icons.location_on_rounded,
                              size: 52,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    RichAttributionWidget(
                      attributions: <SourceAttribution>[
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isFetchingCurrentLocation
                    ? null
                    : _useCurrentLocation,
                icon: _isFetchingCurrentLocation
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_rounded),
                label: Text(
                  _isFetchingCurrentLocation
                      ? l10n.findingMyLocationLabel
                      : l10n.useMyLocationButton,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.mapTapInstruction,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    if (_selectedPoint == null)
                      Text(
                        l10n.locationNotSelectedMessage,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else ...<Widget>[
                      Text(
                        l10n.selectedCoordinatesLabel(
                          _selectedPoint!.latitude.toStringAsFixed(5),
                          _selectedPoint!.longitude.toStringAsFixed(5),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      if (_isResolvingAddress)
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Text(
                          _selectedAddress ?? l10n.unknownAddressLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
