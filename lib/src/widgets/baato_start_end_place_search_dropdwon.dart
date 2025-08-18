import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that provides a search interface for route planning with start, end,
/// and optional midpoint locations.
///
/// This widget creates a complete UI for route planning with search functionality,
/// including:
/// - Start location field
/// - End location field
/// - Optional midpoint/stop locations
/// - Location swapping
/// - Autocomplete suggestions
///
/// The widget handles all the UI interactions and calls the provided callbacks
/// when locations are selected or changed.
class BaatoStartEndPlaceSearchDropdown<T> extends StatefulWidget {
  /// The function that will be called to fetch suggestions based on the search query.
  ///
  /// This function should return a Future that resolves to a list of suggestions
  /// of type T. It receives the current search query as a parameter.
  final Future<List<T>> Function(String query) suggestionsBuilder;

  /// The debounce duration to wait after typing before calling the suggestionsBuilder.
  ///
  /// This helps reduce the number of API calls by waiting until the user has
  /// stopped typing for this duration.
  final Duration debounceDuration;

  /// Initial text to display in the start location field.
  final String? initialStartText;

  /// Initial text to display in the end location field.
  final String? initialEndText;

  /// Hint text to display when the start location field is empty.
  final String? startHintText;

  /// Hint text to display when the end location field is empty.
  final String? endHintText;

  /// Hint text to display when a midpoint field is empty.
  final String? midpointHintText;

  /// Decoration for the search input fields.
  ///
  /// If not provided, a default decoration will be used.
  final InputDecoration? inputDecoration;

  /// Function to build the UI for each suggestion item.
  ///
  /// This function receives a suggestion of type T and should return a Widget
  /// that represents how the suggestion should be displayed in the dropdown.
  final Widget Function(T suggestion) itemBuilder;

  /// Function called when a start location suggestion is selected.
  ///
  /// This function receives the selected suggestion of type T.
  final void Function(T suggestion)? onStartSuggestionSelected;

  /// Function called when an end location suggestion is selected.
  ///
  /// This function receives the selected suggestion of type T.
  final void Function(T suggestion)? onEndSuggestionSelected;

  /// Function called when a midpoint suggestion is selected.
  ///
  /// This function receives the selected suggestion of type T and the index
  /// of the midpoint in the list of midpoints.
  final void Function(T suggestion, int index)? onMidpointSuggestionSelected;

  /// Function called when locations are swapped.
  ///
  /// This function receives the new start and end location texts after swapping.
  final void Function(String? start, String? end)? onLocationsSwapped;

  /// Function called when a midpoint is added.
  ///
  /// This is called after a new midpoint field is added to the UI.
  final void Function()? onMidpointAdded;

  /// Function called when a midpoint is removed.
  ///
  /// This function receives the index of the removed midpoint.
  final void Function(int index)? onMidpointRemoved;

  /// Maximum number of suggestions to display.
  ///
  /// This limits the number of items shown in the dropdown list.
  final int maxSuggestions;

  /// Whether to show a clear button in the search fields.
  ///
  /// When true, a clear button will appear in each field when it contains text.
  final bool showClearButton;

  /// Style for the suggestion items container.
  ///
  /// This decoration is applied to the container that holds the suggestion list.
  final BoxDecoration? suggestionsBoxDecoration;

  /// Height of each suggestion item.
  ///
  /// This determines the height of each item in the suggestion dropdown.
  final double itemHeight;

  /// Whether the search fields should have focus when first displayed.
  ///
  /// When true, the start location field will be focused when the widget is first shown.
  final bool autofocus;

  /// Text style for the search inputs.
  ///
  /// This style is applied to the text in all search fields.
  final TextStyle? textStyle;

  /// Loading widget to display while fetching suggestions.
  ///
  /// This widget is shown in the dropdown while waiting for suggestions to load.
  final Widget? loadingBuilder;

  /// Widget to display when no suggestions are available.
  ///
  /// This widget is shown in the dropdown when the search returns no results.
  final Widget? noItemsFoundBuilder;

  /// Maximum number of midpoints allowed.
  ///
  /// This limits the number of midpoint/stop fields that can be added.
  final int maxMidpoints;

  /// Whether to show the add stops/midpoints option
  ///
  /// When true, users can add intermediate stops between start and end locations.
  final bool showMidpoints;

  /// Creates a BaatoStartEndPlaceSearchDropdown widget.
  ///
  /// The [suggestionsBuilder] and [itemBuilder] parameters are required.
  const BaatoStartEndPlaceSearchDropdown({
    super.key,
    required this.suggestionsBuilder,
    required this.itemBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.initialStartText,
    this.initialEndText,
    this.startHintText = 'Start location',
    this.endHintText = 'End location',
    this.midpointHintText = 'Add stop',
    this.inputDecoration,
    this.onStartSuggestionSelected,
    this.onEndSuggestionSelected,
    this.onMidpointSuggestionSelected,
    this.onLocationsSwapped,
    this.onMidpointAdded,
    this.onMidpointRemoved,
    this.maxSuggestions = 5,
    this.showClearButton = true,
    this.suggestionsBoxDecoration,
    this.itemHeight = 50.0,
    this.autofocus = false,
    this.textStyle,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.maxMidpoints = 5,
    this.showMidpoints = true,
  });

  @override
  State<BaatoStartEndPlaceSearchDropdown<T>> createState() =>
      _BaatoStartEndPlaceSearchDropdownState<T>();
}

class _BaatoStartEndPlaceSearchDropdownState<T>
    extends State<BaatoStartEndPlaceSearchDropdown<T>> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final List<TextEditingController> _midpointControllers = [];

  final FocusNode _startFocusNode = FocusNode();
  final FocusNode _endFocusNode = FocusNode();
  final List<FocusNode> _midpointFocusNodes = [];

  final LayerLink _startLayerLink = LayerLink();
  final LayerLink _endLayerLink = LayerLink();
  final List<LayerLink> _midpointLayerLinks = [];

  OverlayEntry? _startOverlayEntry;
  OverlayEntry? _endOverlayEntry;
  final List<OverlayEntry?> _midpointOverlayEntries = [];

  Timer? _startDebounce;
  Timer? _endDebounce;
  final List<Timer?> _midpointDebounces = [];

  List<T> _startSuggestions = [];
  List<T> _endSuggestions = [];
  final List<List<T>> _midpointSuggestions = [];

  bool _isStartLoading = false;
  bool _isEndLoading = false;
  final List<bool> _isMidpointLoading = [];

  bool _showStartSuggestions = false;
  bool _showEndSuggestions = false;
  final List<bool> _showMidpointSuggestions = [];

  @override
  void initState() {
    super.initState();

    if (widget.initialStartText != null) {
      _startController.text = widget.initialStartText!;
    }

    if (widget.initialEndText != null) {
      _endController.text = widget.initialEndText!;
    }

    _startFocusNode.addListener(() {
      if (_startFocusNode.hasFocus) {
        _showStartOverlay();
      } else {
        _removeStartOverlay();
      }
    });

    _endFocusNode.addListener(() {
      if (_endFocusNode.hasFocus) {
        _showEndOverlay();
      } else {
        _removeEndOverlay();
      }
    });
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    for (var controller in _midpointControllers) {
      controller.dispose();
    }

    _startFocusNode.dispose();
    _endFocusNode.dispose();
    for (var focusNode in _midpointFocusNodes) {
      focusNode.dispose();
    }

    _startDebounce?.cancel();
    _endDebounce?.cancel();
    for (var debounce in _midpointDebounces) {
      debounce?.cancel();
    }

    _removeStartOverlay();
    _removeEndOverlay();
    for (var i = 0; i < _midpointOverlayEntries.length; i++) {
      _removeMidpointOverlay(i);
    }

    super.dispose();
  }

  void _onStartSearchChanged(String query) {
    _startDebounce?.cancel();
    _startDebounce = Timer(widget.debounceDuration, () {
      _getStartSuggestions(query);
    });
  }

  void _onEndSearchChanged(String query) {
    _endDebounce?.cancel();
    _endDebounce = Timer(widget.debounceDuration, () {
      _getEndSuggestions(query);
    });
  }

  void _onMidpointSearchChanged(String query, int index) {
    _midpointDebounces[index]?.cancel();
    _midpointDebounces[index] = Timer(widget.debounceDuration, () {
      _getMidpointSuggestions(query, index);
    });
  }

  Future<void> _getStartSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _startSuggestions = [];
        _showStartSuggestions = false;
      });
      _removeStartOverlay();
      return;
    }

    setState(() {
      _isStartLoading = true;
      _showStartSuggestions = true;
    });

    try {
      final suggestions = await widget.suggestionsBuilder(query);
      setState(() {
        _startSuggestions = suggestions.take(widget.maxSuggestions).toList();
        _isStartLoading = false;
      });
      _showStartOverlay();
    } catch (e) {
      setState(() {
        _startSuggestions = [];
        _isStartLoading = false;
      });
    }
  }

  Future<void> _getEndSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _endSuggestions = [];
        _showEndSuggestions = false;
      });
      _removeEndOverlay();
      return;
    }

    setState(() {
      _isEndLoading = true;
      _showEndSuggestions = true;
    });

    try {
      final suggestions = await widget.suggestionsBuilder(query);
      setState(() {
        _endSuggestions = suggestions.take(widget.maxSuggestions).toList();
        _isEndLoading = false;
      });
      _showEndOverlay();
    } catch (e) {
      setState(() {
        _endSuggestions = [];
        _isEndLoading = false;
      });
    }
  }

  Future<void> _getMidpointSuggestions(String query, int index) async {
    if (query.isEmpty) {
      setState(() {
        _midpointSuggestions[index] = [];
        _showMidpointSuggestions[index] = false;
      });
      _removeMidpointOverlay(index);
      return;
    }

    setState(() {
      _isMidpointLoading[index] = true;
      _showMidpointSuggestions[index] = true;
    });

    try {
      final suggestions = await widget.suggestionsBuilder(query);
      setState(() {
        _midpointSuggestions[index] =
            suggestions.take(widget.maxSuggestions).toList();
        _isMidpointLoading[index] = false;
      });
      _showMidpointOverlay(index);
    } catch (e) {
      setState(() {
        _midpointSuggestions[index] = [];
        _isMidpointLoading[index] = false;
      });
    }
  }

  void _showStartOverlay() {
    if (_startOverlayEntry != null || !_showStartSuggestions) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _startOverlayEntry = OverlayEntry(
      builder: (context) => _buildSuggestionsOverlay(
        _startLayerLink,
        _startSuggestions,
        _isStartLoading,
        size.width,
        (suggestion) {
          _startController.text = suggestion.toString();
          if (widget.onStartSuggestionSelected != null) {
            widget.onStartSuggestionSelected!(suggestion);
          }
          _removeStartOverlay();
        },
      ),
    );

    overlay.insert(_startOverlayEntry!);
  }

  void _showEndOverlay() {
    if (_endOverlayEntry != null || !_showEndSuggestions) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _endOverlayEntry = OverlayEntry(
      builder: (context) => _buildSuggestionsOverlay(
        _endLayerLink,
        _endSuggestions,
        _isEndLoading,
        size.width,
        (suggestion) {
          _endController.text = suggestion.toString();
          if (widget.onEndSuggestionSelected != null) {
            widget.onEndSuggestionSelected!(suggestion);
          }
          _removeEndOverlay();
        },
      ),
    );

    overlay.insert(_endOverlayEntry!);
  }

  void _showMidpointOverlay(int index) {
    if (_midpointOverlayEntries[index] != null ||
        !_showMidpointSuggestions[index]) {
      return;
    }

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _midpointOverlayEntries[index] = OverlayEntry(
      builder: (context) => _buildSuggestionsOverlay(
        _midpointLayerLinks[index],
        _midpointSuggestions[index],
        _isMidpointLoading[index],
        size.width,
        (suggestion) {
          _midpointControllers[index].text = suggestion.toString();
          if (widget.onMidpointSuggestionSelected != null) {
            widget.onMidpointSuggestionSelected!(suggestion, index);
          }
          _removeMidpointOverlay(index);
        },
      ),
    );

    overlay.insert(_midpointOverlayEntries[index]!);
  }

  void _removeStartOverlay() {
    _startOverlayEntry?.remove();
    _startOverlayEntry = null;
  }

  void _removeEndOverlay() {
    _endOverlayEntry?.remove();
    _endOverlayEntry = null;
  }

  void _removeMidpointOverlay(int index) {
    _midpointOverlayEntries[index]?.remove();
    _midpointOverlayEntries[index] = null;
  }

  Widget _buildSuggestionsOverlay(
    LayerLink layerLink,
    List<T> suggestions,
    bool isLoading,
    double width,
    Function(T) onSelected,
  ) {
    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: const Offset(0, 50),
      child: Material(
        elevation: 4.0,
        child: Container(
          width: width,
          constraints: BoxConstraints(
            maxHeight: 300, // Set a reasonable max height for the overlay
          ),
          decoration: widget.suggestionsBoxDecoration ??
              BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
          child: _buildSuggestionsList(suggestions, isLoading, onSelected),
        ),
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;

  Widget _buildSuggestionsList(
    List<T> suggestions,
    bool isLoading,
    Function(T) onSelected,
  ) {
    if (isLoading) {
      return Center(
        child: widget.loadingBuilder ?? const CircularProgressIndicator(),
      );
    } else if (suggestions.isEmpty) {
      return widget.noItemsFoundBuilder ??
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No suggestions found'),
            ),
          );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return InkWell(
            onTap: () => onSelected(suggestion),
            child: SizedBox(
              height: widget.itemHeight,
              child: widget.itemBuilder(suggestion),
            ),
          );
        },
      );
    }
  }

  void _swapLocations() {
    final startText = _startController.text;
    final endText = _endController.text;

    setState(() {
      _startController.text = endText;
      _endController.text = startText;
    });

    if (widget.onLocationsSwapped != null) {
      widget.onLocationsSwapped!(endText, startText);
    }
  }

  void _addMidpoint() {
    if (_midpointControllers.length >= widget.maxMidpoints) return;

    final controller = TextEditingController();
    final focusNode = FocusNode();
    final layerLink = LayerLink();

    setState(() {
      _midpointControllers.add(controller);
      _midpointFocusNodes.add(focusNode);
      _midpointLayerLinks.add(layerLink);
      _midpointSuggestions.add([]);
      _isMidpointLoading.add(false);
      _showMidpointSuggestions.add(false);
      _midpointOverlayEntries.add(null);
      _midpointDebounces.add(null);
    });

    final index = _midpointControllers.length - 1;

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _showMidpointOverlay(index);
      } else {
        _removeMidpointOverlay(index);
      }
    });

    if (widget.onMidpointAdded != null) {
      widget.onMidpointAdded!();
    }
  }

  void _removeMidpoint(int index) {
    if (index < 0 || index >= _midpointControllers.length) return;

    _midpointControllers[index].dispose();
    _midpointFocusNodes[index].dispose();
    _midpointDebounces[index]?.cancel();
    _removeMidpointOverlay(index);

    setState(() {
      _midpointControllers.removeAt(index);
      _midpointFocusNodes.removeAt(index);
      _midpointLayerLinks.removeAt(index);
      _midpointSuggestions.removeAt(index);
      _isMidpointLoading.removeAt(index);
      _showMidpointSuggestions.removeAt(index);
      _midpointOverlayEntries.removeAt(index);
      _midpointDebounces.removeAt(index);
    });

    if (widget.onMidpointRemoved != null) {
      widget.onMidpointRemoved!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Start location field
        CompositedTransformTarget(
          link: _startLayerLink,
          child: TextField(
            controller: _startController,
            focusNode: _startFocusNode,
            style: widget.textStyle,
            autofocus: widget.autofocus,
            decoration: widget.inputDecoration ??
                InputDecoration(
                  hintText: widget.startHintText,
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
                  suffixIcon:
                      widget.showClearButton && _startController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _startController.clear();
                                setState(() {
                                  _startSuggestions = [];
                                  _showStartSuggestions = false;
                                });
                                _removeStartOverlay();
                              },
                            )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
            onChanged: _onStartSearchChanged,
            onTap: () {
              if (_startController.text.isNotEmpty) {
                _getStartSuggestions(_startController.text);
              }
            },
          ),
        ),

        const SizedBox(height: 8),

        // Midpoint fields
        if (widget.showMidpoints)
          ...List.generate(_midpointControllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CompositedTransformTarget(
                      link: _midpointLayerLinks[index],
                      child: TextField(
                        controller: _midpointControllers[index],
                        focusNode: _midpointFocusNodes[index],
                        style: widget.textStyle,
                        decoration: widget.inputDecoration ??
                            InputDecoration(
                              hintText: widget.midpointHintText,
                              prefixIcon: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              suffixIcon: widget.showClearButton &&
                                      _midpointControllers[index]
                                          .text
                                          .isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _midpointControllers[index].clear();
                                        setState(() {
                                          _midpointSuggestions[index] = [];
                                          _showMidpointSuggestions[index] =
                                              false;
                                        });
                                        _removeMidpointOverlay(index);
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                        onChanged: (query) =>
                            _onMidpointSearchChanged(query, index),
                        onTap: () {
                          if (_midpointControllers[index].text.isNotEmpty) {
                            _getMidpointSuggestions(
                              _midpointControllers[index].text,
                              index,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeMidpoint(index),
                  ),
                ],
              ),
            );
          }),

        // Add midpoint button
        if (widget.showMidpoints &&
            _midpointControllers.length < widget.maxMidpoints)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add stop'),
              onPressed: _addMidpoint,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

        const SizedBox(height: 8),

        // End location field with swap button
        Row(
          children: [
            Expanded(
              child: CompositedTransformTarget(
                link: _endLayerLink,
                child: TextField(
                  controller: _endController,
                  focusNode: _endFocusNode,
                  style: widget.textStyle,
                  decoration: widget.inputDecoration ??
                      InputDecoration(
                        hintText: widget.endHintText,
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        suffixIcon: widget.showClearButton &&
                                _endController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _endController.clear();
                                  setState(() {
                                    _endSuggestions = [];
                                    _showEndSuggestions = false;
                                  });
                                  _removeEndOverlay();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                  onChanged: _onEndSearchChanged,
                  onTap: () {
                    if (_endController.text.isNotEmpty) {
                      _getEndSuggestions(_endController.text);
                    }
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.swap_vert, color: Colors.blue),
              onPressed: _swapLocations,
              tooltip: 'Swap start and end locations',
            ),
          ],
        ),
      ],
    );
  }
}
