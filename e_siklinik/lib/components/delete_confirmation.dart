// dialog_utils.dart
import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, VoidCallback onDelete, String customMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: Color(0xFFE74F4F)), // Border color
        ),
        elevation: 8.0,
        backgroundColor: Colors.white, // Background color
        title: const Center(
            child: Text(
          'Warning!',
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('$customMessage this item? This action',
                style: const TextStyle(fontWeight: FontWeight.w600)),
           const Text('cannot be undone.',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: 75,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(18))),
                  child: const Center(child: Text("Cancel", style: TextStyle(fontWeight:FontWeight.w600))),
                ),
              ),
              const SizedBox(width: 15,),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
                child: Container(
                  height: 45,
                  width: 75,
                  decoration: const BoxDecoration(
                      color: Color(0xFFE74F4F),
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  child: const Center(child: Text("Yes", style: TextStyle(color: Color(0xFFFCFCFD), fontWeight:FontWeight.w600),)),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}

