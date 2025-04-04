import 'dart:async';
import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/baato.dart';
import 'package:baato_maps/src/widgets/baato_place_search_dropdown.dart';
import 'package:flutter/material.dart';

class BaatoPlaceAutoSuggestion extends StatefulWidget {
  /// The API key for Baato services (optional, will use BaatoMapConfiguration if not provided)
  final String? apiKey;

  /// Optional API base URL
  final String? apiBaseUrl;

  /// Optional app ID for authentication
  final String? appId;

  /// Optional security code for authentication
  final String? securityCode;

  /// Optional API version
  final String? apiVersion;

  /// Callback when a place is selected
  final Function(BaatoSearchPlace) onPlaceSelected;

  /// Callback when place details are fetched after selection
  final Function(BaatoPlace)? onPlaceDetailsRetrieved;

  /// Callback when focus changes
  final Function(bool)? onFocusChanged;

  /// Hint text for the search field
  final String? hintText;

  /// Optional place type filter
  final String? type;

  /// Maximum number of suggestions to show
  final int limit;

  /// Optional search radius in meters
  final int? radius;

  /// Optional latitude for location-based search
  final BaatoCoordinate? currentCoordinate;

  /// Debounce duration for search queries
  final Duration debounceDuration;

  /// Custom decoration for the text field
  final InputDecoration? inputDecoration;

  /// Custom style for suggestion items
  final TextStyle? suggestionTextStyle;

  /// Custom style for suggestion address text
  final TextStyle? suggestionAddressTextStyle;

  /// Custom builder for suggestion items
  final Widget Function(BuildContext, BaatoSearchPlace)? suggestionBuilder;

  /// Optional header widget for suggestions list
  final Widget? suggestionsHeader;

  /// Optional footer widget for suggestions list
  final Widget? suggestionsFooter;

  /// Padding for the suggestions header
  final EdgeInsetsGeometry? headerPadding;

  /// Padding for the suggestions footer
  final EdgeInsetsGeometry? footerPadding;

  /// Whether the header should be sticky (fixed at the top)
  final bool stickyHeader;

  /// Whether the footer should be sticky (fixed at the bottom)
  final bool stickyFooter;

  /// Initial selected place
  final BaatoSearchPlace? initialSelection;

  const BaatoPlaceAutoSuggestion({
    Key? key,
    this.apiKey,
    required this.onPlaceSelected,
    this.onPlaceDetailsRetrieved,
    this.onFocusChanged,
    this.apiBaseUrl,
    this.appId,
    this.securityCode,
    this.apiVersion,
    this.hintText = 'Search for a place',
    this.type,
    this.limit = 5,
    this.radius,
    this.currentCoordinate,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.inputDecoration,
    this.suggestionTextStyle,
    this.suggestionAddressTextStyle,
    this.suggestionBuilder,
    this.suggestionsHeader,
    this.suggestionsFooter,
    this.headerPadding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    this.footerPadding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    this.stickyHeader = false,
    this.stickyFooter = false,
    this.initialSelection,
  }) : super(key: key);

  @override
  State<BaatoPlaceAutoSuggestion> createState() =>
      _BaatoPlaceAutoSuggestionState();
}

class _BaatoPlaceAutoSuggestionState extends State<BaatoPlaceAutoSuggestion> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: widget.initialSelection?.name ?? '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged!(_focusNode.hasFocus);
    }
  }

  Future<List<BaatoSearchPlace>> _searchPlaces(String query) async {
    if (query.isEmpty) return [];
    try {
      final response = await Baato.api.place.search(
        query,
        type: widget.type,
        limit: widget.limit,
        radius: widget.radius,
        currentCoordinate: widget.currentCoordinate,
      );

      return response.data ?? [];
    } catch (e) {
      debugPrint('Error searching places: $e');
      return [];
    }
  }

  Future<void> _fetchPlaceDetails(int placeId) async {
    if (widget.onPlaceDetailsRetrieved == null) return;

    try {
      final placeResponse = await Baato.api.place.getDetail(placeId);
      if (placeResponse.data != null && placeResponse.data!.isNotEmpty) {
        widget.onPlaceDetailsRetrieved!(placeResponse.data!.first);
      }
    } catch (e) {
      debugPrint('Error fetching place details: $e');
    }
  }

  void _handleSuggestionSelected(BaatoSearchPlace suggestion) {
    _textController.text = suggestion.name;
    widget.onPlaceSelected(suggestion);

    // Fetch place details if callback is provided
    if (widget.onPlaceDetailsRetrieved != null) {
      _fetchPlaceDetails(suggestion.placeId);
    }

    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BaatoPlaceSearchDropdown<BaatoSearchPlace>(
      suggestionsBuilder: _searchPlaces,
      debounceDuration: widget.debounceDuration,
      hintText: widget.hintText,
      inputDecoration: widget.inputDecoration,
      maxSuggestions: widget.limit,
      showClearButton: true,
      autofocus: false,
      itemHeight: 64,
      controller: _textController,
      focusNode: _focusNode,
      initialText: widget.initialSelection?.name,
      suggestionsHeader: widget.suggestionsHeader,
      suggestionsFooter: widget.suggestionsFooter,
      headerPadding: widget.headerPadding,
      footerPadding: widget.footerPadding,
      stickyHeader: widget.stickyHeader,
      stickyFooter: widget.stickyFooter,
      itemBuilder: (suggestion) {
        if (widget.suggestionBuilder != null) {
          return widget.suggestionBuilder!(context, suggestion);
        }

        final String distanceText =
            suggestion.radialDistanceInKm > 0.01
                ? '${suggestion.radialDistanceInKm.toStringAsFixed(2)} km'
                : '';

        return ListTile(
          leading:
              distanceText.isEmpty
                  ? null
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      if (distanceText.isNotEmpty)
                        Text(
                          distanceText,
                          style: const TextStyle(fontSize: 10),
                        ),
                    ],
                  ),
          title: Text(
            suggestion.name,
            style:
                widget.suggestionTextStyle ??
                const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          subtitle: Text(
            suggestion.address,
            style:
                widget.suggestionAddressTextStyle ??
                TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          onTap: () {
            _handleSuggestionSelected(suggestion);
          },
        );
      },
      onSuggestionSelected: _handleSuggestionSelected,
      loadingBuilder: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CircularProgressIndicator(),
        ),
      ),
      noItemsFoundBuilder: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No places found'),
      ),
      suggestionsBoxDecoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
