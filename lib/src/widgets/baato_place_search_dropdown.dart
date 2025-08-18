import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that provides a search field with auto-suggestion dropdown for places.
///
/// This widget creates a text field with a dropdown that shows suggestions as the user types.
/// It's designed to work with any type of data, making it flexible for different use cases.
///
/// Example usage:
/// ```dart
/// BaatoPlaceSearchDropdown<BaatoSearchPlace>(
///   suggestionsBuilder: (query) => searchPlaces(query),
///   itemBuilder: (place) => ListTile(
///     title: Text(place.name),
///     subtitle: Text(place.address),
///   ),
///   onSuggestionSelected: (place) {
///     print('Selected: ${place.name}');
///   },
/// )
/// ```
class BaatoPlaceSearchDropdown<T> extends StatefulWidget {
  /// The function that will be called to fetch suggestions based on the search query.
  /// It should return a Future that resolves to a list of suggestions.
  ///
  /// This is required and is the main data source for the dropdown.
  final Future<List<T>> Function(String query) suggestionsBuilder;

  /// The debounce duration to wait after typing before calling the suggestionsBuilder.
  ///
  /// This helps reduce unnecessary API calls while the user is still typing.
  /// Default is 300 milliseconds.
  final Duration debounceDuration;

  /// Initial text to display in the search field.
  ///
  /// If provided, the search field will be pre-filled with this text when first displayed.
  final String? initialText;

  /// Hint text to display when the search field is empty.
  ///
  /// Default is 'Search for a place'.
  final String? hintText;

  /// Decoration for the search input field.
  ///
  /// If not provided, a default decoration with search icon and optional clear button will be used.
  final InputDecoration? inputDecoration;

  /// Function to build the UI for each suggestion item.
  ///
  /// This function takes a suggestion of type T and should return a Widget to display it.
  final Widget Function(T suggestion) itemBuilder;

  /// Function called when a suggestion is selected.
  ///
  /// This callback receives the selected suggestion of type T.
  final void Function(T suggestion)? onSuggestionSelected;

  /// Maximum number of suggestions to display.
  ///
  /// Default is 5.
  final int maxSuggestions;

  /// Whether to show a clear button in the search field.
  ///
  /// Default is true.
  final bool showClearButton;

  /// Style for the suggestion items container.
  ///
  /// Controls the appearance of the dropdown box containing suggestions.
  final BoxDecoration? suggestionsBoxDecoration;

  /// Height of each suggestion item.
  ///
  /// Default is 50.0 pixels.
  final double itemHeight;

  /// Whether the search field should have focus when first displayed.
  ///
  /// Default is false.
  final bool autofocus;

  /// Text style for the search input.
  ///
  /// Controls the appearance of the text in the search field.
  final TextStyle? textStyle;

  /// Loading widget to display while fetching suggestions.
  ///
  /// If not provided, a default CircularProgressIndicator will be shown.
  final Widget? loadingBuilder;

  /// Widget to display when no suggestions are available.
  ///
  /// If not provided, a default "No results found" message will be shown.
  final Widget? noItemsFoundBuilder;

  /// Controller for the search text field.
  ///
  /// If not provided, a controller will be created internally.
  final TextEditingController? controller;

  /// Focus node for the search text field.
  ///
  /// If not provided, a focus node will be created internally.
  final FocusNode? focusNode;

  /// Widget to display at the top of the suggestions list.
  ///
  /// This can be used to add headers, filters, or other UI elements above the suggestions.
  final Widget? suggestionsHeader;

  /// Widget to display at the bottom of the suggestions list.
  ///
  /// This can be used to add footers, pagination controls, or other UI elements below the suggestions.
  final Widget? suggestionsFooter;

  /// Padding for the suggestions header.
  ///
  /// Default is symmetric padding with 8.0 vertical and 16.0 horizontal.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding for the suggestions footer.
  ///
  /// Default is symmetric padding with 8.0 vertical and 16.0 horizontal.
  final EdgeInsetsGeometry? footerPadding;

  /// Whether the header should be sticky (fixed at the top).
  ///
  /// If true, the header will remain visible at the top when scrolling through suggestions.
  /// Default is false.
  final bool stickyHeader;

  /// Whether the footer should be sticky (fixed at the bottom).
  ///
  /// If true, the footer will remain visible at the bottom when scrolling through suggestions.
  /// Default is false.
  final bool stickyFooter;

  /// Callback function when focus state changes.
  ///
  /// This is called whenever the search field gains or loses focus.
  /// The boolean parameter indicates whether the field has focus.
  final Function(bool hasFocus)? onFocusChanged;

  /// Creates a BaatoPlaceSearchDropdown widget.
  ///
  /// The [suggestionsBuilder] and [itemBuilder] parameters are required.
  const BaatoPlaceSearchDropdown({
    super.key,
    required this.suggestionsBuilder,
    required this.itemBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.initialText,
    this.hintText = 'Search for a place',
    this.inputDecoration,
    this.onSuggestionSelected,
    this.maxSuggestions = 5,
    this.showClearButton = true,
    this.suggestionsBoxDecoration,
    this.itemHeight = 50.0,
    this.autofocus = false,
    this.textStyle,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.controller,
    this.focusNode,
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
    this.onFocusChanged,
  });

  @override
  State<BaatoPlaceSearchDropdown<T>> createState() =>
      _BaatoPlaceSearchDropdownState<T>();
}

/// The state for the BaatoPlaceSearchDropdown widget.
class _BaatoPlaceSearchDropdownState<T>
    extends State<BaatoPlaceSearchDropdown<T>> {
  /// Controller for the search text field
  late TextEditingController _controller;

  /// Focus node for the search text field
  late FocusNode _focusNode;

  /// Timer for debouncing search input
  Timer? _debounceTimer;

  /// List of current suggestions
  List<T> _suggestions = [];

  /// Whether suggestions are currently being loaded
  bool _isLoading = false;

  /// Whether to show the suggestions dropdown
  bool _showSuggestions = false;

  /// Link to position the overlay relative to the search field
  final LayerLink _layerLink = LayerLink();

  /// The overlay entry for the suggestions dropdown
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  /// Handles focus changes for the search field
  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _getSuggestions(_controller.text);
    } else {
      _removeOverlay();
    }

    // Call the focus changed callback if provided
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  /// Handles text changes in the search field with debouncing
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      _getSuggestions(query);
    });
  }

  /// Fetches suggestions based on the search query
  Future<void> _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      _updateOverlay();
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _updateOverlay();

    try {
      final results = await widget.suggestionsBuilder(query);
      setState(() {
        _suggestions = results.take(widget.maxSuggestions).toList();
        _isLoading = false;
        _showSuggestions = true;
      });
    } catch (e) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
    }
    _updateOverlay();
  }

  /// Handles selection of a suggestion
  void _onSuggestionSelected(T suggestion) {
    widget.onSuggestionSelected?.call(suggestion);
    _removeOverlay();
    _focusNode.unfocus();
  }

  /// Updates the overlay with the current suggestions
  void _updateOverlay() {
    _removeOverlay();
    if (!_focusNode.hasFocus ||
        (!_isLoading && _suggestions.isEmpty && !_showSuggestions)) {
      return;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            elevation: 4.0,
            child: Container(
              decoration: widget.suggestionsBoxDecoration ??
                  BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
              child: _buildSuggestionsContainer(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsContainer() {
    final hasHeader = widget.suggestionsHeader != null;
    final hasFooter = widget.suggestionsFooter != null;

    if (widget.stickyHeader || widget.stickyFooter) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader && widget.stickyHeader)
            Padding(
              padding: widget.headerPadding!,
              child: widget.suggestionsHeader!,
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: widget.itemHeight * widget.maxSuggestions +
                    (hasHeader && !widget.stickyHeader ? 50.0 : 0.0) +
                    (hasFooter && !widget.stickyFooter ? 50.0 : 0.0),
              ),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  if (hasHeader && !widget.stickyHeader)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: widget.headerPadding!,
                        child: widget.suggestionsHeader!,
                      ),
                    ),
                  SliverToBoxAdapter(child: _buildSuggestionsWidget()),
                  if (hasFooter && !widget.stickyFooter)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: widget.footerPadding!,
                        child: widget.suggestionsFooter!,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (hasFooter && widget.stickyFooter)
            Padding(
              padding: widget.footerPadding!,
              child: widget.suggestionsFooter!,
            ),
        ],
      );
    } else {
      // Default scrollable behavior for both header and footer
      return Container(
        constraints: BoxConstraints(
          maxHeight: widget.itemHeight * widget.maxSuggestions +
              (hasHeader ? 50.0 : 0.0) +
              (hasFooter ? 50.0 : 0.0),
        ),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            if (hasHeader)
              SliverToBoxAdapter(
                child: Padding(
                  padding: widget.headerPadding!,
                  child: widget.suggestionsHeader!,
                ),
              ),
            SliverToBoxAdapter(child: _buildSuggestionsWidget()),
            if (hasFooter)
              SliverToBoxAdapter(
                child: Padding(
                  padding: widget.footerPadding!,
                  child: widget.suggestionsFooter!,
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildSuggestionsWidget() {
    if (_isLoading) {
      return widget.loadingBuilder ??
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(),
            ),
          );
    } else if (_suggestions.isEmpty) {
      return widget.noItemsFoundBuilder ??
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No results found'),
          );
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics:
            NeverScrollableScrollPhysics(), // Disable scrolling as parent handles it
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return InkWell(
            onTap: () => _onSuggestionSelected(suggestion),
            child: SizedBox(
              height: widget.itemHeight,
              child: widget.itemBuilder(suggestion),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: widget.textStyle,
        autofocus: widget.autofocus,
        decoration: widget.inputDecoration ??
            InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.showClearButton && _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _suggestions = [];
                          _showSuggestions = false;
                        });
                        _removeOverlay();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
        onChanged: _onSearchChanged,
        onTap: () {
          if (_controller.text.isNotEmpty) {
            _getSuggestions(_controller.text);
          }
        },
      ),
    );
  }
}
