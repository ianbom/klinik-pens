import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define KategoriObat class
class KategoriObat {
  final String name;
  KategoriObat({required this.name});
}

// Custom drop-down display
Widget _customDropDownKategoriObat(BuildContext context, KategoriObat? item) {
  return Container(
    child: (item == null)
        ? const ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              "Search",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(235, 158, 158, 158),
              ),
            ),
          )
        : ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              item.name,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, color: Colors.black),
            ),
          ),
  );
}

// Dummy data fetching method
Future<List<KategoriObat>> getData(String filter, {required String KategoriId}) async {
  // Replace with your actual data fetching logic
  return Future.delayed(
    Duration(seconds: 1),
    () => List.generate(
      10,
      (index) => KategoriObat(name: 'Category $index'),
    ).where((item) => item.name.contains(filter)).toList(),
  );
}

// Custom popup item builder
Widget _customPopupItemBuilder(BuildContext context, KategoriObat item, bool isSelected) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
    child: ListTile(
      title: Text(
        item.name,
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 102, 100, 100),
        ),
      ),
    ),
  );
}

class DropdownKategoriObat extends StatelessWidget {
  final String KategoriId;

  DropdownKategoriObat({required this.KategoriId});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return DropdownSearch<KategoriObat>(
      asyncItems: (String? filter) => getData(filter ?? "", KategoriId: KategoriId),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: 'Search Categories',
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
        ),
      ),
      dropdownBuilder: _customDropDownKategoriObat,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        itemBuilder: _customPopupItemBuilder,
      ),
      onChanged: (KategoriObat? object) {
        // Handle selection
      },
      clearButtonProps: ClearButtonProps(
        isVisible: false,
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.clear, size: 17, color: Colors.black),
        ),
      ),
    );
  }
}
