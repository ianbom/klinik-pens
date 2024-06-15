import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class BuildSheet extends StatelessWidget {
  final VoidCallback? onTapEdit;
  final VoidCallback onTapDelete;
  final String deleteOrRestoreData;
  const BuildSheet(
      {super.key, this.onTapEdit, required this.onTapDelete, required this.deleteOrRestoreData});

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
              onTapEdit != null
              ? GestureDetector(
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
              ) : Container(),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: onTapDelete,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          deleteOrRestoreData =='Delete Data'? Icons.delete_forever_outlined: Entypo.clock,
                          color: Color(0xFFE5484D),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      deleteOrRestoreData,
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
