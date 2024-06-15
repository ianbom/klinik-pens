import 'package:flutter/material.dart';

class AutocompleteTextField extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onItemSelected;

  AutocompleteTextField({
    required this.items,
    required this.onItemSelected,
  });

  @override
  _AutocompleteTextFieldState createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> _filteredItems = [];
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 140,
        height: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _filteredItems.map((item) {
                return ListTile(
                  title: Text(item['nama_obat']),
                  subtitle: Text("Tanggal Kadaluarsa: ${item['tanggal_kadaluarsa']}"),
                  onTap: () {
                    _controller.text = item['nama_obat'];
                    widget.onItemSelected(item);
                    _hideOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          return item['nama_obat']
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });

    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _onTap() {
    _showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              hintText: 'Cari Obat',
              border:InputBorder.none,
            ),
            onChanged: (value) {
              _filterItems(value);
              if (_overlayEntry == null) {
                _showOverlay();
              }
            },
            onTap: () {
              if (_controller.text.isEmpty) {
                setState(() {
                  _filteredItems = widget.items;
                });
              }
              _showOverlay();
            },
          ),
        ],
      ),
    );
  }
}