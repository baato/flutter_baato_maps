import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/constants/baato_map_style.dart';
import 'package:baato_maps/src/model/baato_map_feature.dart';
import 'package:baato_maps/src/model/baato_camera_position.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:baato_maps/src/map/baato_map_controller.dart';

/// A widget that displays a Baato map.
///
/// This widget provides a customizable map interface with various interaction capabilities
/// such as tapping, long-pressing, and location tracking.
class BaatoMap extends StatelessWidget {
  /// Creates a BaatoMap with the specified parameters.
  ///
  /// The [initialPosition] parameter is required and specifies the initial center point of the map.
  /// Other parameters are optional and provide additional customization of the map's behavior.
  BaatoMap({
    super.key,
    required this.initialPosition,
    this.initialZoom = 12.0,
    BaatoMapStyle? style,
    this.myLocationEnabled = false,
    this.poiLayerContainIds = const ["Poi", "BusStop"],
    this.enableLayerDetection = true,
    this.onMapCreated,
    this.onTap,
    this.onLongPress,
    this.gestureRecognizers,
    this.onMapClick,
    this.onMapLongClick,
    this.onUserLocationUpdated,
    this.onCameraTrackingDismissed,
    this.onCameraTrackingChanged,
    this.onCameraIdle,
    this.onMapIdle,
    this.onStyleLoadedCallback,
    this.iosLongClickDuration,
    this.compassEnabled = true,
    this.dragEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.doubleClickZoomEnabled,
    this.trackCameraPosition = false,
    this.myLocationTrackingMode = MyLocationTrackingMode.none,
    this.myLocationRenderMode = MyLocationRenderMode.normal,
    this.logoViewMargins,
    this.compassViewPosition,
    this.compassViewMargins,
    this.attributionButtonPosition,
    this.attributionButtonMargins,
    this.annotationOrder = const [
      AnnotationType.fill,
      AnnotationType.line,
      AnnotationType.circle,
      AnnotationType.symbol,
    ],
    this.annotationConsumeTapEvents = const [
      AnnotationType.fill,
      AnnotationType.line,
      AnnotationType.circle,
      AnnotationType.symbol,
    ],
  }) : _baatoController =
            BaatoMapController(style ?? BaatoMapStyle.defaultStyle);

  /// The initial geographic position of the map's center.
  final BaatoCoordinate initialPosition;

  /// The initial zoom level of the map.
  /// Higher values zoom in closer to the map.
  final double initialZoom;

  /// Whether to show the user's current location on the map.
  final bool myLocationEnabled;

  /// List of layer ID prefixes to identify POI (Points of Interest) layers.
  /// Used for feature detection when tapping on the map.
  final List<String> poiLayerContainIds;

  /// Whether to enable detection of map features when interacting with the map.
  final bool enableLayerDetection;

  /// Callback that is called when the map is created and ready to use.
  final Function(BaatoMapController)? onMapCreated;

  /// Callback that is called when the user taps on the map.
  /// Provides the screen point, geographic coordinate, and any detected map features.
  final void Function(Point<double>, BaatoCoordinate, List<BaatoMapFeature>)?
      onTap;

  /// Callback that is called when the user long-presses on the map.
  /// Provides the screen point, geographic coordinate, and any detected map features.
  final void Function(Point<double>, BaatoCoordinate, List<BaatoMapFeature>)?
      onLongPress;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// Callback for when the map is clicked.
  /// This is a direct pass-through to the underlying MapLibre map.
  final OnMapClickCallback? onMapClick;

  /// Callback for when the map is long-clicked.
  /// This is a direct pass-through to the underlying MapLibre map.
  final OnMapClickCallback? onMapLongClick;

  /// While the `myLocationEnabled` property is set to `true`, this method is
  /// called whenever a new location update is received by the map view.
  final OnUserLocationUpdated? onUserLocationUpdated;

  /// Called when the map's camera no longer follows the physical device location, e.g. because the user moved the map
  final OnCameraTrackingDismissedCallback? onCameraTrackingDismissed;

  /// Called when the location tracking mode changes
  final OnCameraTrackingChangedCallback? onCameraTrackingChanged;

  // Called when camera movement has ended.
  final OnCameraIdleCallback? onCameraIdle;

  /// Called when map view is entering an idle state, and no more drawing will
  /// be necessary until new data is loaded or there is some interaction with
  /// the map.
  /// * No camera transitions are in progress
  /// * All currently requested tiles have loaded
  /// * All fade/transition animations have completed
  final OnMapIdleCallback? onMapIdle;

  /// Defines the layer order of annotations displayed on map
  ///
  /// Any annotation type can only be contained once, so 0 to 4 types
  ///
  /// Note that setting this to be empty gives a big perfomance boost for
  /// android. However if you do so annotations will not work.
  final List<AnnotationType> annotationOrder;

  /// Defines the layer order of click annotations
  ///
  /// (must contain at least 1 annotation type, 4 items max)
  final List<AnnotationType> annotationConsumeTapEvents;

  /// Called when the map style has been successfully loaded and the annotation managers have been enabled.
  /// Please note: you should only add annotations (e.g. symbols or circles) after this callback has been called.
  final OnStyleLoadedCallback? onStyleLoadedCallback;

  /// How long a user has to click the map **on iOS** until a long click is registered.
  /// Has no effect on web or Android. Can not be changed at runtime, only the initial value is used.
  /// If null, the default value of the native MapLibre library / of the OS is used.
  final Duration? iosLongClickDuration;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if drag functionality should be enabled.
  ///
  /// Disable to avoid performance issues that from the drag event listeners.
  /// Biggest impact in android
  final bool dragEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Set to true to forcefully disable/enable if map should respond to double
  /// click to zoom.
  ///
  /// This takes presedence over zoomGesturesEnabled. Only supported for web.
  final bool? doubleClickZoomEnabled;

  /// True if you want to be notified of map camera movements by the [MapLibreMapController]. Default is false.
  ///
  /// If this is set to true and the user pans/zooms/rotates the map, [MapLibreMapController] (which is a [ChangeNotifier])
  /// will notify it's listeners and you can then get the new [MapLibreMapController].cameraPosition.
  final bool trackCameraPosition;

  /// The mode used to let the map's camera follow the device's physical location.
  /// `myLocationEnabled` needs to be true for values other than `MyLocationTrackingMode.None` to work.
  final MyLocationTrackingMode myLocationTrackingMode;

  /// Specifies if and how the user's heading/bearing is rendered in the user location indicator.
  /// See the documentation of [MyLocationRenderMode] for details.
  /// If this is set to a value other than [MyLocationRenderMode.normal], [myLocationEnabled] needs to be true.
  final MyLocationRenderMode myLocationRenderMode;

  /// Set the layout margins for the Logo
  final Point? logoViewMargins;

  /// Set the position for the Compass
  final CompassViewPosition? compassViewPosition;

  /// Set the layout margins for the Compass
  final Point? compassViewMargins;

  /// Set the position for the MapLibre Attribution Button
  /// When set to null, the default value of the underlying MapLibre libraries is used,
  /// which differs depending on the operating system the app is being run on.
  final AttributionButtonPosition? attributionButtonPosition;

  /// Set the layout margins for the MapLibre Attribution Buttons. If you set this
  /// value, you may also want to set [attributionButtonPosition] to harmonize
  /// the layout between iOS and Android, since the underlying frameworks have
  /// different defaults.
  final Point? attributionButtonMargins;

  /// The controller for the Baato map.
  final BaatoMapController _baatoController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BaatoMapStyle>(
      valueListenable: _baatoController.styleManager.styleNotifier,
      builder: (context, style, child) {
        final lastCameraPosition = null;
        final cameraPosition = CameraPosition(
          target: LatLng(
            lastCameraPosition?.target.latitude ?? initialPosition.latitude,
            lastCameraPosition?.target.longitude ?? initialPosition.longitude,
          ),
          zoom: lastCameraPosition?.zoom ?? initialZoom,
        );
        return MapLibreMap(
          key: ValueKey(style.styleURL),
          initialCameraPosition: cameraPosition,
          styleString: style.styleURL,
          myLocationEnabled: myLocationEnabled,
          onMapCreated: (controller) async {
            await _baatoController.setController(controller,
                poiLayerContainIds:
                    enableLayerDetection ? poiLayerContainIds : null);

            onMapCreated?.call(_baatoController);
          },
          onMapClick: (point, latLng) async {
            final List<BaatoMapFeature> features = enableLayerDetection
                ? (await _baatoController.queryPOIFeatures(point))
                : [];
            onTap?.call(
              point,
              BaatoCoordinate(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              ),
              features,
            );
          },
          onMapLongClick: (point, latLng) async {
            final List<BaatoMapFeature> features = enableLayerDetection
                ? await _baatoController.queryPOIFeatures(point)
                : [];
            onLongPress?.call(
              point,
              BaatoCoordinate(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              ),
              features,
            );
          },
          onUserLocationUpdated: onUserLocationUpdated,
          onCameraTrackingChanged: onCameraTrackingChanged,
          onCameraTrackingDismissed: onCameraTrackingDismissed,
          onCameraIdle: () {
            final position = _baatoController.rawController?.cameraPosition;
            if (position != null) {
              _baatoController.cameraManager?.setLastCameraPosition(
                BaatoCameraPosition(
                  target: BaatoCoordinate(
                    latitude: position.target.latitude,
                    longitude: position.target.longitude,
                  ),
                ),
              );
            }
            _baatoController.rawController?.invalidateAmbientCache();
            onCameraIdle?.call();
          },
          onMapIdle: onMapIdle,
          gestureRecognizers: gestureRecognizers,
          annotationOrder: annotationOrder,
          annotationConsumeTapEvents: annotationConsumeTapEvents,
          onStyleLoadedCallback: onStyleLoadedCallback,
          iosLongClickDuration: iosLongClickDuration,
          compassEnabled: compassEnabled,
          dragEnabled: dragEnabled,
          cameraTargetBounds: cameraTargetBounds,
          minMaxZoomPreference: minMaxZoomPreference,
          rotateGesturesEnabled: rotateGesturesEnabled,
          scrollGesturesEnabled: scrollGesturesEnabled,
          zoomGesturesEnabled: zoomGesturesEnabled,
          tiltGesturesEnabled: tiltGesturesEnabled,
          doubleClickZoomEnabled: doubleClickZoomEnabled,
          trackCameraPosition: trackCameraPosition,
          myLocationTrackingMode: myLocationTrackingMode,
          myLocationRenderMode: myLocationRenderMode,
          logoViewMargins: logoViewMargins,
          compassViewPosition: compassViewPosition,
          compassViewMargins: compassViewMargins,
          attributionButtonPosition: attributionButtonPosition,
          attributionButtonMargins: attributionButtonMargins,
        );
      },
    );
  }
}
