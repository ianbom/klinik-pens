import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class BuildSheet extends StatelessWidget {
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;
  const BuildSheet(
      {super.key, required this.onTapEdit, required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 150,
            height: 5,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFF234DF0)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              GestureDetector(
                onTap: onTapEdit,
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 30,
                        height: 30,
                        child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(
                              FontAwesome5.edit,
                              color: Color(0xFF234DF0),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Edit Data",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: onTapDelete,
                child: const Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: Color(0xFFE5484D),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Delete Data",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
